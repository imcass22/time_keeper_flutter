import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloud_note.dart';
import 'cloud_storage_constants.dart';
import 'cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final text = FirebaseFirestore.instance.collection('userText');

  Future<void> deleteText({required String documentId}) async {
    try {
      await text.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String note,
  }) async {
    try {
      await text.doc(documentId).update({noteFieldName: note});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> updateRegularHours({
    required String documentId,
    required double regularHours,
  }) async {
    try {
      await text.doc(documentId).update({regularHoursFieldName: regularHours});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> updateOvertimeHours({
    required String documentId,
    required double overtimeHours,
  }) async {
    try {
      await text
          .doc(documentId)
          .update({overtimeHoursFieldName: overtimeHours});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> updateMileage({
    required String documentId,
    required double mileage,
  }) async {
    try {
      await text.doc(documentId).update({mileageFieldName: mileage});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  // snapshot is used to grab a stream of data and changes happening live
  Stream<Iterable<CloudNote>> allText({required String ownerUserId}) {
    final allText = text
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allText;
  }

  Future<CloudNote> createNewText({required String ownerUserId}) async {
    final document = await text.add({
      //ownerUserIdFieldName: ownerUserId,
      noteFieldName: '',
      regularHoursFieldName: 0,
      overtimeHoursFieldName: 0,
      mileageFieldName: 0,
    });
    final fetchedText = await document.get();
    return CloudNote(
      documentId: fetchedText.id,
      ownerUserId: ownerUserId,
      regularHours: 0,
      overtimeHours: 0,
      mileage: 0,
      note: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
