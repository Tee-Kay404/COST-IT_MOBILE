import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/widgets/tools.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceMetaSection extends StatelessWidget {
  final Product product;

  const PriceMetaSection({super.key, required this.product});

  String _getPricingTypeLabel(PricingType type) {
    switch (type) {
      case PricingType.open:
        return 'Ask Me';
      case PricingType.firm:
        return 'Fixed';
      case PricingType.flexible:
        return 'Negotiable';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.color.surface,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.sp,
                color: Colors.grey.shade500,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  product.vendor.location ?? 'Lagos, Nigeria',
                  style: context.bodySmall?.copyWith(
                    color: CostItColors.brightGrey.shade400,
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                parseDateTimeWithDay(product.createdAt),
                style: context.bodySmall?.copyWith(
                  color: CostItColors.brightGrey.shade400,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            product.title,
            style: context.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
              height: 1.3,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₦${formatPrice(product.price)}',
                    style: context.bodyMedium?.copyWith(
                      color: context.color.onPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'per ${product.unit}',
                    style: context.bodySmall?.copyWith(
                      color: CostItColors.brightGrey.shade400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: context.color.onPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  _getPricingTypeLabel(product.pricingType),
                  style: context.bodySmall?.copyWith(
                    color: context.color.onPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
