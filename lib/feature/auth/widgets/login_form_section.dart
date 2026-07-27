import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/feature/auth/shared/button.dart';
import 'package:cost_it_mobile/feature/auth/shared/field_label.dart';
import 'package:cost_it_mobile/feature/auth/shared/validators.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:cost_it_mobile/feature/auth/utils/socials/social_buttons.dart';
import 'package:cost_it_mobile/feature/auth/widgets/auth_divider.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginFormSection extends StatelessWidget {
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final bool identifierHasText;
  final bool passwordHasText;
  final bool obscured;
  final bool rememberMe;
  final String? identifierError;
  final String? passwordError;
  final VoidCallback onToggleObscured;
  final ValueChanged<bool?> onToggleRememberMe;
  final Future<void> Function()? onLogin;

  const LoginFormSection({
    super.key,
    required this.identifierController,
    required this.passwordController,
    required this.identifierHasText,
    required this.passwordHasText,
    required this.obscured,
    required this.rememberMe,
    this.identifierError,
    this.passwordError,
    required this.onToggleObscured,
    required this.onToggleRememberMe,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Login with your details below 👇',
            style: context.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: context.theme.primaryColorDark,
            ),
          ),
        ),
        SizedBox(height: 18.h),
        const FieldLabel('Username*'),
        CostItFormfield(
          borderRadius: BorderRadius.circular(identifierHasText ? 30 : 10),
          hintText: 'Enter email or phone number',
          controller: identifierController,
          autofillHint: const [AutofillHints.username, AutofillHints.email],
          prefixIcon: PhosphorIcon(
            PhosphorIcons.user(PhosphorIconsStyle.bold),
            size: 17.sp,
          ),
          validator: Validators.isNotEmpty,
          errorText: identifierError,
        ),
        SizedBox(height: 15.h),
        const FieldLabel('Password*'),
        CostItFormfield(
          borderRadius: BorderRadius.circular(passwordHasText ? 30 : 10),
          hintText: 'Enter Password',
          controller: passwordController,
          autofillHint: const [AutofillHints.password],
          prefixIcon: PhosphorIcon(
            PhosphorIcons.lock(PhosphorIconsStyle.bold),
            size: 18.sp,
          ),
          errorText: passwordError,
          suffixIcon: GestureDetector(
            onTap: onToggleObscured,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Image.asset(
                  obscured ? AppImages.invisible : AppImages.visible,
                  key: ValueKey(obscured),
                  width: 24.w,
                  height: 22.h,
                  color: context.theme.primaryColorDark,
                ),
              ),
            ),
          ),
          obscureText: obscured,
          validator: Validators.isNotEmpty,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => onToggleRememberMe(!rememberMe),
              child: Row(
                children: [
                  Checkbox(
                    
                    value: rememberMe,
                    onChanged: onToggleRememberMe,
                    checkColor: context.theme.scaffoldBackgroundColor,
                    activeColor: context.color.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                      side: BorderSide(color: context.color.secondary),
                    ),
                    side: BorderSide(color: context.color.secondary),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  Gap(4.w),
                  Text(
                    'Remember me',
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, PageRoutes.forgotPassword.name),
              child: Text(
                'Forgot Password?',
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: context.color.secondary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        LoadingButton(onTap: onLogin, text: 'Login'),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account?',
              style: context.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(width: 5.w),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, PageRoutes.signUp.name),
              child: Text(
                'Create now',
                style: context.bodySmall?.copyWith(
                  decorationColor: context.color.secondary,
                  decorationThickness: 1.sp,
                  color: context.color.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),

        AuthDivider(),
        SizedBox(height: 10.h),
        const SocialButtons(),
        SizedBox(height: 20.h),
        SizedBox(height: context.safeBottom + 20.h),
      ],
    );
  }
}
