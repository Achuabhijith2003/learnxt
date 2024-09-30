import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:learnxt/Screen/home.dart';

class Chatai extends StatefulWidget {
  final String botname;
  final String docId;
  const Chatai({super.key, required this.botname, required this.docId});

  @override
  State<Chatai> createState() => _ChataiState();
}

class _ChataiState extends State<Chatai> {
  void initState() {
    super.initState();
    BannerAdload();
    // loadChatMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
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

  // Message ff = Message(
  //     emojiEnlargementBehavior: emojiEnlargementBehavior,
  //     hideBackgroundOnEmojiMessages: true,
  //     message: message,
  //     messageWidth: 100,
  //     roundBorder: true,
  //     showAvatar: true,
  //     showName: true,
  //     showStatus: true,
  //     isLeftStatus: true,
  //     showUserAvatars: true,
  //     textMessageOptions: textMessageOptions,
  //     usePreviewData: true);

  final _user = const types.User(id: '1', firstName: "Learnxt");

  final textMessage = types.TextMessage(
    author: const types.User(id: "1"),
    createdAt: DateTime.now().millisecondsSinceEpoch,
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
    text:
        "**message**  \n __dvfdv__ #dfvf jfsdhjs sbjgj jkjkvhjkshjkhjbhjkgh jk hjkggg  gjh ghg  hgg hghg  hgjhig ghkhhghg",
  );

  final List<types.Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    var   _handleMessageTap;
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
                    child: Container(
                      child: Chat(
                        messages: _messages,
                        // onAttachmentPressed: _handleAttachmentPressed,
                        onMessageTap: _handleMessageTap,
                        // onPreviewDataFetched: _handlePreviewDataFetched,
                        onSendPressed: (p0) {
                          _addMessage(textMessage);
                        },
                        showUserAvatars: true,
                        showUserNames: true,
                        user: _user,
                      ),
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
}
