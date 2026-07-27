import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cost_it_mobile/app/theme/theme.dart';

import '../enums/billing_enums.dart';

class PlanToggle extends StatelessWidget {
  final SubscriptionType selected;
  final ValueChanged<SubscriptionType> onChanged;

  const PlanToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _plans = [SubscriptionType.basic, SubscriptionType.super_];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(40.r),
          border: Border.all(
            color: context.color.primary.withOpacity(0.14),
          ),
        ),
        child: Row(
          children: _plans
              .map(
                (plan) => Expanded(
                  child: _ToggleChip(
                    plan: plan,
                    isSelected: selected == plan,
                    onTap: () => onChanged(plan),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final SubscriptionType plan;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 11.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? context.color.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(34.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.color.primary.withOpacity(0.28),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: (context.bodySmall ?? const TextStyle()).copyWith(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : context.color.inverseSurface.withOpacity(0.55),
          ),
          child: Text(plan.label),
        ),
      ),
    );
  }
}