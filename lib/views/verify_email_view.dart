import 'package:flutter/material.dart';
import 'package:influenza/constants/routes.dart';
import 'package:influenza/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Center(
        child: Column(
          children: [
            const Text(
                "We've sent you an email verification. Verify your email to continue"),
            const Text(
                "If you haven't received a verification email, click the verification button below to continue"),
            FilledButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Send email verification'),
            ),
            FilledButton.tonal(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
