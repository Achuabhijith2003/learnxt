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
  var docid;
  Chatputandget(this.docid);

  storechat(
    String botname,
    ChatUser? user,
    ChatMessage message,
    dynamic docId,
  ) {
    final chat = Chat(
        createdAt: message.createdAt,
        text: message.text,
        firstName: user?.firstName,
        id: user!.id);
    box.put(docId, chat);
  }

  ChatUser featchcurrentuser() {
    // Implementation for fetching chat
    Chat chatdata = box.get(docid);
    print("${chatdata.text}");
    ChatUser currentuser = ChatUser(id: "0", firstName: chatdata.firstName);
    return currentuser;
  }

  ChatUser featchgeminiuser() {
    Chat chatdata = box.get(docid);
    print("${chatdata.text}");
    ChatUser geminiuser = ChatUser(
        id: "1",
        firstName: chatdata.firstName,
        profileImage: 'assets/ai pro pic.jpeg');
    return geminiuser;
  }
}
