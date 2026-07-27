import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

Future<void> confirmDestructive(
  BuildContext context,
  WidgetRef ref,
  String actionTitle,
) async {
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    backgroundColor: context.color.surface,
    builder: (ctx) {
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
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
                  color: isDark ? CostItColors.brightGrey.shade800 : Colors.grey.shade300,
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
                child: Icon(
                  Icons.person_remove_outlined,
                  size: 32.sp,
                  color: CostItColors.error,
                ),
              ),
              Gap(16.h),
              Text(
                actionTitle,
                style: context.titleMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: context.color.inverseSurface,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(8.h),
              Text(
                'This action is permanent and cannot be undone. All your data will be erased. Are you sure you want to proceed?',
                textAlign: TextAlign.center,
                style: context.bodySmall?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? CostItColors.brightGrey.shade400 : Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              Gap(28.h),
              SharedButton(
                onPressed: () => Navigator.pop(ctx, true),
                text: actionTitle,
                color: CostItColors.error,
                height: 50.h,
              ),
              Gap(10.h),
              SharedButton(
                onPressed: () => Navigator.pop(ctx, false),
                text: 'Cancel',
                color: isDark ? CostItColors.brightGrey.shade800 : CostItColors.brightGrey.shade200,
                disabledForeground: context.color.inverseSurface, // Make the text visible
                height: 50.h,
              ),
            ],
          ),
        ),
      );
    },
  );

  if (confirmed == true) {
    // TODO: wire to auth/account repository
  }
}

