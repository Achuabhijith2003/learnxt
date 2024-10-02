import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:learnxt/Services/Hive/chat.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:learnxt/Services/data_embedded.dart';

class Chatai extends StatefulWidget {
  final String botname;
  final String docId;
  const Chatai({super.key, required this.botname, required this.docId});

  @override
  State<Chatai> createState() => _ChataiState();
}

class _ChataiState extends State<Chatai> {
  final DataEmbedded _dataEmbedded = DataEmbedded();
  final Gemini gemini = Gemini.instance;
  Chatputandget chatstore = Chatputandget();
  Chatidputandget chatid = Chatidputandget();
  @override
  void initState() {
    super.initState();
    loadChatMessages();
    BannerAdload();
  }

  Future<void> loadChatMessages() async {
    final chatMessage = await chatstore.fechallchat(widget.docId);
    setState(() {
      _messages.insertAll(0, chatMessage);
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
    print("Message inserted");
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
    id: '0',
    firstName: "Learnxt",
  );
  final List<types.Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF171717),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.green.shade900,
          Colors.green.shade800,
          Colors.green.shade400
        ])),
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
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Color.fromARGB(255, 14, 60, 13),
                              ),
                            ],
                          )),
                      TextButton(
                        onPressed: () {
                          // Navigate to bot profile
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const BotProfile()));
                        },
                        child: Text(
                          widget.botname,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Color.fromARGB(255, 14, 60, 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                      const Divider()
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35)),
                      color: Color(0xFFEFFFFC),
                    ),
                    child: Chat(
                      inputOptions: const InputOptions(
                        autocorrect: true,
                        enableSuggestions: true,
                        sendButtonVisibilityMode:
                            SendButtonVisibilityMode.always,
                        inputClearMode: InputClearMode.always,
                      ),
                      theme: const DefaultChatTheme(
                        backgroundColor: Color(0xFFEFFFFC),
                        inputBackgroundColor: Color.fromARGB(255, 12, 95, 15),
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
                          id: DateTime.now()
                              .toString(), // Ensuring a unique ID for each message
                          text: p0.text,
                        );

                        // Store chat message
                        await chatstore.storechat(widget.botname, cureentUser,
                            textMessage, widget.docId);
                        setState(() {
                          _addMessage(textMessage);
                        });
                        sendChatMessage(p0);
                      },
                      showUserAvatars: true,
                      showUserNames: true,
                      user: cureentUser,
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
    try {
      // Search for keywords and generate answer
      final keywords =
          await _dataEmbedded.searchAndAnswer(chatMessage.text, widget.docId);
      print('Generated answer: $keywords');

      gemini
          .streamGenerateContent(
        "Based on the keywords: $keywords and the question: ${chatMessage.text}, explain the answer in a simple and easy-to-understand way for a student, breaking down any difficult concepts and using examples where possible.",
      )
          .listen((event) async {
        types.TextMessage? lastMessage =
            _messages.firstOrNull as types.TextMessage?;
        if (lastMessage != null && lastMessage.author == geminiuser) {
          // Get the response text
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";

          // Create a new message with the updated text
          final updatedMessage = types.TextMessage(
            author: lastMessage.author,
            id: DateTime.now().toString(),
            createdAt: DateTime.now().millisecondsSinceEpoch,

            text: lastMessage.text + response, // Append the response
          );

          // Replace the old message in the list instead of removing it
          setState(() {
            _addMessage(updatedMessage);
          });
        } else {
          // Handle the case where there was no previous message
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";

          // Storing Gemini Response as a new message
          types.TextMessage geminimessage = types.TextMessage(
            author: geminiuser,
            id: DateTime.now().toString(),
            text: response,
          );

          int newId = chatid.getid(widget.docId) +
              1; // Ensure ID generation logic is safe
          chatid.putid(newId, widget.docId);

          // Store chat message
          await chatstore.storechat(
              widget.botname, geminiuser, geminimessage, widget.docId);
          final geminiresponse = await chatstore.fechchat(widget.docId);

          // Add the new message
          setState(() {
            _addMessage(geminiresponse);
          });
        }
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
