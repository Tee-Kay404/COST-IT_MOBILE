import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

Future<void> showDialogMessage(
  BuildContext context, {
  Duration duration = const Duration(milliseconds: 4),
}) {
  return showDialog(
    useRootNavigator: true,
    animationStyle: AnimationStyle(curve: Curves.easeInOut),
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5), // optional
    context: context,
    builder: (BuildContext context) {
      final theme = Theme.of(context);
      return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: 30.w,
        ), 
        backgroundColor: theme.primaryColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
                        children: [
              Gap(5.h),
              Row(
                children: [
                  Icon(
                    Icons.check_box_outlined,
                    color: CostItColors.success,
                    size: 25.sp,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Account Created Successfully',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              Gap(10.h),
              Text('Login to get Started', style: theme.textTheme.bodySmall),
              Gap(20.h),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: Theme.of(context).textButtonTheme.style,
                child: Center(child: Text('Cancel')),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showFeatureNotEnabledDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: context.color.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white 
                      : context.color.primary, 
                  BlendMode.srcIn,
                ),
                child: Lottie.asset(
                  "assets/animations/sorry4.json",
                  height: 120.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Coming Soon!",
                textAlign: TextAlign.center,
                style: context.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.color.onPrimary,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "We're still working on this feature. Check back later!",
                textAlign: TextAlign.center,
                style: context.bodyMedium?.copyWith(
                  color: context.color.inverseSurface.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: context.color.primary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  "Got It",
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<bool?> showDiscardChangesDialog(BuildContext context) {
  return showDialog<bool>(
    barrierDismissible: false,
    useRootNavigator: true,
    context: context,
    builder: (context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        titlePadding: EdgeInsets.only(top: 20.h, left: 24.w, right: 24.w),
        contentPadding: EdgeInsets.only(top: 12.h, left: 24.w, right: 24.w, bottom: 8.h),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        title: Text(
          'Discard Changes?', 
          style: context.titleSmall?.copyWith(fontSize: 16.sp),
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to discard them?',
          style: context.bodySmall?.copyWith(
            fontWeight: FontWeight.normal,
            color: context.color.inverseSurface.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No', style: context.bodySmall),
          ),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Yes',
              style: context.bodySmall?.copyWith(color: CostItColors.error),
            ),
          ),
        ],
      );
    },
  );
}
