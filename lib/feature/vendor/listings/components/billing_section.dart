import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../billing/models/billing_models.dart';
import '../models/sell.dart';

class ActivePlanSection extends ConsumerWidget {
  const ActivePlanSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(activeSubscriptionProvider);
    final hasNoPlan = sub == null;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormSectionHeader(
            title: 'Current plan',
            subtitle: 'Optional — upgrade anytime later',
            icon: Icons.trending_up_rounded,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasNoPlan ? 'NO ACTIVE PLAN' : sub.type.label.toUpperCase(),
                        style: context.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: hasNoPlan ? CostItColors.brightGrey.shade400 : context.color.primary,
                        ),
                      ),
                      Gap(4.h),
                      if (hasNoPlan)
                        Text(
                          'Start a trial or upgrade to unlock features.',
                          style: context.bodySmall?.copyWith(
                            color: CostItColors.brightGrey.shade500,
                          ),
                        )
                      else
                        SubscriptionBadge(type: sub.type),
                    ],
                  ),
                ),
                if (hasNoPlan)
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, PageRoutes.billing.name);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      side: BorderSide(color: context.color.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'See Plans',
                      style: context.bodySmall?.copyWith(
                        color: context.color.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
