import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.valueLabel,
    this.badgeCount,
    this.hasNotificationDot = false,
    this.customTrailing,
    this.isDestructive = false,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final String? valueLabel;
  final int? badgeCount;
  final bool hasNotificationDot;
  final Widget? customTrailing;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor = isDestructive
        ? context.color.error
        : (iconColor ?? context.color.onPrimary);

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
                  border: Border.all(color: context.color.surface, width: 1.5),
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
      trailing: _buildTrailing(context),
      onTap: onTap,
    );
  }

  Widget _buildTrailing(BuildContext context) {
    if (customTrailing != null) return customTrailing!;

    return Row(
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

        if (badgeCount != null && badgeCount! > 0) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: context.color.primary,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$badgeCount',
              style: context.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
              ),
            ),
          ),
          SizedBox(width: 6.w),
        ],

        Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey.shade600),
      ],
    );
  }
}
