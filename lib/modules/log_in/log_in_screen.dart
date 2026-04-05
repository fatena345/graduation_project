import 'package:flutter/material.dart';
import 'package:project/core/theme/style.dart';
import 'package:project/auth_componets/login_form.dart';
import 'package:project/auth_componets/header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isPassword = true;

  void togglePassword() {
    setState(() {
      isPassword = !isPassword;
    });
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      print(emailController.text + "   /   " + passwordController.text);
      emailController.clear();
      passwordController.clear();
      //
      // login logic
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Styles.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Header(),
            Expanded(
              child: LoginForm(
                formKey: formKey,
                emailController: emailController,
                passwordController: passwordController,
                isPassword: isPassword,
                togglePassword: togglePassword,
                onLogin: login,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
