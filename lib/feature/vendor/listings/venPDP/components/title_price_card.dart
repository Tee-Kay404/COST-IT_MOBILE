import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/widgets/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Title, price, unit, bulk-price hint, and pricing-type badge.
class TitlePriceCard extends StatelessWidget {
  final Product product;
  const TitlePriceCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: context.titleMedium?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          Gap(10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₦${formatPrice(product.price)}',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: context.color.onPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              Gap(6.w),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  '/ ${product.unit}',
                  style: context.bodySmall?.copyWith(
                    color: CostItColors.brightGrey.shade400,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              _PricingBadge(type: product.pricingType),
            ],
          ),
          if (product.bulkPrice != null && product.bulkSize != null) ...[
            Gap(6.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: CostItColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: CostItColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 12.sp,
                    color: CostItColors.success,
                  ),
                  Gap(5.w),
                  Text(
                    'Bulk: ₦${formatPrice(product.bulkPrice!)} for ${product.bulkSize}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: CostItColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Gap(6.h),
          Divider(color: CostItColors.brightGrey.shade100),
        ],
      ),
    );
  }
}

/// Pricing type badge — Fixed / Negotiable use primary color at
/// different weights; Open Price is a quiet, minimal text+icon
/// treatment rather than a loud outlined chip.
class _PricingBadge extends StatelessWidget {
  final PricingType type;
  const _PricingBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case PricingType.firm:
        return _chip(
          context: context,
          label: 'Fixed Price',
          icon: Icons.lock_outline_rounded,
          color: context.color.primary,
          filled: true,
        );
      case PricingType.flexible:
        return _chip(
          context: context,
          label: 'Negotiable',
          icon: Icons.handshake_outlined,
          color: context.color.primary,
          filled: false,
        );
      case PricingType.open:
        // Quiet treatment: no chip/border, just a muted label —
        // avoids implying a fixed value where price is open-ended.
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune_rounded,
              size: 12.sp,
              color: CostItColors.brightGrey.shade400,
            ),
            Gap(4.w),
            Text(
              'Open Price',
              style: TextStyle(
                fontSize: 11.sp,
                color: CostItColors.brightGrey.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
    }
  }

  Widget _chip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required bool filled,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: filled ? 0.1 : 0.06),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.sp, color: color),
          Gap(4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}