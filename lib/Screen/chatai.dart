import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:learnxt/Screen/Preminum/vip.dart';
import 'package:learnxt/Screen/Settings.dart';
import 'package:learnxt/Services/AI/data_embedded.dart';
import 'package:learnxt/Services/AI/gemini.dart';
import 'package:learnxt/Services/Chats/Chat_Operations.dart';
import 'package:learnxt/Services/Hive/chat.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:learnxt/Services/gadsmob.dart';

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
  addpdfs(docid) async {
    List<File> files = [];
// pick files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();

      return showDialog(
        context: context,
        barrierDismissible: false, // Disable user interaction while uploading
        builder: (context) {
          return AlertDialog(
            title: const Text("Selected PDF Files"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true, // Make the list view wrap its content
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(files[index].path.split('/').last),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  ads.AppOpenAdload();
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Disable user interaction while uploading
                    builder: (context) => const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                  CollectionReference insertfilename =
                      FirebaseFirestore.instance.collection('bot');
                  DataEmbedded dataEmbedded = DataEmbedded();
                  final List<String> filenames = [];
                  dataEmbedded.getDocId(docid);
                  for (File file in files) {
                    final fileName =
                        file.path.split('/').last; // Extract file name
                    filenames.add(fileName);
                    await dataEmbedded.pdfextract(file);
                  }
                  await insertfilename.doc(docid).update({
                    'pdfs_name': FieldValue.arrayUnion(filenames),
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // Close the dialog
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
                child: const Text("ADD"),
              ),
            ],
          );
        },
      );
    }
  }
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
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        width: 0,
                      ),
                      Text(
                        widget.botname,
                        style: GoogleFonts.dmSerifDisplay(
                            fontSize: 30, letterSpacing: 4),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(),
                      const Divider(),
                      // menu button
                      PopupMenuButton(
                        child: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: const ListTile(
                              title: Text("Add PDFs"),
                              leading: Icon(Icons.add),
                            ),
                            onTap: () {
                              addpdfs(widget.docId);
                            },
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: const ListTile(
                              title: Text("Clear Chats"),
                              leading: Icon(Icons.clear_all_sharp),
                            ),
                            onTap: () async {
                              return showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Prevent dismissing while loading
                                builder: (context) => AlertDialog(
                                  title: const Text("Clear chats"),
                                  content: const Text(
                                      "Are you sure you want to Clear Chats?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) => const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        );

                                        final clearsucessfully =
                                            chatstore.clearchat(widget.docId);
                                        loadChatMessages();

                                        if (clearsucessfully) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Chats cleared successfully!'),
                                              backgroundColor: Colors.grey,
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Chats cleared failed!'),
                                              backgroundColor: Colors.grey,
                                            ),
                                          );
                                        }
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text(
                                        "clear",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          PopupMenuItem(
                            value: 3,
                            child: const ListTile(
                              title: Text("Delete AI bot"),
                              leading: Icon(Icons.delete),
                            ),
                            onTap: () async {
                              return showDialog(
                                context: context,
                                barrierDismissible:
                                    !isLoading, // Prevent dismissing while loading
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete AI"),
                                  content: const Text(
                                      "Are you sure you want to delete the AI Bot?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) => const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        );

                                        // setState(() {
                                        //   isLoading = true; // Start loading
                                        // });

                                        final deletesuccessfully = await chatop
                                            .deletebot(widget.docId);

                                        // setState(() {
                                        //   isLoading = false; // Stop loading
                                        // });

                                        if (deletesuccessfully) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Bot deleted successfully!'),
                                              backgroundColor: Colors.grey,
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Bot deletion failed!'),
                                              backgroundColor: Colors.grey,
                                            ),
                                          );
                                        }
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          PopupMenuItem(
                            value: 4,
                            child: const ListTile(
                              title: Text("Settings"),
                              leading: Icon(Icons.settings),
                            ),
                            onTap: () {
                              Navigator.push(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UiSettings(),
                                  ));
                            },
                          ),
                          PopupMenuItem(
                            value: 5,
                            child: const ListTile(
                              title: Text("Go Premium"),
                              leading: Icon(Icons.workspace_premium_outlined),
                            ),
                            onTap: () {
                              Navigator.push(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Vip(),
                                  ));
                            },
                          ),
                        ],
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
            content:
                Text("The service is currently busy. Please try again later."),
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
