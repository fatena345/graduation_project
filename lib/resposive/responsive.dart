import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive(
      {super.key,
      required this.desktop,
      required this.tablet,
      required this.mobileLarge,
      required this.mobile,
      required this.mobileSmall});

  final Widget desktop;
  final Widget tablet;
  final Widget mobileLarge;
  final Widget mobile;
  final Widget mobileSmall;

  // Break Points
  static const double desktopBreakpoint = 1024;
  static const double tabletBreakpoint = 768;
  static const double mobileLargeBreakpoint = 480;
  static const double mobileBreakpoint = 360;

  // get width mobile
  static double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

// helpers
  static bool isDesktop(BuildContext context) =>
      getWidth(context) >= desktopBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = getWidth(context);
    return width >= tabletBreakpoint && width < desktopBreakpoint;
  }

  static bool isMobileLarge(BuildContext context) {
    final width = getWidth(context);
    return width >= mobileLargeBreakpoint && width < tabletBreakpoint;
  }

  static bool isMobile(BuildContext context) {
    final width = getWidth(context);
    return width >= mobileBreakpoint && width < mobileLargeBreakpoint;
  }

  static bool isMobileSmall(BuildContext context) =>
      getWidth(context) < mobileBreakpoint;

  static bool isShortHeight(BuildContext context) =>
      MediaQuery.of(context).size.height < 650;

  static bool isTallHeight(BuildContext context) =>
      MediaQuery.of(context).size.height > 900;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= desktopBreakpoint) {
          return desktop;
        } else if (width >= tabletBreakpoint) {
          return tablet;
        } else if (width >= mobileLargeBreakpoint) {
          return mobileLarge;
        } else if (width >= mobileBreakpoint) {
          return mobile;
        } else {
          return mobileSmall;
        }
      },
    );
  }
}
