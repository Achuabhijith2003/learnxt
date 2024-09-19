import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:learnxt/main.dart';

part 'chat.g.dart';

@HiveType(typeId: 1)
class Chat {
  Chat(
      {required this.id,
      required this.createdAt,
      required this.text,
      required this.firstName,
      required this.profileimg});

  // List<ChatMessage> chat;
  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime createdAt;
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
    ChatUser? user,
    ChatMessage message,
    String docId,
  ) async {
    final chat = Chat(
        createdAt: message.createdAt,
        text: message.text,
        firstName: user?.firstName,
        id: user!.id,
        profileimg: user.profileImage);
    // geting no of chats
    Chatidputandget chatidget = Chatidputandget();
    int i = await chatidget.getid(docId);
    print("Chatid put while store: $i");
    box.put("$docId/$i", chat);
  }

  fechallchat(docid) {
    try {
      List<ChatMessage> messages = [];
      // geting no of chats
      int i = 1;
      Chatidputandget chatidget = Chatidputandget();
      int j = chatidget.getid(docid);
      print("Chatid put while fecht: $j");
      while (i <= j) {
        Chat chatdata = box.get("$docid/$i") as Chat;
        ChatMessage chathis = ChatMessage(
          user: ChatUser(
              id: chatdata.id,
              firstName: chatdata.firstName,
              profileImage: chatdata.profileimg),
          createdAt: chatdata.createdAt,
          text: chatdata.text,
        );
        print("While looping for fetch $i");
        i++;
        messages = [chathis, ...messages];
      }
      return messages;
    } catch (e) {
      print("Error: $e");
    }
  }

  fechchat(docid) async {
    try {
      // geting no of chats

      Chatidputandget chatidget = Chatidputandget();
      int j = chatidget.getid(docid);
      print("Chatid put while fecht: $j");

      Chat chatdata = await box.get("$docid/$j") as Chat;
      ChatMessage chathis = ChatMessage(
        user: ChatUser(
            id: chatdata.id,
            firstName: chatdata.firstName,
            profileImage: chatdata.profileimg),
        createdAt: chatdata.createdAt,
        text: chatdata.text,
      );
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
