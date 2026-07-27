import 'package:flutter/material.dart';

class OnBoardingData {
  const OnBoardingData({
    required this.imagePath,
    required this.headlineText,
    required this.bodyText,
    required this.bottomText,
    required this.accentIcon,
  });

  final String imagePath;
  final String headlineText;
  final String bodyText;
  final String bottomText;
  final IconData accentIcon;
}
