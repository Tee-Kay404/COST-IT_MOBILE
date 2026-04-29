import 'package:flutter/material.dart';

class ScreenSize {
  static MediaQueryData _mediaQuery(BuildContext context) =>
      MediaQuery.of(context);

  static Size size(BuildContext context) =>
      _mediaQuery(context).size;

  static double width(BuildContext context) =>
      size(context).width;

  static double height(BuildContext context) =>
      size(context).height;

  static Orientation orientation(BuildContext context) =>
      _mediaQuery(context).orientation;

  static bool isPortrait(BuildContext context) =>
      orientation(context) == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      orientation(context) == Orientation.landscape;

  static bool isMobile(BuildContext context) =>
      width(context) < 600;

  static bool isTablet(BuildContext context) =>
      width(context) >= 600 && width(context) < 1024;

  static bool isDesktop(BuildContext context) =>
      width(context) >= 1024;
}