import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:influenza/constants/routes.dart';
import 'package:influenza/firebase_options.dart';
import 'package:influenza/views/login_view.dart';
import 'package:influenza/views/register_view.dart';
import 'package:influenza/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Influenza App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 36, 69, 158)),
        useMaterial3: true,
      ),
      home: const HomePage(),
      // Named routes [https://docs.flutter.dev/cookbook/navigation/named-routes]
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        influenzaHomeRoute: (context) => const InfluenzaView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const InfluenzaView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout }

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
