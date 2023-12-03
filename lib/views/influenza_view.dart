import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:influenza/constants/routes.dart';
import 'package:influenza/enums/menu_action.dart';
import 'dart:developer' as devtools show log;

class InfluenzaView extends StatefulWidget {
  const InfluenzaView({super.key});

  @override
  State<InfluenzaView> createState() => _InfluenzaViewState();
}

class _InfluenzaViewState extends State<InfluenzaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (MenuAction value) async {
                devtools.log(value.toString());
                final navigator = Navigator.of(context);
                switch (value) {
                  case MenuAction.logout:
                    final logout = await showLogOutDialog(context);
                    devtools.log(logout.toString());
                    if (logout) {
                      await FirebaseAuth.instance.signOut();
                      navigator.pushNamedAndRemoveUntil(
                          loginRoute, (_) => false);
                    }
                }
              },
              itemBuilder: (context) => <PopupMenuEntry<MenuAction>>[
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text(
                    'Sign out',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: const Column());
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sign out'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
