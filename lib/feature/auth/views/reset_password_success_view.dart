import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ResetPasswordSuccessView extends StatelessWidget {
  const ResetPasswordSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
          child: Column(
            children: [
              const Spacer(),

              // Icon
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: CostItColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_open_rounded,
                  size: 68.sp,
                  color: CostItColors.success,
                ),
              ),

              Gap(32.h),

              Text(
                'Password Reset Successfully!',
                style: context.bodyLarge?.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: context.color.primary,
                ),
                textAlign: TextAlign.center,
              ),

              Gap(12.h),

              Text(
                'Your password has been reset successfully.\nYou can now log in with your new password.',
                style: context.bodySmall?.copyWith(
                  color: CostItColors.brightGrey.shade500,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              Gap(40.h),

              SharedButton(
                text: 'Back to Login',
                icon: (Icons.logout),

                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    PageRoutes.login.name,
                    (route) => false, // clears entire stack
                  );
                },
              ),
              const Spacer(),

              Gap(15.h),
            ],
          ),
        ),
      ),
    );
  }
}
