import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnxt/Services/data_embedded.dart';

class AiChat extends StatefulWidget {
  final String botname;
  final String docId;
  const AiChat({super.key, required this.botname, required this.docId});

  @override
  _AiChatState createState() => _AiChatState(botname: botname, docId: docId);
}

final Gemini gemini = Gemini.instance;

List<ChatMessage> messages = [];

ChatUser currentUser = ChatUser(id: "0", firstName: "User");
ChatUser geminiUser = ChatUser(
  id: "1",
  firstName: "Gemini",
  profileImage:
      "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
);

class _AiChatState extends State<AiChat> {
  final botname;
  final docId;
  _AiChatState({required this.botname, required this.docId});
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  DataEmbedded _dataEmbedded = DataEmbedded();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      // backgroundColor: const Color(0xFF171717),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFFEFFFFC)),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 36, left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.green,
                          )),
                      Text(
                        botname,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
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
                top: 100,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Color(0xFFEFFFFC),
                    ),
                    child: _buildUI()))
          ],
        ),
      ),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: const InputOptions(trailing: [
        // IconButton(
        //   onPressed: _sendMediaMessage,
        //   icon: const Icon(
        //     Icons.image,
        //     color: Color.fromARGB(255, 29, 235, 2),
        //   ),
        // )
      ]),
      currentUser: currentUser,
      onSend: sdmessang,
      messages: messages,
    );
  }

  void sdmessang(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      final keywords = await _dataEmbedded.searchAndAnswer(
          chatMessage.text, docId); // Ensure to pass the correct parentdocid
      print('Generated answer: $keywords');
      gemini
          .streamGenerateContent(
        'Generate an answer based on the following text: $keywords, given the query: ${chatMessage.text}',
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;
          setState(
            () {
              messages = [lastMessage!, ...messages];
            },
          );
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });

      // ChatMessage message = ChatMessage(
      //   user: geminiUser,
      //   createdAt: DateTime.now(),
      //   text: answer,
      // );
      // setState(() {
      //   messages = [message, ...messages];
      // });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;
          setState(
            () {
              messages = [lastMessage!, ...messages];
            },
          );
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

//   void _sendMediaMessage() async {
//     ImagePicker picker = ImagePicker();
//     XFile? file = await picker.pickImage(
//       source: ImageSource.gallery,
//     );
//     if (file != null) {
//       ChatMessage chatMessage = ChatMessage(
//         user: currentUser,
//         createdAt: DateTime.now(),
//         text: "Describe this picture?",
//         medias: [
//           ChatMedia(
//             url: file.path,
//             fileName: "",
//             type: MediaType.image,
//           )
//         ],
//       );
//       _sendMessage(chatMessage);
//     }
//   }
// }
}
