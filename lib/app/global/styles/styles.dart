import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ButtonStyle textButtonStyle({
  Color color = CostItColors.primary,
  Color backgroundColor = Colors.transparent,
  OutlinedBorder? shape,
  double borderRadius = 12,
  Size? minimumSize,
}) {
  return ButtonStyle(
    padding: WidgetStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
    backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
    iconColor: WidgetStatePropertyAll(color),
    minimumSize: WidgetStatePropertyAll(minimumSize ?? Size(0, 50.h)),
    foregroundColor: WidgetStateProperty.all<Color>(color),
    shape: WidgetStateProperty.all<OutlinedBorder>(
      shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
    ),
  );
}

ButtonStyle flatButtonStyle({
  Color color = CostItColors.primary,
  Color textColor = Colors.white,
  double borderRadius = 12,
  OutlinedBorder? shapeBorder,
  EdgeInsets padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
  Size? minimumSize,
}) {
  return ButtonStyle(
    // overlayColor: MaterialStateProperty.all<Color>(Colors.redAccent),
    padding: WidgetStateProperty.all<EdgeInsets>(padding),
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) =>
          states.contains(WidgetState.disabled) ? color.lighten(60) : color,
    ),
    foregroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) => states.contains(WidgetState.disabled)
          ? textColor.lighten(50)
          : textColor,
    ),
    minimumSize: WidgetStatePropertyAll(minimumSize ?? Size(0, 50.h)),
    shape: WidgetStateProperty.all<OutlinedBorder>(
      shapeBorder ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
    ),
  );
}

ButtonStyle outlinedButtonStyle({
  Color outlineColor = CostItColors.primary,
  Color backgroundColor = const Color(0xFFE8F0FC),
  Color color = CostItColors.primary,
  double borderRadius = 12,
  EdgeInsets padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  Size? minimumSize,
}) {
  return OutlinedButton.styleFrom(
    side: BorderSide(color: outlineColor, width: 1.w),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius.r),
    ),
    padding: padding,
    surfaceTintColor: backgroundColor,
    foregroundColor: color,
    backgroundColor: backgroundColor,
    disabledBackgroundColor: backgroundColor.lighten(60),
    disabledForegroundColor: color.lighten(60),
    minimumSize: minimumSize ?? Size(0, 50.h),
  );
}

ButtonStyle flatTextButtonStyle({
  Color backgroundColor = Colors.transparent,
  Color textColor = CostItColors.primary,
  double borderRadius = 8,
  EdgeInsets padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  Size? minimumSize,
}) {
  return ButtonStyle(
    padding: WidgetStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    ),
    minimumSize: WidgetStatePropertyAll(minimumSize ?? Size(0, 50.h)),
    foregroundColor: WidgetStateProperty.all<Color>(textColor),
    backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
    overlayColor: WidgetStatePropertyAll(
      backgroundColor != Colors.transparent
          ? backgroundColor.withValues(alpha: 0.1)
          : textColor.withValues(alpha: 0.1),
    ),
    shape: WidgetStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
    ),
  );
}

// Textfields
InputDecoration outlinedTextFields(
  BuildContext context, {
  Color? color,
  InputBorder? enabledBorder,
  double borderRadiusValue = 12,
  BorderRadius? borderRadius,
  bool? obscureText,
  Color? baseBorderColor,
  Color? enabledBorderColor,
  Color? focusedBorderColor,
  Color? backgroundColor,
  BorderStyle? borderStyle,
}) {
  final fixedBorderRadius = BorderRadius.circular(borderRadiusValue.r);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return InputDecoration(
    errorMaxLines: 2,
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: (borderRadius ?? fixedBorderRadius),
      borderSide: BorderSide(
        color: CostItColors.error,
        width: 1.0,
        style: BorderStyle.solid,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadiusValue.r),
      borderSide: BorderSide(
        color: CostItColors.error,
        width: 0.8.w,
        style: BorderStyle.solid,
      ),
    ),
    errorStyle: context.bodySmall?.copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: CostItColors.error,
    ),
    hintStyle: context.bodySmall?.copyWith(
      color: isDark
          ? CostItColors.brightGrey.shade100
          : CostItColors.brightGrey.shade800,
    ),
    labelStyle: context.bodyMedium?.copyWith(
      color: context.theme.primaryColorDark,
      fontSize: 15.sp,
    ),
    fillColor: isDark
        ? CostItColors.brightGrey.shade800
        : CostItColors.brightGrey.shade100,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: (borderRadius ?? BorderRadius.circular(2)),
      borderSide: BorderSide(
        color: Colors.grey.shade800,
        width: 0.5.w,
        style: BorderStyle.none,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: (borderRadius ?? fixedBorderRadius),
      borderSide: BorderSide(
        color: Colors.grey.shade400,
        width: 0.8.w,
        style: BorderStyle.solid,
      ),
    ),
    enabledBorder:
        enabledBorder ??
        OutlineInputBorder(
          borderRadius: (borderRadius ?? fixedBorderRadius),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0.0,
            style: BorderStyle.none,
          ),
        ),
    focusedBorder: OutlineInputBorder(
      borderRadius: (borderRadius ?? fixedBorderRadius),
      borderSide: BorderSide(
        color: focusedBorderColor ?? context.theme.focusColor,
        width: 1.0.w,
        style: borderStyle ?? BorderStyle.solid,
      ),
    ),
  );
}
