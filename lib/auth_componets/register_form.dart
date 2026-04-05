import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/auth_componets/custom_button.dart';
import 'package:project/auth_componets/login_row.dart';
import 'package:project/auth_componets/title_and_description.dart';
import 'package:project/shared/components/components.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onRegister;

  final String? selectedRole;
  final Function(String?) onRoleChanged;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onRegister,
    required this.selectedRole,
    required this.onRoleChanged,
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
                title: 'Create Account',
                description: 'Register with your email and password',
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

              SizedBox(height: 16.h),

              /// Role Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF6F8FA),
                  labelText: 'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefix: const Icon(Icons.person),
                ),
                value: selectedRole,
                items: ['driver', 'rider', 'admin']
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  onRoleChanged(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please select your role';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.h),

              /// Register Button
              CustomButton(
                buttonText: "Sign up",
                onPressed: onRegister,
              ),

              SizedBox(height: 10.h),

              /// Divider OR
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              SizedBox(height: 10.h),

              /// Social Buttons
              Row(
                children: [
                  Expanded(
                    child: _socialButton(
                      text: 'Google',
                      icon: 'assets/images/google logo.png',
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _socialButton(
                      text: 'Facebook',
                      icon: "assets/images/facebook logo.png",
                      color: Colors.blue,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),

              const LoginRow(),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _socialButton({
  required String text,
  required String icon,
  required Color color,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    height: 48.h,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(icon, height: 24.h),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: color),
      ),
    ),
  );
}
