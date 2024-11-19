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
      final docRef = FirebaseFirestore.instance.collection('bot').doc(docId);
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

  Future<bool> deleteAllBot() async {
    String uid = _authservices.getuserID(); // Get the current user's UID
    // ads.AppOpenAdload(); // Load ads if needed
    try {
      // Query the 'Bot' collection where the UID matches
      final getDocIDcollection = FirebaseFirestore.instance
          .collection('bot')
          .where("UID", isEqualTo: uid);

      // Fetch the matching documents
      final querySnapshot = await getDocIDcollection.get();

      for (var doc in querySnapshot.docs) {
        print("Deleting Document ID: ${doc.id}");

        // Delete the subcollection ('embeded') if it exists
        final subcollectionRef = FirebaseFirestore.instance
            .collection('Bot')
            .doc(doc.id)
            .collection('dataEmbedded');
        final subcollectionSnapshot = await subcollectionRef.get();

        for (var subDoc in subcollectionSnapshot.docs) {
          await subcollectionRef.doc(subDoc.id).delete();
          print("Deleted Subcollection Document ID: ${subDoc.id}");
        }

        // Delete the main document in 'Bot' collection
        await FirebaseFirestore.instance.collection('bot').doc(doc.id).delete();
        print("Deleted Main Document ID: ${doc.id}");
      }

      print('All documents and subcollections deleted successfully');
      return true; // Deletion successful
    } catch (error) {
      print('Error deleting documents: $error');
      return false; // Deletion failed
    }
  }
}
