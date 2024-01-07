import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:influenza/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudSeverity {
  final String documentId;
  final String ownerUserId;
  final String severity;
  final DateTime dateCreated;
  const CloudSeverity({
    required this.documentId,
    required this.ownerUserId,
    required this.severity,
    required this.dateCreated,
  });

  /// Creates a [CloudSeverity] object from a [QueryDocumentSnapshot].
  ///
  /// The [snapshot] parameter is the document snapshot containing the data.
  /// The [documentId] property is set to the ID of the snapshot.
  /// The [ownerUserId] property is set to the value of the 'ownerUserId' field in the snapshot data.
  /// The [severity] property is set to the value of the 'severity' field in the snapshot data as a string.
  /// The [dateCreated] property is set to the value of the 'dateCreated' field in the snapshot data as a [DateTime] object.
  CloudSeverity.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdField],
        severity = snapshot.data()[severityField] as String,
        dateCreated = (snapshot.data()[dateCreatedField] as Timestamp).toDate();
}
