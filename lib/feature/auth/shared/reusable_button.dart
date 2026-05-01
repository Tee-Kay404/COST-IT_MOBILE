import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SharedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final Color? disabled;
  final Color? disabledForeground;
  final String text;
  final IconData? icon;
  final double? height;
  final double? width;
  final void Function()? onPressed;
  const SharedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.borderRadius,
    this.color,
    this.height = 50,
    this.width,
    this.disabled,
    this.disabledForeground,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: disabled,
        disabledForegroundColor: disabledForeground,
        shape: RoundedRectangleBorder(
          borderRadius:
              borderRadius as BorderRadius? ?? BorderRadius.circular(10.sp),
        ),
        splashFactory: NoSplash.splashFactory,
        backgroundColor: color ?? context.color.primary,
        foregroundColor: context.color.surface,
        alignment: Alignment.center,
        minimumSize: Size(width ?? double.infinity.w, height ?? 50.h),
        side: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      ),
      onPressed: onPressed,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //
          children: [
            // Icon(icon, size: 18.sp, color: context.color.inversePrimary),
            Gap(8.w),

            Text(
              text,
              style: context.bodyMedium?.copyWith(
                color: disabledForeground ?? context.color.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
