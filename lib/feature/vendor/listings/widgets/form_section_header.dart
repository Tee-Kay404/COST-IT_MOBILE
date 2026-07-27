import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;

  const FormSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? context.color.primary.withOpacity(1)
            : CostItColors.primary.withOpacity(0.2),
        border: Border(
          left: BorderSide(color: context.color.primary, width: 3.w),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18.sp, color: context.color.onPrimary),
            SizedBox(width: 6.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.theme.primaryColorDark,
                    fontSize: 14.sp,
                    letterSpacing: 0.3,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: context.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: context.theme.primaryColorDark.withOpacity(0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: 8.w),
            trailing!,
          ],
        ],
      ),
    );
  }
}
