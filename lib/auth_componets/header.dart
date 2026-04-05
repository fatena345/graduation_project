import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/car.png',
          height: 180.h,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
