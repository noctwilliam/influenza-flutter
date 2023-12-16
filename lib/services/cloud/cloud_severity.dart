import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:influenza/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudSeverity {
  final String documentId;
  final String ownerUserId;
  final String severity;
  const CloudSeverity({
    required this.documentId,
    required this.ownerUserId,
    required this.severity,
  });

  CloudSeverity.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdField],
        severity = snapshot.data()[severityField] as String;
}
