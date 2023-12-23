import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:influenza/services/cloud/cloud_severity.dart';
import 'package:influenza/services/cloud/cloud_storage_constants.dart';
import 'package:influenza/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final history = FirebaseFirestore.instance.collection('history');

  /// Deletes a history document from the Firebase Cloud Firestore.
  ///
  /// Throws a [CouldNotDeleteHistoryExceptions] if the deletion fails.
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

  /// Retrieves the history of severities for a specific owner user.
  ///
  /// Returns a [Future] that resolves to an [Iterable] of [CloudSeverity] objects.
  /// The [ownerUserId] parameter is required and specifies the ID of the owner user.
  /// Throws a [CouldNotGetAllHistoryExceptions] if an error occurs while retrieving the history.
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
                  dateCreated:
                      (doc.data()[dateCreatedField] as Timestamp).toDate(),
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllHistoryExceptions();
    }
  }

  /// Creates a new history entry in Firebase Cloud Storage.
  ///
  /// The [ownerUserId] parameter is required and specifies the ID of the owner user.
  /// This method adds a new history entry with the specified [ownerUserId] and an empty severity field.
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
