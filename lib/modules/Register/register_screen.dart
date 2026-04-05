import 'package:flutter/material.dart';
import 'package:project/core/theme/style.dart';
import 'package:project/auth_componets/header.dart';
import 'package:project/auth_componets/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  String? selectedRole;

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      print(
        "${emailController.text} / "
        "${passwordController.text} / "
        "${selectedRole ?? 'no role'}",
      );

      emailController.clear();
      passwordController.clear();

      setState(() {
        selectedRole = null;
      });

      /// register logic here
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
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
              child: RegisterForm(
                formKey: formKey,
                emailController: emailController,
                passwordController: passwordController,
                onRegister: register,
                selectedRole: selectedRole,
                onRoleChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
