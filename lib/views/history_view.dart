// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:influenza/services/auth/auth_service.dart';
import 'package:influenza/services/cloud/firebase_cloud_storage.dart';
import 'package:influenza/services/cloud/cloud_severity.dart';
import 'package:intl/intl.dart';

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
      body: StreamBuilder<Iterable<CloudSeverity>>(
        stream: FirebaseCloudStorage().allHistory(
          ownerUserId: AuthService.firebase().currentUser!.id,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error retrieving history'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No history'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final history = snapshot.data!.elementAt(index);
              return ListTile(
                title: Text(
                  history.severity,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd - kk:mm').format(history.dateCreated),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await FirebaseCloudStorage().deleteHistory(
                      documentId: history.documentId,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
