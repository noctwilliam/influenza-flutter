import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:influenza/constants/routes.dart';
import 'package:influenza/utilities/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        children: [
          Center(
            child: TextFormField(
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
                  try {
                    final email = _email.text.trim();
                    final password = _password.text.trim();
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);
                    devtools.log(userCredential.toString());
                  } on FirebaseAuthException catch (e) {
                    // for firebaseauth exceptions
                    if (e.code == 'email-already-in-use') {
                      await showErrorDialog(context,
                          'The account already exists for that email.');
                    } else if (e.code == 'weak-password') {
                      await showErrorDialog(
                          context, 'The password provided is too weak.');
                    } else if (e.code == 'invalid-email') {
                      devtools.log('');
                      await showErrorDialog(
                          context, 'This is not a valid email');
                    }
                  } catch (e) {
                    //again for generic exceptions
                    await showErrorDialog(context, e.toString());
                  }
                },
                child: const Text("Register")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text('Already registered? Login here!')),
          )
        ],
      ),
    );
  }
}
