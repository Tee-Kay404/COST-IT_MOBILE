import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/global/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CostItTextfield extends StatelessWidget {
  final String hintText;
  final Color? fillColor;
  final bool? filled;
  final String? errorText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final FormFieldValidator<String?>? validator;
  final TextStyle? style;
  const CostItTextfield({
    super.key,
    required this.hintText,
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
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: style,
      decoration:
          outlinedTextFields(
            context,

            borderRadius: BorderRadius.circular(12.r),
            backgroundColor: fillColor ?? Color(0xFFF5F9FE),
            baseBorderColor: CostItColors.brightGrey.shade200,
            focusedBorderColor: CostItColors.brightGrey.shade400,
          ).copyWith(
            errorText: errorText,
            filled: filled ?? true,
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
      keyboardType: keyboardType,
    );
  }
}
