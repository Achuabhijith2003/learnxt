import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDB {
  final user = FirebaseAuth.instance.currentUser;
 Future<List<Map<String, dynamic>>> getUserdetailes() async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('User');

    final query =
        collection.where('UID', isEqualTo: user?.uid); // Example condition

    final querySnapshot = await query.get();
    final data = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(data);
    return data;
  }
}
