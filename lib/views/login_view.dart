import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:influenza/constants/routes.dart';
import 'package:influenza/utilities/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                return null;
              },
              decoration: const InputDecoration(
                  hintText: "Enter your email address here",
                  prefixIcon: Icon(Icons.email)),
            ),
            TextFormField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: const InputDecoration(
                  hintText: "Enter your password here",
                  prefixIcon: Icon(Icons.password)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton(
                  onPressed: () async {
                    final email = _email.text.trim();
                    final password = _password.text.trim();
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      final user = FirebaseAuth.instance.currentUser;
                      if (user?.emailVerified ?? false) {
                        // user's email is verified
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          influenzaHomeRoute,
                          (route) => false,
                        );
                      } else {
                        // user's email is not verified
                        Navigator.of(context).pushNamed(verifyEmailRoute);
                      }
                      // else {
                      //   navigator.pushNamedAndRemoveUntil(
                      //       '/verify/', (route) => false);
                      // }
                    } on FirebaseAuthException catch (e) {
                      //handling all FirebaseAuth exceptions
                      devtools.log('Failed with error code:  ${e.code}');
                      if (e.code == 'invalid-email') {
                        await showErrorDialog(context, 'Invalid email');
                      } else if (e.code == 'wrong-password') {
                        await showErrorDialog(context, 'Invalid password');
                      } else if (e.code == 'user-not-found') {
                        await showErrorDialog(context, 'User not found');
                      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
                        await showErrorDialog(
                            context, 'Your email or password could be wrong');
                      } else {
                        await showErrorDialog(context, 'Error: ${e.code}');
                      }
                    } catch (e) {
                      //for handling generic exceptions
                      await showErrorDialog(context, e.toString());
                    }
                  },
                  child: const Text("Login")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (route) => false,
                  );
                },
                child: const Text(
                  'Not registered yet?, Register here!',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
