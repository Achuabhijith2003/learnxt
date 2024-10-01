import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hive/hive.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:learnxt/main.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

part 'chat.g.dart';

@HiveType(typeId: 1)
class CHathive {
  CHathive(
      {required this.id,
      required this.createdAt,
      required this.text,
      required this.firstName,
      required this.profileimg});

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
}

class Chatputandget {
  storechat(
    String botname,
    types.User? user,
    TextMessage message,
    String docId,
  ) async {
    final chat = CHathive(
        createdAt: message.createdAt,
        text: message.text,
        firstName: user?.firstName,
        id: user!.id,
        profileimg: user.imageUrl);
    // geting no of chats
    Chatidputandget chatidget = Chatidputandget();
    int i = await chatidget.getid(docId);
    print("Chatid put while store: $i");
    box.put("$docId/$i", chat);
  }

  List<types.Message> messages = [];
  fechallchat(docid) {
    try {
      List<types.Message> messages = [];
      // geting no of chats
      int i = 1;
      Chatidputandget chatidget = Chatidputandget();
      int j = chatidget.getid(docid);
      print("Chatid put while fecht: $j");
      while (i <= j) {
        CHathive chatdata = box.get("$docid/$i") as CHathive;
        TextMessage chathis = TextMessage(
            createdAt: chatdata.createdAt,
            text: chatdata.text,
            author: types.User(id: chatdata.id),
            id: chatdata.id);
        print("While looping for fetch $i");
        i++;
        _addMessage(chathis as Message);
      }
      return messages;
    } catch (e) {
      print("Error: $e");
    }
  }

  void _addMessage(types.Message message) {
    messages.add(message);

    print("MEssage INserted");
  }

  fechchat(docid) async {
    try {
      // geting no of chats

      Chatidputandget chatidget = Chatidputandget();
      int j = chatidget.getid(docid);
      print("Chatid put while fecht: $j");

      CHathive chatdata = await box.get("$docid/$j") as CHathive;
      // ChatMessage chathis = ChatMessage(
      //   user: ChatUser(
      //       id: chatdata.id,
      //       firstName: chatdata.firstName,
      //       profileImage: chatdata.profileimg),
      //   createdAt: chatdata.createdAt,
      //   text: chatdata.text,
      // );
      TextMessage chathis = TextMessage(
          text: chatdata.text,
          author: types.User(id: chatdata.id),
          id: chatdata.id);
      print("While looping for fetch $j");
      return chathis;
    } catch (e) {
      print("Error: $e");
    }
  }

  initallchat() async {
    // ... your existing fetchData logic ...
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('Bot');
    Chatidputandget chatidput = Chatidputandget();

    final query =
        collection.where('UID', isEqualTo: user?.uid); // Example condition
    try {
      final querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var element in querySnapshot.docs) {
          final docId = element.get("docId");
          chatidput.putid(0, docId);
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }
}
