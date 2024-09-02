// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:learnxt/Services/Hive/chat.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:learnxt/Services/data_embedded.dart';

class AiChat extends StatefulWidget {
  final String botname;
  final String docId;
  const AiChat({super.key, required this.botname, required this.docId});
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _AiChatState createState() => _AiChatState(botname: botname, docId: docId);
}

final Gemini gemini = Gemini.instance;
Chatputandget chatstore = Chatputandget();
Chatidputandget chatid = Chatidputandget();

List<ChatMessage> messages = [];
ChatUser currentUser = ChatUser(id: "0", firstName: "User");
ChatUser geminiuser = ChatUser(
    id: "1", firstName: "LearnXT", profileImage: 'assets/ai pro pic.jpeg');

// ignore: non_constant_identifier_names

class _AiChatState extends State<AiChat> {
  // ignore: duplicate_ignore
  // ignore: prefer_typing_uninitialized_variables
  final botname;
  final docId;

  @override
  void initState() {
    super.initState();
    loadChatMessages();
  }

  Future<void> loadChatMessages() async {
    final chatMessage = await chatstore.fechallchat(docId);
    setState(() {
      messages = chatMessage;
    });
  }

  @override
  void dispose() {
    super.dispose();
    messages = [];
  }

  _AiChatState({required this.botname, required this.docId});
  // ignore: non_constant_identifier_names

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  final DataEmbedded _dataEmbedded = DataEmbedded();

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
                            color: Color.fromARGB(255, 48, 121, 51),
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
      inputOptions: const InputOptions(
        trailing: [
          // IconButton(
          //   onPressed: _sendMediaMessage,
          //   icon: const Icon(
          //     Icons.image,
          //     color: Color.fromARGB(255, 29, 235, 2),
          //   ),
          // )
        ],
        alwaysShowSend: true,
        inputDecoration: InputDecoration(hintText: "Enter the promt"),
        inputTextStyle: TextStyle(color: Colors.black),
        sendOnEnter: false,
      ),
      currentUser: currentUser,
      onSend: sendChatMessage,
      messages: messages,
    );
  }

  void sendChatMessage(ChatMessage chatMessage) async {
    // Update chat ID
    int newId = chatid.getid(docId) + 1; // Ensure ID generation logic is safe
    chatid.putid(newId, docId);

    // Store chat message
    await chatstore.storechat(botname, currentUser, chatMessage, docId);

    // Fetch and update messages (consider optimization)
    final updatedChatMessage = await chatstore.fechchat(docId);
    setState(() {
      messages = [
        updatedChatMessage,
        ...messages
      ]; // Update message list (explore efficient methods)
    });

    try {
      // Search for keywords and generate answer
      final keywords =
          await _dataEmbedded.searchAndAnswer(chatMessage.text, docId);
      print('Generated answer: $keywords');

      gemini
          .streamGenerateContent(
        "Considering the keywords: $keywords and the query: ${chatMessage.text}, here is a detailed answer.",
      )
          .listen((event) async {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiuser) {
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
          ChatMessage geminimessage = ChatMessage(
            user: geminiuser,
            createdAt: DateTime.now(),
            text: response,
          );
          int newId =
              chatid.getid(docId) + 1; // Ensure ID generation logic is safe
          chatid.putid(newId, docId);

          // Store chat message
          await chatstore.storechat(botname, geminiuser, geminimessage, docId);
          final geminiresponse = await chatstore.fechchat(docId);

          setState(() {
            messages = [geminiresponse, ...messages];
          });
        }
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
