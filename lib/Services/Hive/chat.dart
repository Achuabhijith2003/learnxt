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
      required this.firstName});

  // List<ChatMessage> chat;
  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime createdAt;
  @HiveField(2)
  String text;
  @HiveField(3)
  String? firstName;
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
        id: user!.id);
    // geting no of chats
    Chatidputandget chatidget = Chatidputandget();
    int i = await chatidget.getid(docId);
    print("Chatid put while store: $i");
    box.put("$docId/$i", chat);
  }

  fechallchat(docid) {
    try {
      // geting no of chats
      int i = 1;
      Chatidputandget chatidget = Chatidputandget();
      int j = chatidget.getid(docid);
      print("Chatid put while fecht: $j");
      while (i <= j) {
        Chat chatdata = box.get("$docid/$i") as Chat;
        ChatMessage chathis = ChatMessage(
          user: ChatUser(id: chatdata.id, firstName: chatdata.firstName),
          createdAt: chatdata.createdAt,
          text: chatdata.text,
        );
        print("While looping for fetch $i");
        i++;
        return chathis;
      }
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
        user: ChatUser(id: chatdata.id, firstName: chatdata.firstName),
        createdAt: chatdata.createdAt,
        text: chatdata.text,
      );
      print("While looping for fetch $j");
      return chathis;
    } catch (e) {
      print("Error: $e");
    }
  }
}
