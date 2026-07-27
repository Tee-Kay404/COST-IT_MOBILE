import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:cost_it_mobile/app/theme/theme.dart';

import '../enums/billing_enums.dart';
import '../utils/billing_xtensions.dart';

class SubscriptionBadge extends StatelessWidget {
  final SubscriptionType type;
  final bool compact;

  const SubscriptionBadge({
    super.key,
    required this.type,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = type.badgeColor(context.color);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7.w : 10.w,
        vertical: compact ? 2.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            type == SubscriptionType.super_
                ? Icons.workspace_premium_rounded
                : Icons.verified_outlined,
            size: compact ? 9.sp : 11.sp,
            color: color,
          ),
          Gap(3.w),
          Text(
            type.badgeLabel,
            style: context.bodySmall?.copyWith(
              fontSize: compact ? 9.sp : 10.5.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}