import 'package:flutter/material.dart';

import 'widgets/sign_in_form.dart';

class LoginPage extends StatefulWidget {
  final String? email;

  const LoginPage({super.key, this.email});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: SignInForm(email: widget.email),
            ),
          ),
        ),
      ),
    );
  }
}
