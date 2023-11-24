import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:influenza/firebase_options.dart';

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
    return Column(
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
                border: OutlineInputBorder(),
                labelText: "Email Address"),
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
              border: OutlineInputBorder(),
              labelText: "Password"),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton(
              onPressed: () async {
                try {
                  final email = _email.text;
                  final password = _password.text;

                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  } else if (e.code == 'invalid-email') {
                    print('This is not a valid email');
                  }
                } catch (e) {
                  print(e);
                }
                // print(userCredential);
              },
              child: const Text("Register")),
        ),
      ],
    );
  }
}
