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

  Future<bool> deleteNotes(notedocid) async {
    try {
      final notes = await FirebaseFirestore.instance
          .collection('bot')
          .doc(parentdocid)
          .collection('notes')
          .where('notedocid', isEqualTo: notedocid)
          .get();
      if (notes.docs.isNotEmpty) {
        for (var doc in notes.docs) {
          await doc.reference.delete();
        }
        return true;
      } else {
        print('No notes found with the given notedocid.');
        return false;
      }
    } catch (e) {
      print('Error fetching notes: $e');
      return false;
    }
  }
}
