import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('An error occurred'),
        content: Text(
          text,
          style: const TextStyle(fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // a better way to do this is to use overlay
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
