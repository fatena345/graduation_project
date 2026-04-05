import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/resposive/responsive.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback onNext;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final height = size.height;

    final isShort = Responsive.isShortHeight(context);

    final cardTop = height * (isShort ? 0.50 : 0.45);
    final imageTop = cardTop - (isShort ? 200.h : 240.h);

    final double buttonSize = 60.w;
    final double buttonBottomSpace = 30.h;

    double notchRadius = 38.r;

    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// البطاقة
          Positioned(
            top: cardTop,
            left: 30.w,
            right: 30.w,
            bottom: buttonBottomSpace + buttonSize / 2,
            child: CustomPaint(
              painter: NotchCardPainter(
                color: Colors.white,
                notchRadius: notchRadius,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.w,
                  vertical: isShort ? 40.h : 50.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isShort ? 24.sp : 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isShort ? 12.sp : 14.sp,
                        color: Colors.teal[700]?.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// الصورة
          Positioned(
            top: imageTop,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  width: 280.w,
                  height: isShort ? 240.h : 280.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  width: 140.w,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 25,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// زر Next داخل الصفحة
          Positioned(
            bottom: buttonBottomSpace,
            child: GestureDetector(
              onTap: onNext,
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                  size: 24.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotchCardPainter extends CustomPainter {
  final Color color;
  final double notchRadius;

  const NotchCardPainter({
    required this.color,
    required this.notchRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    RRect fullRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(30.r),
    );

    Path cardPath = Path()..addRRect(fullRect);

    Path notchPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height),
        radius: notchRadius,
      ));

    Path finalPath =
        Path.combine(PathOperation.difference, cardPath, notchPath);

    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
