import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

Future<bool?> showClearFormSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    backgroundColor: context.color.surface,
    builder: (_) => const _ClearFormSheet(),
  );
}

class _ClearFormSheet extends StatelessWidget {
  const _ClearFormSheet();

  @override
  Widget build(BuildContext context) {
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
              child: Icon(
                Icons.delete_sweep_outlined,
                size: 32.sp,
                color: CostItColors.error,
              ),
            ),
            Gap(16.h),
            Text(
              'Clear all fields?',
              style: context.bodyLarge?.copyWith(fontSize: 18.sp),
            ),
            Gap(8.h),
            Text(
              'Everything you\'ve entered will be removed and you\'ll start fresh.',
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
              onPressed: () => Navigator.pop(context, true),
              text: 'Yes, clear everything',
              color: CostItColors.error,
              height: 50.h,
            ),
            Gap(10.h),
            SharedButton(
              onPressed: () => Navigator.pop(context, false),
              text: 'Keep editing',
              color: CostItColors.brightGrey.shade300,
              textColor: context.color.inverseSurface,
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }
}
