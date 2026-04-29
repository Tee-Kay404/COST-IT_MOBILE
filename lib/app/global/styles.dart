import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ButtonStyle textButtonStyle({
  Color color = CostItColors.primary,
  Color backgroundColor = Colors.transparent,
  OutlinedBorder? shape,
  double borderRadius = 12,
}) {
  return ButtonStyle(
    padding: WidgetStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
    backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
    iconColor: WidgetStatePropertyAll(color),
    fixedSize: WidgetStatePropertyAll(Size.fromHeight(48)),
    foregroundColor: WidgetStateProperty.all<Color>(color),
    shape: WidgetStateProperty.all<OutlinedBorder>(shape ?? StadiumBorder()),
  );
}

ButtonStyle flatButtonStyle({
  Color color = CostItColors.primary,
  Color textColor = Colors.white,
  double borderRadius = 12,
  OutlinedBorder? shapeBorder,
  EdgeInsets padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
    fixedSize: WidgetStatePropertyAll(Size.fromHeight(48)),
    shape: WidgetStateProperty.all<OutlinedBorder>(
      shapeBorder ?? StadiumBorder(),
    ),
  );
}

ButtonStyle outlinedButtonStyle({
  Color outlineColor = Colors.black,
  Color backgroundColor = const Color(0xFFE8F0FC),
  Color color = CostItColors.primary,
  double borderRadius = 8,
  EdgeInsets padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
}) {
  return OutlinedButton.styleFrom(
    shape: StadiumBorder(
      // borderRadius: BorderRadius.circular(12),
      // smoothness: 0.6,
    ),
    padding: padding,
    surfaceTintColor: backgroundColor,
    foregroundColor: color,
    backgroundColor: backgroundColor,
    disabledBackgroundColor: backgroundColor.lighten(60),
    disabledForegroundColor: color.lighten(60),
  ).copyWith(
    iconColor: WidgetStateProperty.all<Color>(color),
    side: WidgetStateProperty.resolveWith<BorderSide>((
      Set<WidgetState> states,
    ) {
      Color color = outlineColor;
      double width = 1;
      if (states.contains(WidgetState.disabled)) {
        color = color.lighten(5);
        width = 0.5;
      }
      return BorderSide(color: color, width: width.h);
    }),
    fixedSize: WidgetStatePropertyAll(Size.fromHeight(48)),
    shape: WidgetStateProperty.all<OutlinedBorder>(StadiumBorder()),
  );
}

ButtonStyle flatTextButtonStyle({
  Color backgroundColor = Colors.transparent,
  Color textColor = CostItColors.primary,
  double borderRadius = 8,
  EdgeInsets padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
}) {
  return ButtonStyle(
    padding: WidgetStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    ),
    fixedSize: WidgetStatePropertyAll(Size.fromHeight(48)),
    foregroundColor: WidgetStateProperty.all<Color>(textColor),
    backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
    overlayColor: WidgetStatePropertyAll(
      backgroundColor != Colors.transparent
          ? backgroundColor.withOpacity(0.1)
          : textColor.withOpacity(0.1),
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
  Color? focusedBorderColor,
  Color? backgroundColor,
}) {
  final fixedBorderRadius = BorderRadius.circular(borderRadiusValue.r);

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
      color: CostItColors.brightGrey.shade800,
    ),
    labelStyle: context.bodyMedium?.copyWith(
      color: context.theme.primaryColorDark,
      fontSize: 15.sp,
    ),
    fillColor: Colors.grey.shade200,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: (borderRadius ?? BorderRadius.circular(2)),
      borderSide: BorderSide(
        color: Colors.grey.shade800,
        width: 0.5.w,
        style: BorderStyle.none,
      ),
    ),
    enabledBorder:
        enabledBorder ??
        OutlineInputBorder(
          borderRadius: (borderRadius ?? fixedBorderRadius),
          borderSide: BorderSide(
            color: CostItColors.primary2,
            width: 0.8.w,
            style: BorderStyle.solid,
          ),
        ),
    focusedBorder: OutlineInputBorder(
      borderRadius: (borderRadius ?? fixedBorderRadius),
      borderSide: BorderSide(
        color: CostItColors.primaryDark,
        width: 1.0.w,
        style: BorderStyle.solid,
      ),
    ),
  );
}
