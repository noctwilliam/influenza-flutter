import 'package:flutter/material.dart';
import 'package:influenza/constants/routes.dart';
import 'package:influenza/services/auth/auth_exceptions.dart';
import 'package:influenza/utilities/go_router.dart';
import 'package:influenza/utilities/show_error_dialog.dart';
import 'package:influenza/services/auth/auth_service.dart';

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
                      await AuthService.firebase().logIn(
                        email: email,
                        password: password,
                      );

                      final user = AuthService.firebase().currentUser;
                      if (user?.isEmailVerified ?? false) {
                        // user's email is verified
                        goRouter.goNamed('home');
                      } else {
                        // user's email is not verified
                        goRouter.goNamed('verify');
                      }
                    } on UserNotFoundAuthException {
                      await showErrorDialog(
                        context,
                        'User not found',
                      );
                    } on WrongPasswordAuthException {
                      await showErrorDialog(
                        context,
                        'Wrong password',
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        'Authentication error',
                      );
                    }
                  },
                  child: const Text("Login")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton.tonal(
                onPressed: () {
                  goRouter.goNamed('register');
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
