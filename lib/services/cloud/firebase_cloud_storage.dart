import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudStorage {
  final history = FirebaseFirestore.instance.collection('history');

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
