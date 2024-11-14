import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:learnxt/main.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

part 'chat.g.dart';

@HiveType(typeId: 1)
class CHathive {
  CHathive(
      {required this.id,
      required this.userid,
      required this.createdAt,
      required this.text,
      required this.firstName,
      this.profileimg});

  // List<ChatMessage> chat;
  @HiveField(0)
  String id;
  @HiveField(1)
  int? createdAt;
  @HiveField(2)
  String text;
  @HiveField(3)
  String? firstName;
  @HiveField(4)
  String? profileimg;
  @HiveField(5)
  String userid;
}

class Chatputandget extends Chatidputandget {
  Future<void> storechat(
      types.Message message, String docId, String text, String botname) async {
    int newId = getid(docId);
    // Store chat message with the updated ID
    final chat = CHathive(
      createdAt: message.createdAt,
      text: text,
      userid: message.author.id,
      firstName: message.author.firstName,
      id: message.id,
      profileimg: message.author.imageUrl,
    );

    // Store the message using newId as part of the key
    box.put("$docId/$newId", chat);

    print("Chat message stored with ID: $newId for docId: $docId");
  }

  List<types.Message> messages = []; // Initialize an empty list
  Future<List<types.Message>> fechallchat(String docId) async {
    try {
      int i = 1;
      int totalMessages = getid(docId);

      // Loop through and fetch messages
      while (i <= totalMessages) {
        CHathive chatData = box.get("$docId/$i") as CHathive;
        print("id: $i text : ${chatData.text} ");
        // ignore: unnecessary_null_comparison
        if (chatData != null) {
          // Convert CHathive to TextMessage
          types.TextMessage chatMessage = types.TextMessage(
            createdAt: chatData.createdAt,
            text: chatData.text,
            author:
                types.User(id: chatData.userid, imageUrl: chatData.profileimg),
            id: chatData.id,
          );

          // Add message to the list
          _addMessage(chatMessage);
        }
        i++;
      }
    } catch (e) {
      print("Error: $e");
    }

    return messages; // Return the list of messages
  }

  void _addMessage(types.Message message) {
    messages.insert(0, message);

    print("MEssage INserted");
  }

  Future<String> fetchChatuser(String docId) async {
    try {
      final chatCount = getid(docId);
      print("Chat count for docId $docId: ${chatCount - 3}");

      CHathive chatData = box.get("$docId/${chatCount - 3}");
      final text = chatData.text; // Use null-aware operator

      final chats = types.TextMessage(
        createdAt: chatData.createdAt,
        text: text,
        author: types.User(id: chatData.userid, imageUrl: chatData.profileimg),
        id: chatData.id,
      );
      return chats.text;
    } catch (e) {
      print("Error fetching chat: $e");
      return "null"; // Or provide a more informative error message
    }
  }
    Future<String> fetchChatai(String docId) async {
    try {
      final chatCount = getid(docId);
      print("Chat count for docId $docId: ${chatCount - 2}");

      CHathive chatData = box.get("$docId/${chatCount - 2}");
      final text = chatData.text; // Use null-aware operator

      final chats = types.TextMessage(
        createdAt: chatData.createdAt,
        text: text,
        author: types.User(id: chatData.userid, imageUrl: chatData.profileimg),
        id: chatData.id,
      );
      return chats.text;
    } catch (e) {
      print("Error fetching chat: $e");
      return "null"; // Or provide a more informative error message
    }
  }

  initallchat() async {
    // ... your existing fetchData logic ...
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('Bot');

    final query =
        collection.where('UID', isEqualTo: user?.uid); // Example condition
    try {
      final querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var element in querySnapshot.docs) {
          final docId = element.get("docId");
          putid(0, docId);
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  chatmodify(
    int id,
    types.Message message,
    String docId,
    String text,
  ) {
    // Store chat message with the updated ID
    final chat = CHathive(
      createdAt: message.createdAt,
      text: text,
      userid: message.author.id,
      firstName: message.author.firstName,
      id: message.id,
      profileimg: message.author.imageUrl,
    );

    // Store the message using newId as part of the key
    box.put("$docId/$id", chat);

    print("Modifed Chat message stored with ID: $id for docId: $docId");
  }
}
