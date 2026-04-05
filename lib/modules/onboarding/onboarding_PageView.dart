import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/theme/style.dart';
import 'package:project/modules/Register/register_screen.dart';
import 'package:project/modules/onboarding/data/onboardingData.dart';
import 'package:project/modules/onboarding/onboardingPage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({super.key});

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  void nextPage() {
    if (currentIndex == onboardingData.length - 1) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterScreen(),
          ));
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    _controller.jumpToPage(onboardingData.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = onboardingData[index];
              return OnboardingPage(
                image: item.image,
                title: item.title,
                description: item.description,
                onNext: nextPage,
              );
            },
          ),

          if (currentIndex != onboardingData.length - 1)
            Positioned(
              top: 40.h,
              right: 20.w,
              child: TextButton(
                onPressed: skip,
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.yellow[700],
                  ),
                ),
              ),
            ),

          /// Indicator
          Positioned(
            bottom: 10.h,
            child: SmoothPageIndicator(
              controller: _controller,
              count: onboardingData.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8.h,
                dotWidth: 8.w,
                spacing: 6.w,
                expansionFactor: 3,
                activeDotColor: Colors.yellow[700]!,
                dotColor: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
