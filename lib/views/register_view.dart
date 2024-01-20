import 'package:flutter/material.dart';
import 'package:influenza/constants/routes.dart';
import 'package:influenza/services/auth/auth_exceptions.dart';
import 'package:influenza/utilities/go_router.dart';
import 'package:influenza/utilities/show_error_dialog.dart';
import 'package:influenza/services/auth/auth_service.dart';

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
                    await AuthService.firebase().createUser(
                      email: email,
                      password: password,
                    );
                    AuthService.firebase().sendEmailVerification();
                    Navigator.of(context).pushNamed(
                        verifyEmailRoute); //we dont use removeuntil because we want to retain the routes
                  } on EmailAlreadyInUseException {
                    await showErrorDialog(
                      context,
                      'Email already in use',
                    );
                  } on WeakPasswordAuthException {
                    await showErrorDialog(
                      context,
                      'Weak password',
                    );
                  } on InvalidEmailAuthException {
                    await showErrorDialog(
                      context,
                      'This is an invalid email address',
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                      context,
                      'Fail to register',
                    );
                  }
                },
                child: const Text("Register")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.tonal(
                onPressed: () {
                  goRouter.goNamed('login');
                },
                child: const Text('Already registered? Login here!')),
          )
        ],
      ),
    );
  }
}
