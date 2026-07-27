import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:cost_it_mobile/app/theme/theme.dart';

import '../enums/billing_enums.dart';
import '../models/billing_models.dart';

class PricingCard extends StatelessWidget {
  final BillingCycle cycle;
  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const PricingCard({
    super.key,
    required this.cycle,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  bool get _isYearly => cycle == BillingCycle.yearly;

  @override
  Widget build(BuildContext context) {
    final savings = plan.pricing.yearlySavingsPercent;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.color.onPrimary,
                    context.color.onPrimary.withOpacity(0.72),
                  ],
                )
              : null,
          color: isSelected ? null : context.color.surface,
          border: Border.all(
            color: isSelected
                ? context.color.primary
                : context.color.primary.withOpacity(0.14),
            width: isSelected ? 1.6 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.color.primary.withOpacity(0.32),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cycle.label,
                  style: context.bodySmall?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white.withOpacity(0.8)
                        : context.color.inverseSurface.withOpacity(0.5),
                  ),
                ),
                if (_isYearly && savings > 0)
                  _SavingsBadge(savings: savings, isSelected: isSelected),
              ],
            ),
            Gap(10.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: plan.pricing.currencySymbol,
                    style: context.bodySmall?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : context.color.inverseSurface,
                    ),
                  ),
                  TextSpan(
                    text: _formatRaw(plan.pricing.priceFor(cycle)),
                    style: context.titleLarge?.copyWith(
                      fontSize: 27.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                      color: isSelected
                          ? Colors.white
                          : context.color.inverseSurface,
                    ),
                  ),
                ],
              ),
            ),
            Gap(2.h),
            Text(
              _isYearly ? '/year' : '/month',
              style: context.bodySmall?.copyWith(
                fontSize: 11.sp,
                color: isSelected
                    ? Colors.white.withOpacity(0.65)
                    : context.color.inverseSurface.withOpacity(0.38),
              ),
            ),
            if (_isYearly && !isSelected) ...[
              Gap(7.h),
              Text(
                'Save $savings% vs monthly',
                style: context.bodySmall?.copyWith(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                  color: CostItColors.brightGrey.shade400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatRaw(double price) => price
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}

class _SavingsBadge extends StatelessWidget {
  final int savings;
  final bool isSelected;

  const _SavingsBadge({required this.savings, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withOpacity(0.2)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: isSelected
            ? Border.all(color: Colors.white.withOpacity(0.25))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.white : Colors.green,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            '-$savings%',
            style: context.bodySmall?.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
