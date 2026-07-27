import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/notifications/models/notification_model.dart';
import 'package:cost_it_mobile/shared/appBar/costit_back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationItem notification;

  const NotificationDetailPage({super.key, required this.notification});

  String _formatTimestamp(DateTime timestamp) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    final min = timestamp.minute.toString().padLeft(2, '0');
    return '${months[timestamp.month - 1]} ${timestamp.day}, ${timestamp.year} at $hour:$min $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = notification.type.tintColor;

    return Scaffold(
      backgroundColor: context.color.surface,
      appBar: CostItBackAppBar(title: notification.type.label),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon + Type Badge ──
            Center(
              child: Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: isDark
                      ? tint.withValues(alpha: 0.15)
                      : tint.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  notification.type.icon,
                  color: tint,
                  size: 36.sp,
                ),
              ),
            ),
            Gap(20.h),

            // ── Title ──
            Text(
              notification.title,
              style: context.titleMedium?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: context.color.inverseSurface,
                height: 1.3,
              ),
            ),
            Gap(10.h),

            // ── Timestamp + Status Row ──
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14.sp,
                  color: isDark
                      ? CostItColors.brightGrey.shade500
                      : CostItColors.brightGrey.shade400,
                ),
                SizedBox(width: 4.w),
                Text(
                  _formatTimestamp(notification.timestamp),
                  style: context.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? CostItColors.brightGrey.shade400
                        : CostItColors.brightGrey.shade500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? (isDark
                            ? CostItColors.brightGrey.shade800
                            : CostItColors.brightGrey.shade200)
                        : (isDark
                            ? tint.withValues(alpha: 0.15)
                            : tint.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    notification.isRead ? 'Read' : 'Unread',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: notification.isRead
                          ? (isDark
                              ? CostItColors.brightGrey.shade400
                              : CostItColors.brightGrey.shade600)
                          : tint,
                    ),
                  ),
                ),
              ],
            ),
            Gap(8.h),

            // ── Category pill ──
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isDark
                    ? tint.withValues(alpha: 0.12)
                    : tint.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                notification.type.label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: tint,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            Gap(24.h),

            // ── Divider ──
            Divider(
              color: isDark
                  ? CostItColors.brightGrey.shade800
                  : CostItColors.brightGrey.shade200,
              thickness: 1,
            ),
            Gap(20.h),

            // ── Body ──
            Text(
              notification.body,
              style: context.bodyMedium?.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? CostItColors.brightGrey.shade300
                    : CostItColors.brightGrey.shade700,
                height: 1.6,
              ),
            ),

            Gap(80.h),
          ],
        ),
      ),
    );
  }
}
