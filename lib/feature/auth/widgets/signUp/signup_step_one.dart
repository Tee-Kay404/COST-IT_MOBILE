import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/shared/field_label.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:cost_it_mobile/feature/auth/shared/validators.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignupStepOne extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AutovalidateMode autovalidateMode;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;
  final VoidCallback onClearFirstNameError;
  final VoidCallback onClearLastNameError;
  final VoidCallback onClearEmailError;
  final VoidCallback onNext;

  const SignupStepOne({
    super.key,
    required this.formKey,
    required this.autovalidateMode,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    required this.onClearFirstNameError,
    required this.onClearLastNameError,
    required this.onClearEmailError,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel('First name*'),
          CostItFormfield(
            borderRadius: BorderRadius.circular(
              firstNameController.text.isNotEmpty ? 30 : 10,
            ),
            onChanged: (_) => onClearFirstNameError(),
            hintText: 'Enter first name',
            controller: firstNameController,
            prefixIcon: PhosphorIcon(
              PhosphorIcons.user(PhosphorIconsStyle.bold),
              size: 20.sp,
            ),
            validator: Validators.userName,
            errorText: firstNameError,
          ),
          Gap(16.h),
          const FieldLabel('Last name*'),
          CostItFormfield(
            borderRadius: BorderRadius.circular(
              lastNameController.text.isNotEmpty ? 30 : 10,
            ),
            onChanged: (_) => onClearLastNameError(),
            hintText: 'Enter last name',
            controller: lastNameController,
            prefixIcon: PhosphorIcon(
              PhosphorIcons.user(PhosphorIconsStyle.bold),
              size: 20.sp,
            ),
            validator: Validators.userName,
            errorText: lastNameError,
          ),
          Gap(16.h),
          const FieldLabel('Email*'),
          CostItFormfield(
            borderRadius: BorderRadius.circular(
              emailController.text.isNotEmpty ? 30 : 10,
            ),
            onChanged: (_) => onClearEmailError(),
            hintText: 'john@example.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: PhosphorIcon(
              PhosphorIcons.envelope(PhosphorIconsStyle.bold),
              size: 20.sp,
            ),
            errorText: emailError,
            validator: Validators.validateEmail,
          ),
          Gap(20.h),
          SharedButton(
            color: context.color.primary,
            text: 'Next',
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
