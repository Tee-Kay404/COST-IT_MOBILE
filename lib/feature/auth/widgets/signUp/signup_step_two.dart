import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/utils/text_links.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/feature/auth/shared/button.dart';
import 'package:cost_it_mobile/feature/auth/shared/field_label.dart';
import 'package:cost_it_mobile/feature/auth/shared/validators.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:cost_it_mobile/widgets/text_span.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignupStepTwo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AutovalidateMode autovalidateMode;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? phoneError;
  final String? passwordError;
  final bool obscured;
  final bool obscuredConfirm;
  final bool termAccepted;
  final bool isStep2Submitted;
  final bool isStep2Complete;
  final VoidCallback onToggleObscured;
  final VoidCallback onToggleObscuredConfirm;
  final ValueChanged<bool> onTermAcceptedChanged;
  final VoidCallback onClearPhoneError;
  final VoidCallback onClearPasswordError;
  final VoidCallback onRebuildRequested;
  final Future<void> Function()? onSignUp;

  const SignupStepTwo({
    super.key,
    required this.formKey,
    required this.autovalidateMode,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.phoneError,
    this.passwordError,
    required this.obscured,
    required this.obscuredConfirm,
    required this.termAccepted,
    required this.isStep2Submitted,
    required this.isStep2Complete,
    required this.onToggleObscured,
    required this.onToggleObscuredConfirm,
    required this.onTermAcceptedChanged,
    required this.onClearPhoneError,
    required this.onClearPasswordError,
    required this.onRebuildRequested,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel('Phone Number *'),
          CostItFormfield(
            borderRadius: BorderRadius.circular(
              phoneController.text.isNotEmpty ? 30 : 10,
            ),
            controller: phoneController,
            hintText: '080 000 000 00',
            onChanged: (_) => onClearPhoneError(),
            prefixIcon: Icon(Icons.phone_outlined, size: 20.sp),
            validator: Validators.validatePhone,
            errorText: phoneError,
            keyboardType: TextInputType.phone,
          ),
          Gap(16.h),
          const FieldLabel('Password *'),
          CostItFormfield(
            borderRadius: BorderRadius.circular(
              passwordController.text.isNotEmpty ? 30 : 10,
            ),
            hintText: 'Create a strong password',
            controller: passwordController,
            obscureText: obscured,
            prefixIcon: PhosphorIcon(
              PhosphorIcons.lock(PhosphorIconsStyle.bold),
              size: 20.sp,
            ),
            onChanged: (_) => onClearPasswordError(),
            suffixIcon: GestureDetector(
              onTap: onToggleObscured,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    obscured ? AppImages.invisible : AppImages.visible,
                    key: ValueKey(obscured),
                    width: 22.w,
                    height: 22.h,
                    color: context.color.inverseSurface,
                  ),
                ),
              ),
            ),
            errorText: passwordError,
            validator: Validators.validatePassword,
          ),
          Gap(16.h),
          const FieldLabel('Confirm Password *'),
          CostItFormfield(
            borderRadius: BorderRadius.circular(
              confirmPasswordController.text.isNotEmpty ? 30 : 10,
            ),
            hintText: 'Re-enter your password',
            controller: confirmPasswordController,
            obscureText: obscuredConfirm,
            prefixIcon: PhosphorIcon(
              PhosphorIcons.lock(PhosphorIconsStyle.bold),
              size: 20.sp,
            ),
            onChanged: (_) {
              if (isStep2Submitted) {
                onRebuildRequested();
              }
            },
            suffixIcon: GestureDetector(
              onTap: onToggleObscuredConfirm,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    obscuredConfirm ? AppImages.invisible : AppImages.visible,
                    key: ValueKey(obscuredConfirm),
                    width: 22.w,
                    height: 22.h,
                    color: context.color.inverseSurface,
                  ),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return Validators.isNotEmpty(value);
              }
              return Validators.isEqualTo(
                value,
                compareValue: passwordController.text,
                errorMessage: 'Passwords do not match',
              );
            },
          ),
          Gap(12.h),
          FormField<bool>(
            initialValue: termAccepted,
            validator: (value) =>
                value != true ? ' Agree to the Terms of Service' : null,
            builder: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    final newValue = !(state.value ?? false);
                    state.didChange(newValue);
                    onTermAcceptedChanged(newValue);
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        checkColor: context.color.surface,
                        activeColor: context.color.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(
                          color: state.hasError
                              ? CostItColors.error
                              : context.color.secondary,
                          width: 1.5,
                        ),
                        value: state.value ?? false,
                        onChanged: (val) {
                          final newValue = val ?? false;
                          state.didChange(newValue);
                          onTermAcceptedChanged(newValue);
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      Gap(6.w),
                      Expanded(
                        child: TextSpanWithLink(
                          style: context.bodySmall!.copyWith(height: 1.4),
                          height: 1.4,
                          autoUnderlined: true,
                          linkColor: state.hasError
                              ? CostItColors.error
                              : CostItColors.primary2,
                          textSpanList: [
                            const TextWithLinkModel(text: 'I agree to the '),
                            TextLink.termsOfService.model,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.hasError) ...[
                  Gap(4.h),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: state.errorText!.text().styled(
                      color: CostItColors.error,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Gap(15.h),
          LoadingButton(
            onTap: isStep2Complete ? onSignUp : null,
            text: 'Create Account',
            disabled: isStep2Complete ? context.color.primary : Colors.grey,
          ),
        ],
      ),
    );
  }
}
