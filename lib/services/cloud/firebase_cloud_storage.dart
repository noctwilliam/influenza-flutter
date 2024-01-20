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

  /// Retrieves the history of all severities for a specific owner user.
  ///
  /// The [ownerUserId] parameter specifies the ID of the owner user.
  /// Returns a [Stream] of [Iterable] of [CloudSeverity] objects representing the history.
  /// The stream emits a new iterable whenever there is a change in the history.
  /// Only [CloudSeverity] objects with matching [ownerUserId] are included in the result.
  Stream<Iterable<CloudSeverity>> allHistory({required String ownerUserId}) =>
      history
          .orderBy(dateCreatedField,
              descending: true) // Sort by dateCreatedField in descending order
          .snapshots()
          .map((event) => event.docs
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
          .orderBy(dateCreatedField, descending: true)
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudSeverity.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllHistoryExceptions();
    }
  }

  /// This method takes in the [ownerUserId] and [severity] as required parameters.
  /// It adds a new document to the 'history' collection in the Firebase Cloud Storage
  /// with the provided [ownerUserId] and [severity] values.
  ///
  /// Returns a [Future] that completes with a [CloudSeverity] object containing
  /// the document ID, owner user ID, severity, and the date it was created.
  Future<CloudSeverity> createNewHistory(
      {required String ownerUserId, required String severity}) async {
    final document = await history.add({
      ownerUserIdField: ownerUserId,
      severityField: severity,
      dateCreatedField: DateTime.now(),
    });
    final fetchedNote = await document.get();
    return CloudSeverity(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      severity: severity,
      dateCreated: DateTime.now(),
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
