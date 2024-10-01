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
  void initState() {
    super.initState();
    BannerAdload();
    // loadChatMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
    print("MEssage INserted");
  }

  late BannerAd _bannerAd;
  bool isbanneradsload = false;
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
  final geminiuser = const types.User(id: '0', firstName: "Learnxt");
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
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35)),
                      color: Color(0xFFEFFFFC),
                    ),
                    child: Chat(
                      messages: _messages,
                      onSendPressed: sendChatMessage,
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
    // Update chat ID
    // int newId = chatid.getid(docId) + 1;
    // chatid.putid(newId, docId);

    // // Store chat message
    // await chatstore.storechat(botname, currentUser, chatMessage, docId);

    // Fetch and update messages (consider optimization)
    // final updatedChatMessage = await chatstore.fechchat(docId);
    setState(() {
      final textMessage = types.TextMessage(
        author: cureentUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().toString(), // Ensuring a unique ID for each message
        text: chatMessage.text,
      );
      _addMessage(textMessage);
    });

    try {
      // Search for keywords and generate answer
      final keywords =
          await _dataEmbedded.searchAndAnswer(chatMessage.text, widget.docId);
      print('Generated answer: $keywords');

      gemini
          .streamGenerateContent(
        "Considering the keywords: $keywords and the query: ${chatMessage.text}, here is a detailed answer.",
      )
          .listen((event) async {
        types.TextMessage? lastMessage =
            _messages.firstOrNull as types.TextMessage?;
        if (lastMessage != null && lastMessage.author == geminiuser) {
          lastMessage = _messages.removeAt(0) as types.TextMessage?;
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          // lastMessage.text += response;
          setState(
            () {
              _addMessage(lastMessage!);
            },
          );
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          // Storing gemini Respones
          types.TextMessage geminimessage = types.TextMessage(
            author: geminiuser,
            id: '0',
            text: response,
          );

          // int newId =
          //     chatid.getid(docId) + 1; // Ensure ID generation logic is safe
          // chatid.putid(newId, docId);

          // // Store chat message
          // await chatstore.storechat(botname, geminiuser, geminimessage, docId);
          // final geminiresponse = await chatstore.fechchat(docId);
          setState(() {
            _addMessage(geminimessage);
          });
        }
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
