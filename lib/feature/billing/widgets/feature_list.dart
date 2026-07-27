import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:cost_it_mobile/widgets/glass_card.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';

import '../enums/billing_enums.dart';
import '../models/plan_feature.dart';
import 'feature_tile.dart';

class FeatureList extends StatelessWidget {
  final List<PlanFeature> features;
  final SubscriptionType planType;

  const FeatureList({
    super.key,
    required this.features,
    required this.planType,
  });

  bool get _isPremium => planType == SubscriptionType.super_;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      blurSigma: 14,
      borderWidth: 1,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isPremium
                    ? Icons.workspace_premium_rounded
                    : Icons.check_circle_outline_rounded,
                size: 14.sp,
                color: context.color.onPrimary,
              ),
              SizedBox(width: 7.w),
              Text(
                _isPremium ? "What's in Super" : "What's included",
                style: context.bodySmall?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: context.color.onPrimary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          Gap(12.h),
          ...features.map(
            (f) => FeatureTile(feature: f, isPremium: _isPremium),
          ),
        ],
      ),
    );
  }
}
