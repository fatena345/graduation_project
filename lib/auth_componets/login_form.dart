import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/auth_componets/custom_button.dart';
import 'package:project/core/theme/style.dart';
import 'package:project/auth_componets/title_and_description.dart';
import 'package:project/auth_componets/register_row.dart';
import 'package:project/auth_componets/social_buttons.dart';
import 'package:project/shared/components/components.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPassword;
  final VoidCallback togglePassword;
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPassword,
    required this.togglePassword,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 16.h),
              const TitleAndDescription(
                title: 'Welcome back !',
                description: 'Please enter your information to continue',
              ),
              SizedBox(height: 32.h),
              formFeild(
                controller: emailController,
                keyboard: TextInputType.emailAddress,
                label: 'Email Address',
                prefix: const Icon(Icons.email),
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email must not be empty';
                  }

                  if (!value.contains('@')) {
                    return 'Enter valid email';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16.h),
              formFeild(
                controller: passwordController,
                keyboard: TextInputType.visiblePassword,
                label: 'Password',
                prefix: const Icon(Icons.lock),
                isPassword: isPassword,
                suffix: isPassword ? Icons.visibility : Icons.visibility_off,
                suffixPressed: togglePassword,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password must not be empty';
                  }

                  if (value.length < 8) {
                    return 'Password must not be less than 8 characters';
                  }

                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Styles.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              CustomButton(
                buttonText: "Log in",
                onPressed: onLogin,
              ),
              SizedBox(height: 24.h),
              const SocialButtons(),
              SizedBox(height: 24.h),
              const RegisterRow(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
