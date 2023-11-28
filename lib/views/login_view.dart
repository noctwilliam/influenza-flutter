import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                  hintText: "Enter your email here",
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
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password);
                      print(userCredential);
                      print('yuh we logged in');
                    } on FirebaseAuthException catch (e) {
                      print('Failed with error code:  ${e.code}');
                      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
                        print("You have entered an invalid email or password.");
                      }
                    }
                  },
                  child: const Text("Login")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton.tonal(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/register/', (route) => false);
                  },
                  child: const Text('Not registered yet?, Register here!')),
            )
          ],
        ),
      ),
    );
  }
}
