import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SharedOutlinedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final Color? outlineColor;
  final Color? color;
  final Color? backgroundColor;
  final String text;
  final IconData? icon;
  final double? height;
  final double? width;
  final void Function()? onPressed;

  const SharedOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.borderRadius,
    this.outlineColor,
    this.color,
    this.backgroundColor,
    this.height = 50,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: outlinedButtonStyle(
        outlineColor: outlineColor ?? context.color.primary,
        color: color ?? context.color.primary,
        backgroundColor: backgroundColor ?? Colors.transparent,
        borderRadius: 10, // Match the typical border radius used
        minimumSize: Size(width ?? double.infinity.w, height ?? 50.h),
      ),
      onPressed: onPressed,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20.sp, color: color ?? context.color.primary),
              Gap(8.w),
            ],
            Text(
              text,
              style: context.bodyMedium?.copyWith(
                color: color ?? context.color.primary,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
