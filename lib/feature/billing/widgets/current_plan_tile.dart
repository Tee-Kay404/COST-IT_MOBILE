import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:cost_it_mobile/app/theme/theme.dart';

import '../enums/billing_enums.dart';

import '../providers/billing_provider.dart';
import '../utils/billing_xtensions.dart';
import 'subscription_badge.dart';

class CurrentPlanTile extends ConsumerWidget {
  final VoidCallback onTap;

  const CurrentPlanTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(activeSubscriptionProvider);
    if (sub == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: context.color.primary.withOpacity(0.13)),
        ),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD700).withOpacity(0.14),
              ),
              child: Icon(
                Icons.workspace_premium_rounded,
                size: 18.sp,
                color: const Color(0xFFFFD700),
              ),
            ),
            Gap(10.w),
            Expanded(child: _PaidCopy(sub: sub)),
            Icon(
              Icons.tune_rounded,
              size: 13.sp,
              color: context.color.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaidCopy extends StatelessWidget {
  final dynamic sub;
  const _PaidCopy({required this.sub});

  @override
  Widget build(BuildContext context) {
    final daysLeft = sub.daysLeft as int?;
    final isLow = daysLeft != null && daysLeft < 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              sub.type.label as String,
              style: context.bodyMedium?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: context.color.inverseSurface,
              ),
            ),
            SizedBox(width: 6.w),
            SubscriptionBadge(
              type: sub.type as SubscriptionType,
              compact: true,
            ),
          ],
        ),
        if (daysLeft != null)
          Text(
            sub.status == SubscriptionStatus.trial
                ? 'Trial · ${daysLeft}d left'
                : '${(sub.status as SubscriptionStatus).displayLabel} · ${daysLeft}d left',
            style: context.bodySmall?.copyWith(
              fontSize: 11.sp,
              color: isLow
                  ? Colors.orange
                  : context.color.inverseSurface.withOpacity(0.45),
            ),
          ),
      ],
    );
  }
}
