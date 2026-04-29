import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/global/styles.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CostItFormfield extends StatelessWidget {
  final Function(String?)? onSaved;
  final bool? autofocus;
  final AutovalidateMode? autovalidateMode;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final Color? color;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final FormFieldValidator<String?>? validator;
  final Iterable<String>? autofillHint;
  final TextInputType? keyboardType;
  final BorderRadius? borderRadius;
  const CostItFormfield({
    super.key,
    this.autovalidateMode,
    this.validator,
    this.onSaved,
    this.color,
    this.controller,
    this.border,
    this.autofocus,
    this.onChanged,
    this.obscureText,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.hintText,
    this.borderRadius,
    this.labelText,
    this.hintStyle,
    this.labelStyle,
    this.enabledBorder,
    this.autofillHint,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: context.theme.focusColor,
      autocorrect: true,
      onChanged: onChanged,
      autofocus: autofocus ?? false,
      autovalidateMode: autovalidateMode,
      validator: validator,
      onSaved: onSaved,
      controller: controller,
      obscureText: obscureText ?? false,
      style: context.bodyMedium?.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: context.theme.primaryColorDark,
      ),
      autofillHints: autofillHint,
      keyboardType: keyboardType,
      decoration:
          outlinedTextFields(
            context,
            borderRadius: borderRadius,
            enabledBorder: enabledBorder,
          ).copyWith(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 8.h,
            ),
            counterText: '',
            hintText: hintText,
            labelText: labelText,
            prefixIconColor: CostItColors.brightGrey.shade800,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorText: errorText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
    );
  }
}
