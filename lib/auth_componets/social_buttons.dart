import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10.w,
      children: [
        SocialIconButton(
          url: 'assets/images/google logo.png',
          onTap: () {},
        ),
        SocialIconButton(
          url: 'assets/images/instagram.png',
          onTap: () {},
        ),
        SocialIconButton(
          url: 'assets/images/facebook logo.png',
          onTap: () {},
        ),
      ],
    );
  }
}

class SocialIconButton extends StatelessWidget {
  final String url;
  final VoidCallback onTap;

  const SocialIconButton({
    required this.url,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Image.asset(
          url,
          height: 24.h,
        ),
      ),
    );
  }
}
