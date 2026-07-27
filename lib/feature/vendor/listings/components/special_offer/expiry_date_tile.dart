import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

// Lightweight date formatter
String _formatDate(DateTime d) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${weekdays[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
}

class ExpiryDateTile extends StatelessWidget {
  final DateTime? value;
  final bool isDark;
  final VoidCallback onPick;
  final VoidCallback onClear;
  final String? errorText;

  const ExpiryDateTile({
    super.key,
    required this.value,
    required this.isDark,
    required this.onPick,
    required this.onClear,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    final label = hasValue ? _formatDate(value!) : null;
    final daysLeft = hasValue ? value!.difference(DateTime.now()).inDays : null;

    final tile = InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: hasValue
              ? context.color.primary.withOpacity(0.05)
              : isDark
              ? CostItColors.brightGrey.shade800
              : CostItColors.brightGrey.shade50,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: errorText != null
                ? CostItColors.error
                : hasValue
                    ? context.color.primary.withOpacity(0.5)
                    : Colors.grey.shade300,
            width: hasValue ? 1.2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 18.sp,
              color: hasValue ? context.color.primary : Colors.grey.shade400,
            ),
            Gap(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasValue ? 'Offer expires on' : 'Expiry date',
                    style: context.bodySmall?.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: hasValue
                          ? context.color.primary
                          : Colors.grey.shade500,
                    ),
                  ),
                  if (hasValue) ...[
                    Gap(2.h),
                    Row(
                      children: [
                        Text(
                          label!,
                          style: context.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: context.theme.primaryColorDark,
                          ),
                        ),
                        Gap(8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: daysLeft! <= 3
                                ? CostItColors.error.withOpacity(0.12)
                                : context.color.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            daysLeft == 0
                                ? 'Today'
                                : '$daysLeft day${daysLeft == 1 ? '' : 's'} left',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: daysLeft <= 3
                                  ? CostItColors.error
                                  : context.color.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (hasValue)
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close_rounded,
                  size: 18.sp,
                  color: Colors.grey.shade400,
                ),
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );

    if (errorText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tile,
          Gap(6.h),
          Text(
            errorText!,
            style: context.bodySmall?.copyWith(
              fontSize: 11.sp,
              color: CostItColors.error,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }

    return tile;
  }
}
