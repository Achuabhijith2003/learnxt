
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNotes {
  String? parentdocid;

// add notes in firebase
  addnote(question, answer) async {
    try {
      final  parentDocRef =
         FirebaseFirestore.instance.collection('bot').doc(parentdocid).collection('notes');
      parentDocRef.add({
        'Question':question,
        'Answer': answer,
        'created_at': DateTime.now(),
      });

      return true;
    } catch (e) {
      print('Error storing Notes: $e');
      return false;
    } 
  }

}