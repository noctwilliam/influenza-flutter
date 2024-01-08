// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:influenza/services/auth/auth_service.dart';
import 'package:influenza/services/cloud/firebase_cloud_storage.dart';
import 'package:influenza/services/cloud/cloud_severity.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: FutureBuilder<Iterable<CloudSeverity>>(
        future: FirebaseCloudStorage()
            .getHistory(ownerUserId: AuthService.firebase().currentUser!.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final history = snapshot.data!;
            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final severity = history.elementAt(index);
                return ListTile(
                  title: Text(severity.severity),
                  subtitle: Text(severity.dateCreated.toString()),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
