import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/feature/auth/utils/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SignupHeader extends StatelessWidget {
  final int currentStep;

  const SignupHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return AuthHeader(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10.h),
          SizedBox(
            height: 60.h,
            child: Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                AppImages.logo2,
                height: 120.h,
                width: 140.h,
                color: context.color.secondary,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Gap(4.h),
          Flexible(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: Column(
                key: ValueKey(currentStep),
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentStep == 0
                        ? 'Create An Account! 👋'
                        : 'Almost There! 🔐',
                    style: context.bodyLarge?.copyWith(
                      fontSize: 25.sp,
                      fontFamily: 'Titillium Web',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Gap(6.h),
                  Text(
                    currentStep == 0
                        ? 'Sign up for free and let us be your trusted companion in construction.'
                        : '''Set up your password to secure your account.\nAvoid disclosing your password to anyone. ''',
                    style: context.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.76),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
