import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/notifications/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final bool isSelectMode;
  final bool isSelected;
  final VoidCallback? onToggleSelect;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
    this.isSelectMode = false,
    this.isSelected = false,
    this.onToggleSelect,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = notification.type.tintColor;

    final cardContent = GestureDetector(
      onTap: isSelectMode ? onToggleSelect : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: _cardColor(context, isDark, tint),
          borderRadius: BorderRadius.circular(14.r),
          border: _cardBorder(context, isDark, tint),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon badge
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: isDark
                        ? tint.withValues(alpha: 0.15)
                        : tint.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    notification.type.icon,
                    color: tint,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (!notification.isRead)
                            Container(
                              width: 8.w,
                              height: 8.w,
                              margin: EdgeInsets.only(right: 6.w),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? context.color.secondary
                                    : tint,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              notification.title,
                              style: context.bodySmall?.copyWith(
                                fontSize: 14.sp,
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                color: context.color.inverseSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Add spacing so title doesn't overlap checkbox
                          if (isSelectMode) SizedBox(width: 24.w),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        notification.body,
                        style: context.bodySmall?.copyWith(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? CostItColors.brightGrey.shade400
                              : CostItColors.brightGrey.shade500,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? tint.withValues(alpha: 0.12)
                                  : tint.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              notification.type.label,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: tint,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.access_time_rounded,
                            size: 12.sp,
                            color: isDark
                                ? CostItColors.brightGrey.shade500
                                : CostItColors.brightGrey.shade400,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            _formatTimestamp(notification.timestamp),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? CostItColors.brightGrey.shade500
                                  : CostItColors.brightGrey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Selection checkbox (top-right)
            if (isSelectMode)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onToggleSelect,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.color.onPrimary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? context.color.onPrimary
                            : (isDark
                                ? CostItColors.brightGrey.shade600
                                : CostItColors.brightGrey.shade400),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            size: 14.sp,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    // Disable swipe-to-dismiss in select mode
    if (isSelectMode) return cardContent;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.w),
        decoration: BoxDecoration(
          color: CostItColors.error,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
      child: cardContent,
    );
  }

  Color _cardColor(BuildContext context, bool isDark, Color tint) {
    if (isSelected) {
      return isDark
          ? context.color.onPrimary.withValues(alpha: 0.12)
          : context.color.onPrimary.withValues(alpha: 0.06);
    }
    if (notification.isRead) {
      return isDark
          ? CostItColors.brightGrey.shade800.withValues(alpha: 0.4)
          : Colors.white;
    }
    return isDark
        ? context.color.secondary.withValues(alpha: 0.08)
        : tint.withValues(alpha: 0.05);
  }

  Border? _cardBorder(BuildContext context, bool isDark, Color tint) {
    if (isSelected) {
      return Border.all(
        color: context.color.onPrimary.withValues(alpha: 0.5),
        width: 1.5,
      );
    }
    if (!notification.isRead) {
      return Border.all(
        color: isDark
            ? context.color.secondary.withValues(alpha: 0.2)
            : tint.withValues(alpha: 0.15),
        width: 1,
      );
    }
    return null;
  }
}
