import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class OTPField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;
  final bool forceErrorState;
  final Color? cursorColor;
  const OTPField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onCompleted,
    this.onChanged,
    this.cursorColor,
    required this.forceErrorState,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 80.h,
      textStyle: Theme.of(
        context,
      ).textTheme.titleMedium!.copyWith(color: Colors.white),
      decoration: BoxDecoration(
        color: CostItColors.brightGrey.shade100,
        border: Border.all(color: CostItColors.brightGrey.shade200),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: context.color.primary,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [CostItColors.primaryMid, CostItColors.primaryDark],
        ),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.red),
      ),
    );
    return Pinput(
      length: 4,
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      errorPinTheme: errorPinTheme,
      forceErrorState: forceErrorState,
      cursor: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 22.w,
          height: 2.h,
          margin: const EdgeInsets.only(bottom: 8),
          color: cursorColor ?? CostItColors.primaryDark,
        ),
      ),
      onCompleted: onCompleted,
      onChanged: onChanged,
    );
  }
}
