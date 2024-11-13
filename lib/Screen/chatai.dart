import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:learnxt/Services/AI/gemini.dart';
import 'package:learnxt/Services/Hive/chat.dart';
import 'package:learnxt/Services/Hive/chatid.dart';

class Chatai extends StatefulWidget {
  final String botname;
  final String docId;
  const Chatai({super.key, required this.botname, required this.docId});

  @override
  State<Chatai> createState() => _ChataiState();
}

class _ChataiState extends State<Chatai> {
  // final DataEmbedded _dataEmbedded = DataEmbedded();
  // final Gemini gemini = Gemini.instance;
  final AI _ai = AI();
  Chatputandget chatstore = Chatputandget();
  Chatidputandget chatid = Chatidputandget();
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
        adUnitId: "ca-app-pub-8568607330093795/5482884902",
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
      id: '0', firstName: "Learnxt", imageUrl: "assets/ai logo.jpeg");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF171717),
      body: SizedBox(
        width: double.infinity,
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(begin: Alignment.topCenter, colors: [
        //   Colors.grey.shade900,
        //   Colors.grey.shade800,
        //   Colors.grey.shade400
        // ])),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Color.fromARGB(255, 14, 60, 13),
                              ),
                            ],
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.botname,
                        style: GoogleFonts.dmSerifDisplay(
                            fontSize: 30, letterSpacing: 4),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                top: 85,
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
                      theme: const DefaultChatTheme(
                        inputBackgroundColor: Colors.grey,
                        inputTextDecoration:
                            InputDecoration(labelText: "Enter prompt"),
                        messageBorderRadius: 35,
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
  }

  void sendChatMessage(types.PartialText chatMessage) async {
    int newId = chatid.getid(widget.docId);

    try {
      final aiRespoines = await _ai.geminirespones(chatMessage.text);
      print("Gemini Respones: ${aiRespoines.toString()}");
      // Search for keywords and generate an answer
      // final keywords =
      //     await _dataEmbedded.searchAndAnswer(chatMessage.text, widget.docId);
      // print('Generated answer: $keywords');

      // gemini
      //     .streamGenerateContent(
      //   modelName: "models/gemini-1.5-flash",
      //   "who Create Learnxt",
      // )
      //     .listen((event) async {
      //   String response = event.content?.parts?.fold(
      //           "", (previous, current) => "$previous ${current.text}") ??
      //       "";

      //   // Check for the last message from geminiuser
      //   types.TextMessage? lastMessage =
      //       _messages.firstOrNull as types.TextMessage?;
      //   if (lastMessage != null && lastMessage.author == geminiuser) {
      //     // Create an updated message by appending response
      //     final updatedMessage = types.TextMessage(
      //       author: lastMessage.author,
      //       id: "$newId", // Keep the same ID
      //       createdAt: lastMessage.createdAt,
      //       text: lastMessage.text + response, // Append the response
      //     );

      //     print("lastMessage: $updatedMessage");
      //     await chatstore.storechat(updatedMessage, widget.docId,
      //         updatedMessage.text, widget.botname);
      //     setState(() {
      //       int index = _messages.indexOf(lastMessage);
      //       if (index != -1) {
      //         _messages[index] = updatedMessage; // Update in place
      //       }
      //     });
      //   } else {
      //     // No last message from geminiuser, create a new one
      types.TextMessage geminimessage = types.TextMessage(
        author: geminiuser,
        id: "$newId",
        text: aiRespoines,
      );

      await chatstore.storechat(
          geminimessage, widget.docId, geminimessage.text, widget.botname);

      //     // Store the chat message
      //     // int newId = chatid.getid(widget.docId) + 1;
      //     // chatid.putid(newId, widget.docId);

      //     // await chatstore.storechat(
      //     //     widget.botname, geminiuser, geminimessage, widget.docId);
      //     // Fetch the stored response and add it
      //     print("Gemini respose: $geminimessage");

      setState(() {
        _addMessage(geminimessage, geminimessage.text);
      });
      //   }
      // });
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
