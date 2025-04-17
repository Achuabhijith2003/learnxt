import 'package:hive/hive.dart';
import 'package:learnxt/main.dart';

part 'chatid.g.dart';

@HiveType(typeId: 0)
class Chatid {
  Chatid(this.totalchat, this.docid);

  @HiveField(0)
  int totalchat;

  @HiveField(1)
  String docid;
}

class Chatidputandget {
  putid(int i, String docid) {
    print("Chatid put: $i");
    final chatid = Chatid(i, docid);
    box.put(docid, chatid);
  }

  getid(String docid) {
    final id = box.get(docid) as Chatid?;
    if (id == null) {
      // Use a logging framework instead of print
      print("Chatid get: 0");
      return 0;
    } else {
      // Use a logging framework instead of print
      print("Chatid get: ${id.totalchat}");
      return id.totalchat;
    }
  }
}
