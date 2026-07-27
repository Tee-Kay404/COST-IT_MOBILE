import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cost_it_mobile/feature/auth/service/auth_service.dart';

Future<void> showLogoutSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    backgroundColor: context.color.surface,
    builder: (_) => const _LogoutSheet(),
  );
}

class _LogoutSheet extends ConsumerWidget {
  const _LogoutSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Gap(20.h),
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: CostItColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Transform.flip(
                flipX: true,
                child: Icon(
                  Icons.logout_rounded,
                  size: 32.sp,
                  color: CostItColors.error,
                ),
              ),
            ),
            Gap(16.h),
            Text(
              'Are you sure you want to log out?',
              style: context.bodyMedium?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            Text(
              'If you log out, you will not receive any notifications regarding messages, products, and offers. You will need to log back in to access your account.',
              textAlign: TextAlign.center,
              style: context.bodySmall?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            Gap(28.h),
            SharedButton(
              onPressed: () {
                ref.read(authServiceProvider).logout(context, ref);
              },
              text: 'Log out',
              color: CostItColors.error,
              textColor: CostItColors.white,
              height: 50.h,
            ),
            Gap(10.h),
            SharedButton(
              onPressed: () => Navigator.pop(context),
              text: 'Cancel',
              color: Colors.transparent,
              textColor: context.color.inverseSurface,
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }
}
