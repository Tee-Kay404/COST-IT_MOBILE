import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: isDark
                    ? context.color.secondary.withValues(alpha: 0.1)
                    : context.color.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 48.sp,
                color: isDark
                    ? context.color.secondary
                    : context.color.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'No notifications yet',
              style: context.bodyMedium?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: context.color.inverseSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'When you get notifications about orders, price alerts, or messages, they\'ll show up here.',
              textAlign: TextAlign.center,
              style: context.bodySmall?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? CostItColors.brightGrey.shade400
                    : CostItColors.brightGrey.shade500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
