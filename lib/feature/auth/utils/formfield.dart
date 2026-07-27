import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/styles/styles.dart';
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
  final bool readOnly;
  final bool? enabled;
  final BorderRadius? borderRadius;
  final FocusNode? focusNode;
  final Widget? label;
  final int? minLines;
  final int? maxLines;
  
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
    this.readOnly = false,
    this.enabled,
    this.borderRadius,
    this.labelText,
    this.hintStyle,
    this.labelStyle,
    this.enabledBorder,
    this.autofillHint,
    this.focusNode,
    this.label,
    this.minLines,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      cursorColor: context.theme.focusColor,
      onChanged: onChanged,
      autofocus: autofocus ?? false,
      readOnly: readOnly,
      focusNode: focusNode,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      validator: validator,
      onSaved: onSaved,
      controller: controller,
      obscureText: obscureText ?? false,
      style: context.bodyMedium?.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: context.color.inverseSurface,
      ),
      autofillHints: autofillHint,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      decoration:
          outlinedTextFields(
            context,
            borderRadius: borderRadius,
            enabledBorder: enabledBorder,
          ).copyWith(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 24.h,
            ),
            counterText: '',
            hintText: hintText,
            labelText: labelText,
            label: label,
            prefixIconColor: isDark
                ? CostItColors.brightGrey.shade100
                : CostItColors.brightGrey.shade800,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorText: errorText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
    );
  }
}
