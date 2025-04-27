import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:learnxt/Services/AI/data_embedded.dart';
import 'package:learnxt/Services/AI/gemini.dart';
import 'package:learnxt/Services/Chats/Chat_Operations.dart';
import 'package:learnxt/Services/Chats/notes.dart';
import 'package:learnxt/Services/Hive/chat.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:learnxt/Services/gadsmob.dart';

import 'package:learnxt/theme/theme_model.dart';
import 'package:provider/provider.dart';

class Chatai extends StatefulWidget {
  final String botname;
  final String docId;
  const Chatai({super.key, required this.botname, required this.docId});

  @override
  State<Chatai> createState() => _ChataiState();
}

class _ChataiState extends State<Chatai> {
  admob ads = admob();
  final AI _ai = AI();
  final DataEmbedded _dataem = DataEmbedded();
  Chatputandget chatstore = Chatputandget();
  Chatidputandget chatid = Chatidputandget();
  ChatOperations chatop = ChatOperations();
  Notes addnotes = Notes();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    loadChatMessages();
    BannerAdload();
  }

  Future<void> loadChatMessages() async {
    final chatMessages = await chatstore.fechallchat(widget.docId);
    if (chatMessages.isNotEmpty) {
      setState(() {
        // Ensure no duplicate messages are inserted
        _messages.clear();
        _messages.insertAll(0, chatMessages);
      });
    }
  }

  Future<void> clearChatMessages() async {
    setState(() {
      // Ensure no duplicate messages are inserted
      _messages.clear();
    });
  }

// add pdfs

