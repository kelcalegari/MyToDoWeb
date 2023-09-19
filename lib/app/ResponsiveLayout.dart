import 'package:flutter/material.dart';
import '../constants.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  ResponsiveLayout({
    required Key key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletMinWidth;

  static bool isNotMobile(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMinWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < desktopMinWidth &&
      MediaQuery.of(context).size.width >= tabletMinWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopMinWidth;

  static bool isNotDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width < desktopMinWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= desktopMinWidth) {
          return desktop;
        } else if (constraints.maxWidth >= tabletMinWidth && tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}
