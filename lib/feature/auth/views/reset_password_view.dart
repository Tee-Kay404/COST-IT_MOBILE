import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/dialog/scaffold_message.dart';
import 'package:cost_it_mobile/app/global/utils/exception.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/shared/field_label.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:cost_it_mobile/feature/auth/shared/loaders.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:cost_it_mobile/feature/auth/shared/validators.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/dark_round_button.dart';
import 'package:cost_it_mobile/widgets/progress_loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

typedef ResetPasswordViewArguments = ({
  String identifier,
  String otp,
  PageRoutes nextRoute,
});

class ResetPasswordView extends ConsumerStatefulWidget {
  final ResetPasswordViewArguments args;
  const ResetPasswordView({super.key, required this.args});

  @override
  ConsumerState<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? passwordError;
  bool _obscured = true;
  bool _obscuredConfirm = true;
  bool _submitted = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "identifier": widget.args.identifier,
      "otp": widget.args.otp,
      "password": _passwordController.text,
    };

    final result = await futureProgressCaller(
      context,
      loaderType: LoaderType.popup,
      loadingMessage: "Resetting password...",
      computation: () =>
          ref.read(validateForgotPasswordProvider(payload).future),
      onError: (error) {
        final ex = error is GlobalException ? error : null;
        // OTP may have expired between screens
        final msg = ex?.message ?? 'Failed to reset password, please try again';
        showErrorExceptionToast(context, msg);
        return false;
      },
    );

    if (result == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        PageRoutes.resetPasswordSuccess.name,
        ModalRoute.withName("/"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
          child: Form(
            key: _formKey,
            autovalidateMode: _submitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(20.h),
                BackArrowButton(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      ScaffoldMessage(
                        message: 'Sorry! Cannot go back to OTP root',
                        context: context,
                      ),
                    );
                  },
                ),
                Gap(20.h),
                Text(
                  'Create New Password',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 25.sp,
                    color: context.color.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10.h),
                Text(
                  "Enter a secure password to regain access to your account.",
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: CostItColors.brightGrey.shade500,
                  ),
                ),
                SizedBox(height: 40.h),
                const FieldLabel('New Password *'),
                CostItFormfield(
                  hintText: 'Create a strong password',
                  controller: _passwordController,
                  obscureText: _obscured,
                  prefixIcon: PhosphorIcon(
                    PhosphorIcons.lock(PhosphorIconsStyle.bold),
                    size: 20.sp,
                  ),
                  onChanged: (_) => setState(() {}),
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscured = !_obscured),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Image.asset(
                        _obscured ? AppImages.invisible : AppImages.visible,
                        width: 22.w,
                        height: 22.h,
                        color: context.color.inverseSurface,
                      ),
                    ),
                  ),
                  errorText: passwordError,
                  validator: Validators.validatePassword,
                ),
                Gap(20.h),
                const FieldLabel('Confirm New Password *'),
                CostItFormfield(
                  hintText: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  obscureText: _obscuredConfirm,
                  prefixIcon: PhosphorIcon(
                    PhosphorIcons.lock(PhosphorIconsStyle.bold),
                    size: 20.sp,
                  ),
                  onChanged: (_) => setState(() {}),
                  suffixIcon: GestureDetector(
                    onTap: () =>
                        setState(() => _obscuredConfirm = !_obscuredConfirm),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Image.asset(
                        _obscuredConfirm
                            ? AppImages.invisible
                            : AppImages.visible,
                        width: 22.w,
                        height: 22.h,
                        color: context.color.inverseSurface,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Validators.isNotEmpty(value);
                    }
                    return Validators.isEqualTo(
                      value,
                      compareValue: _passwordController.text,
                      errorMessage: 'Passwords do not match',
                    );
                  },
                ),
                Gap(18.h),
                Row(
                  children: [
                    Text(
                      'Note: ',
                      style: context.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      'Avoid disclosing your password with anyone.',
                      style: context.bodySmall?.copyWith(
                        color: CostItColors.brightGrey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SharedButton(text: 'Reset Password', onPressed: _resetPassword),
                Gap(15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
