import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SliverGridDelegateWithFixedCrossAxisCount getResponsiveProductGridDelegate(
  BuildContext context,
) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final crossAxisCount = screenWidth >= 900
      ? 5
      : screenWidth >= 700
      ? 4
      : 2;

  final horizontalPadding = 32.w;
  final crossAxisSpacing = 12.w;
  final totalSpacing = crossAxisSpacing * (crossAxisCount - 1);
  final cardWidth =
      (screenWidth - horizontalPadding - totalSpacing) / crossAxisCount;
  const cardHeight = 240.0;
  final childAspectRatio = cardWidth / cardHeight;

  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: crossAxisCount,
    crossAxisSpacing: crossAxisSpacing,
    mainAxisSpacing: 12.h,
    childAspectRatio: childAspectRatio,
  );
}
