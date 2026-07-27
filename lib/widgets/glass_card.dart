import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final double blurSigma;
  final double borderWidth;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blurSigma = 22.0,
    this.borderWidth = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(28.r);

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 22.w, vertical: 26.h),
          decoration: BoxDecoration(
            borderRadius: effectiveBorderRadius,
            color: Colors.white.withOpacity(0.07),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: borderWidth,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.13),
                Colors.white.withOpacity(0.02),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
