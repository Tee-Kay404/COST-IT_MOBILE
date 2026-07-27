import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:cost_it_mobile/app/theme/theme.dart';

import '../models/plan_feature.dart';

class FeatureTile extends StatelessWidget {
  final PlanFeature feature;

  final bool isPremium;

  const FeatureTile({super.key, required this.feature, this.isPremium = false});

  @override
  Widget build(BuildContext context) {
    final accent = (isPremium && feature.isHighlighted)
        ? context.color.secondary
        : context.theme.focusColor;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withOpacity(0.12),
            ),
            child: Icon(feature.icon, size: 15.sp, color: accent),
          ),
          Gap(12.w),
          Expanded(
            child: Text(
              feature.title,
              style: context.bodySmall?.copyWith(
                fontSize: 13.sp,
                fontWeight: (isPremium && feature.isHighlighted)
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: context.color.inverseSurface.withOpacity(
                  (isPremium && feature.isHighlighted) ? 0.95 : 0.78,
                ),
              ),
            ),
          ),
          if (isPremium && feature.isHighlighted)
            Icon(
              Icons.star_rounded,
              size: 13.sp,
              color: context.color.secondary,
            ),
        ],
      ),
    );
  }
}
