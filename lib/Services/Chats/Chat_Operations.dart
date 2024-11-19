import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnxt/Auth/Authservices.dart';
import 'package:learnxt/Services/gadsmob.dart';

class ChatOperations {
  Authservices _authservices = Authservices();

  admob ads = admob();
  // ignore: non_constant_identifier_names
  fetch_user_profile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final firestore = FirebaseFirestore.instance;
      final collection = firestore.collection('User');

      final query =
          collection.where('UID', isEqualTo: user?.uid); // Example condition

      final querySnapshot = await query.get();
      final data = querySnapshot.docs.map((doc) => doc.data()).toList();
      return data;
    } catch (e) {
      print("Fetch prrofile error : $e");
    }
    // ... your existing fetchData logic ...

    // Access data as a list of Maps
    // print(data);
    //
    // Return the retrieved data list
    return [];
  }

  Future<bool> deletebot(String docId) async {
    ads.AppOpenAdload();
    try {
      final docRef = FirebaseFirestore.instance.collection('Bot').doc(docId);
      final subcollection = docRef.collection("dataEmbedded");
      try {
        await subcollection.get().then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });
        await docRef.delete();

        print('Subcollection deleted successfully');
        return true; // Deletion successful
      } catch (e) {
        print('Error deleting subcollection: $e');
      }

      return true; // Deletion successful
    } catch (error) {
      return false; // Deletion failed
    }
  }

  
}
