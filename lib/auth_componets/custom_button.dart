import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/theme/style.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Widget? icon;
  final Color? color;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? borderRadius;
  final TextStyle? textStyle;
  final Gradient? gradient;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.icon,
    this.color,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
      child: Container(
        height: height ?? 48.h,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: color ?? Styles.primary,
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(width: 8.w),
            ],
            Text(
              buttonText,
              style: textStyle ??
                  TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
