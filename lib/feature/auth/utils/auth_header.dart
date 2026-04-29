import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/constants/custom_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthHeader extends StatelessWidget {
  final Widget child;

  const AuthHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.265;

    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: height,
        width: double.infinity,
        color: context.color.primary,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: child,
          ),
        ),
      ),
    );
  }
}
