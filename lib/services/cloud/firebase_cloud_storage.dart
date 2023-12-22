import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:influenza/services/cloud/cloud_severity.dart';
import 'package:influenza/services/cloud/cloud_storage_constants.dart';
import 'package:influenza/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final history = FirebaseFirestore.instance.collection('history');

  Future<void> deleteHistory({required String documentId}) async {
    try {
      await history.doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeleteHistoryExceptions();
    }
  }

  // could not see use case for update in this class

  Stream<Iterable<CloudSeverity>> allHistory({required String ownerUserId}) =>
      history.snapshots().map((event) => event.docs
          .map((doc) => CloudSeverity.fromSnapshot(doc))
          .where((history) => history.ownerUserId == ownerUserId));

  Future<Iterable<CloudSeverity>> getHistory(
      {required String ownerUserId}) async {
    try {
      return await history
          .where(
            ownerUserIdField,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudSeverity(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdField] as String,
                  severity: doc.data()[severityField] as String,
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllHistoryExceptions();
    }
  }

  void createNewHistory({required String ownerUserId}) async {
    await history.add({
      ownerUserIdField: ownerUserId,
      severityField: '',
    });
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
