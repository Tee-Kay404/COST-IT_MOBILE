import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? valueLabel;
  final bool hasNotificationDot;
  final bool isDestructive;
  final VoidCallback? onTap;

  const SettingsListTile({
    super.key,
    required this.title,
    required this.icon,
    this.valueLabel,
    this.hasNotificationDot = false,
    this.isDestructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor = isDestructive
        ? context.color.error
        : context.color.onPrimary;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: resolvedIconColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: resolvedIconColor, size: 20.sp),
          ),
          if (hasNotificationDot)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 10.r,
                height: 10.r,
                decoration: BoxDecoration(
                  color: context.color.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.theme.scaffoldBackgroundColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        title,
        style: context.bodyMedium?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isDestructive ? context.color.error : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (valueLabel != null) ...[
            Text(
              valueLabel!,
              style: context.bodySmall?.copyWith(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4.w),
          ],
          Icon(
            Icons.arrow_forward_ios,
            size: 14.sp,
            color: Colors.grey.shade600,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
