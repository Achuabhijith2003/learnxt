import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnxt/Auth/Authservices.dart';
import 'package:learnxt/Services/gadsmob.dart';

class ChatOperations {
  final Authservices _authservices = Authservices();

  admob ads = admob();
  // ignore: non_constant_identifier_names
  Future<List<Map<String, dynamic>>> fetch_user_profile() async {
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
      print("Fetch profile error : $e");
      return [];
    }
  }

  Future<bool> deletebot(String docId) async {
    ads.AppOpenAdload();
    try {
      final docRef = FirebaseFirestore.instance.collection('bot').doc(docId);

      // Delete the 'dataEmbedded' subcollection
      final dataEmbeddedSubcollection = docRef.collection("dataEmbedded");
      try {
        await dataEmbeddedSubcollection.get().then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });
        print('dataEmbedded subcollection deleted successfully');
      } catch (e) {
        print('Error deleting dataEmbedded subcollection: $e');
      }

      // Delete the 'notes' subcollection
      final notesSubcollection = docRef.collection("notes");
      try {
        await notesSubcollection.get().then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });
        print('notes subcollection deleted successfully');
      } catch (e) {
        print('Error deleting notes subcollection: $e');
      }

      // Delete the main document
      await docRef.delete();
      print('Main document deleted successfully');
      return true; // Deletion successful
    } catch (error) {
      print('Error deleting document: $error');
      return false; // Deletion failed
    }
  }

  Future<bool> deleteAllBot() async {
    ads.RewardedAdload();
    String uid = _authservices.getuserID(); // Get the current user's UID
    try {
      // Query the 'Bot' collection where the UID matches
      final getDocIDcollection = FirebaseFirestore.instance
          .collection('bot')
          .where("UID", isEqualTo: uid);

      // Fetch the matching documents
      final querySnapshot = await getDocIDcollection.get();

      if (querySnapshot.docs.isEmpty) {
        // No documents found
        print("No data found for UID: $uid");
        return false;
      }

      // Iterate through the documents and delete them
      for (var doc in querySnapshot.docs) {
        print("Deleting Document ID: ${doc.id}");

        // Check and delete the 'dataEmbedded' subcollection if it exists
        final dataEmbeddedRef = FirebaseFirestore.instance
            .collection('bot')
            .doc(doc.id)
            .collection('dataEmbedded');
        final dataEmbeddedSnapshot = await dataEmbeddedRef.get();

        if (dataEmbeddedSnapshot.docs.isNotEmpty) {
          for (var subDoc in dataEmbeddedSnapshot.docs) {
            await dataEmbeddedRef.doc(subDoc.id).delete();
            print(
                "Deleted dataEmbedded Subcollection Document ID: ${subDoc.id}");
          }
        }

        // Check and delete the 'note' subcollection if it exists
        final noteRef = FirebaseFirestore.instance
            .collection('bot')
            .doc(doc.id)
            .collection('notes');
        final noteSnapshot = await noteRef.get();

        if (noteSnapshot.docs.isNotEmpty) {
          for (var subDoc in noteSnapshot.docs) {
            await noteRef.doc(subDoc.id).delete();
            print("Deleted note Subcollection Document ID: ${subDoc.id}");
          }
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