// ///////////////////////

  Future<void> _addMessage(types.Message message, String text) async {
    await chatstore.storechat(message, widget.docId, text, widget.botname);

    setState(() {
      if (!_messages.any((msg) => msg.id == message.id)) {
        _messages.insert(0, message);
      }
    });

    print("Message inserted: ${message.id}");
  }

  late BannerAd _bannerAd;
  bool isbanneradsload = false;
  // ignore: non_constant_identifier_names
  BannerAdload() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "", //ca-app-pub-8568607330093795/5482884902
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isbanneradsload = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print("Error in ads banner:$error");
          },
        ),
        request: const AdRequest());
    _bannerAd.load();
  }

  final cureentUser = const types.User(id: '1', firstName: "You");
  final geminiuser = const types.User(
      id: '0', firstName: "Learnxt", imageUrl: "assets/xt_logo.png");
  final List<types.Message> _messages = [];

  Future<void> deleteMessageAndReplace(int messageId) async {
    final deletedMessageIndex =
        _messages.indexWhere((msg) => msg.id == messageId.toString());

    if (deletedMessageIndex != -1) {
      // Update the message in the database
      final deletedMessage = types.TextMessage(
        author: _messages[deletedMessageIndex].author,
        createdAt: _messages[deletedMessageIndex].createdAt,
        id: _messages[deletedMessageIndex].id,
        text: "__Message Deleted__",
      );

      // Replace the message content locally with "__Message Deleted__"
      setState(() {
        _messages[deletedMessageIndex] = deletedMessage;
      });

      await chatstore.chatmodify(
          messageId, deletedMessage, widget.docId, "__Message Deleted__");

      // Reload messages to reflect the changes if necessary
      // loadChatMessages();
    }
  }

  Future<void> getmessage(int messageId) async {
    try {
      print("MessageID:$messageId");

      if ((messageId - 1) != 0) {
        // Get the question and answer messages
        final questionMessage =
            chatstore.getsinglechat(widget.docId, "${messageId - 1}") ??
                "Question not Found";

        final answerMessage =
            chatstore.getsinglechat(widget.docId, "$messageId") ??
                "Answer not found";
        print("Question: $questionMessage");
        print("Answer: $answerMessage");

        bool isnoteadded =
            await addnotes.addnote(questionMessage, answerMessage);
        if (isnoteadded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notes added successfully!'),
              backgroundColor: Colors.grey,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add notes.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'First Question cannot added to the notes select the answer'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error in adding notes ingetmessage: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add notes.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        backgroundColor:
            themeNotifier.isDark ? Colors.grey.shade900 : Colors.white,
        // backgroundColor: const Color(0xFF171717),
        body: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Chat(
                        inputOptions: const InputOptions(
                          autocorrect: true,
                          enableSuggestions: true,
                          sendButtonVisibilityMode:
                              SendButtonVisibilityMode.always,
                          inputClearMode: InputClearMode.always,
                        ),
                        theme: DefaultChatTheme(
                          backgroundColor: themeNotifier.isDark
                              ? Colors.grey.shade900
                              : Colors.white,
                          inputBackgroundColor: Colors.black,
                          inputTextDecoration:
                              const InputDecoration(labelText: "Enter prompt"),
                          messageBorderRadius: 15,
                        ),
                        messages: _messages,
                        onSendPressed: (p0) async {
                          // Update chat ID
                          int newId = chatid.getid(widget.docId) + 1;
                          chatid.putid(newId, widget.docId);

                          final textMessage = types.TextMessage(
                            author: cureentUser,
                            createdAt: DateTime.now().millisecondsSinceEpoch,
                            id: "$newId", // Ensuring a unique ID for each message
                            text: p0.text,
                          );
                          print("before sd to chatfunction");
                          // Store chat message
                          // await chatstore.storechat(widget.botname, cureentUser,
                          //     textMessage, widget.docId);
                          setState(() {
                            _addMessage(textMessage, textMessage.text);
                          });
                          print("after sd to chatfunction");
                          newId = chatid.getid(widget.docId) + 1;
                          chatid.putid(newId, widget.docId);
                          sendChatMessage(p0);
                        },
                        showUserAvatars: true,
                        showUserNames: true,
                        user: cureentUser,
                        onMessageLongPress: (context, p1) {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => AlertDialog(
                              title: const Center(child: Text("Options")),
                              actions: [
                                Column(
                                  children: [
                                    Center(
                                      child: TextButton(
                                        onPressed: () async {
                                          // Convert id to integer and handle any errors
                                          var newId = int.tryParse(p1.id);
                                          if (newId == null) {
                                            print("Invalid ID: ${p1.id}");
                                            return;
                                          } else {
                                            print(
                                                "Parsed ID successfully: $newId");
                                          }

                                          addnotes.parentdocid = widget.docId;
                                          getmessage(newId);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Add Notes ➡️",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: TextButton(
                                        onPressed: () async {
                                          // Convert id to integer and handle any errors
                                          var newId = int.tryParse(p1.id);
                                          if (newId == null) {
                                            print("Invalid ID: ${p1.id}");
                                            return;
                                          } else {
                                            print(
                                                "Parsed ID successfully: $newId");
                                          }

                                          deleteMessageAndReplace(newId);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Delete Chat",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );

                          print("P1 ID: ${p1.id}");
                          print("Context: $context");
                        },
                      )))
            ],
          ),
        ),
        bottomNavigationBar: isbanneradsload
            ? SizedBox(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              )
            : const SizedBox(),
      );
    });
  }

  void sendChatMessage(types.PartialText chatMessage) async {
    int newId = chatid.getid(widget.docId);

    bool haswordSummary = chatMessage.text.contains("Summary");

    if (haswordSummary) {
      print("Summary found");
    } else {
      try {
        // Keyword generator
        final keywords =
            await _dataem.searchAndAnswer(chatMessage.text, widget.docId);
        print('Generated answer: $keywords');
        final aiRespoines = await _ai.geminirespones(
            chatMessage.text, widget.docId, keywords, context);
        print("Gemini Respones: ${aiRespoines.toString()}");
        if (aiRespoines.toString() == "null") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "The service is currently busy. Please try again later."),
              backgroundColor: Colors.grey,
            ),
          );
        }

        types.TextMessage geminimessage = types.TextMessage(
          author: geminiuser,
          id: "$newId",
          text: aiRespoines,
        );

        await chatstore.storechat(
            geminimessage, widget.docId, geminimessage.text, widget.botname);
        if (aiRespoines == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chats cleared successfully!'),
              backgroundColor: Colors.grey,
            ),
          );
        }

        setState(() {
          _addMessage(geminimessage, geminimessage.text);
        });
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }
}
