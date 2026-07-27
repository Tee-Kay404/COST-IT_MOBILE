import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SignupStepLabel extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBack;

  const SignupStepLabel({
    super.key,
    required this.currentStep,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22.w, 14.h, 22.w, 5.h),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-0.2, 0),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: currentStep == 1
                ? GestureDetector(
                    key: const ValueKey('back'),
                    onTap: onBack,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 13.sp,
                          color: context.color.inverseSurface,
                        ),
                        Gap(4.w),
                        Text(
                          'Back',
                          style: context.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    '-Let’s get started-',
                    key: const ValueKey('start'),
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
          ),
          const Spacer(),
          Row(
            children: List.generate(2, (i) {
              final isActive = i == currentStep;
              final isPast = i < currentStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(left: 5.w),
                width: isActive ? 22.w : 8.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isActive || isPast
                      ? context.color.onPrimary
                      : context.color.onPrimary.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              );
            }),
          ),
          Gap(10.w),
          Text(
            'Step ${currentStep + 1} of 2',
            style: context.bodySmall?.copyWith(
              color: context.color.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
