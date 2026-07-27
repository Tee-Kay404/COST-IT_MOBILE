import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SharedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final Color? disabled;
  final Color? disabledForeground;
  final Color? textColor;
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
    this.textColor,
    this.height = 50,
    this.width,
    this.disabled,
    this.disabledForeground,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style:
          flatButtonStyle(
            color: color ?? context.color.primary,
            textColor: textColor ?? CostItColors.white,
          ).copyWith(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius:
                    borderRadius as BorderRadius? ??
                    BorderRadius.circular(10.sp),
              ),
            ),
            minimumSize: WidgetStatePropertyAll(
              Size(width ?? double.infinity.w, height ?? 50.h),
            ),
          ),
      onPressed: onPressed,
      child: Center(
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon!),
                  Gap(8.w),
                  Text(
                    text,
                    style: context.bodyMedium?.copyWith(
                      color:
                          textColor ?? disabledForeground ?? CostItColors.white,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: context.bodyMedium?.copyWith(
                  color: textColor ?? disabledForeground ?? CostItColors.white,
                ),
              ),
      ),
    );
  }
}
