import 'package:cloud_firestore/cloud_firestore.dart';

class Notes {
  String? parentdocid;

// add notes in firebase
  addnote(question, answer) async {
    try {
      final parentDocRef = FirebaseFirestore.instance
          .collection('bot')
          .doc(parentdocid)
          .collection('notes');
      final newNoteRef = await parentDocRef.add({
        'Question': question,
        'Answer': answer,
        'created_at': DateTime.now(),
      });

      await newNoteRef.update({
        'notedocid': newNoteRef.id,
      });

      return true;
    } catch (e) {
      print('Error storing Notes: $e');
      return false;
    }
  }

  Future<QuerySnapshot> getNotes() async {
    try {
      final notes = await FirebaseFirestore.instance
          .collection('bot')
          .doc(parentdocid)
          .collection('notes')
          .get();
      return notes;
    } catch (e) {
      print('Error fetching notes: $e');
      rethrow;
    }
  }
}
