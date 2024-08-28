import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:hive/hive.dart';
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
  DateTime createdAt;
  String text;
  String? firstName;
}

class Chatputandget {
  storechat(
    String botname,
    ChatUser? user,
    ChatMessage message,
    String docId,
  ) {
    final chat = Chat(
        createdAt: message.createdAt,
        text: message.text,
        firstName: user?.firstName,
        id: user!.id);
    box.put(docId, chat);
  }

  fechchat(docid) {
    try {
      Chat chatdata = box.get(docid);
      ChatMessage chathis = ChatMessage(
        user: ChatUser(id: chatdata.id),
        createdAt: chatdata.createdAt,
        text: chatdata.text,
      );
      return chathis;
    } catch (e) {
      print("Error: $e");
    }
  }
}
