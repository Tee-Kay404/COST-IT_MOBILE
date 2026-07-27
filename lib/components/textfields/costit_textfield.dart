import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CostItTextfield extends StatelessWidget {
  final String? hintText;
  final Color? fillColor;
  final bool? filled;
  final int? maxLines;
  final String? errorText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Color? enabledBorderColor;
  final FormFieldValidator<String?>? validator;
  final TextStyle? style;
  final bool readOnly;
  final bool enabled;
  final FocusNode? focusNode;
  const CostItTextfield({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.fillColor,
    this.errorText,
    this.filled,
    this.prefixIcon,
    this.controller,
    this.validator,
    this.style,
    this.maxLines,
    this.enabledBorderColor,
    this.readOnly = false,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: context.theme.focusColor,
      focusNode: focusNode,
      maxLines: maxLines,
      autocorrect: true,
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      validator: validator,
      style: style ?? context.bodyMedium,
      decoration:
          outlinedTextFields(
            context,
            borderRadius: BorderRadius.circular(12.r),
            backgroundColor: fillColor ?? Color(0xFFF5F9FE),
            baseBorderColor: CostItColors.brightGrey.shade200,
            enabledBorderColor: enabledBorderColor ?? context.color.primary,
            focusedBorderColor: context.theme.focusColor,
          ).copyWith(
            errorText: errorText,
            filled: filled ?? true,
            hintText: hintText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
      keyboardType: keyboardType,
    );
  }
}
