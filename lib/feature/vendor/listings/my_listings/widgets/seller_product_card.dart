import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/vendor/listings/my_listings/widgets/seller_product_overflow_menu.dart';
import 'package:cost_it_mobile/widgets/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SellerProductCard extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final bool isSelectionMode;
  final ValueChanged<ProductAction>? onActionSelected;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;

  const SellerProductCard({
    super.key,
    required this.product,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.onActionSelected,
    this.onLongPress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnail = product.displayImage;
    final isDraft =
        product.status == ListingStatus.unavailable ||
        product.status == ListingStatus.suspended;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isSelected
            ? context.color.primary.withValues(alpha: 0.05)
            : context.color.inversePrimary,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSelected ? context.color.primary : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          if (!isSelected)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Thumbnail
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.38,
                    height: 135.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.r),
                        bottomLeft: Radius.circular(14.r),
                      ),
                      child: thumbnail != null
                          ? Image.network(
                              thumbnail,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _PlaceholderThumb(),
                            )
                          : _PlaceholderThumb(),
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(12.w, 12.h, 16.w, 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + badge in same row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.sp,
                                    height: 1.35,
                                    color: context.color.inverseSurface,
                                  ),
                                ),
                              ),
                              SizedBox(width: 36.w), // space for overflow menu
                            ],
                          ),

                          Gap(6.h),

                          // Price
                          Text(
                            '₦${formatPrice(product.price)} / ${product.unit}',
                            style: context.bodySmall?.copyWith(
                              color: context.color.onPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.sp,
                            ),
                          ),

                          Gap(4.h),

                          Text(
                            product.categoryLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.bodySmall?.copyWith(
                              color: CostItColors.brightGrey.shade400,
                              fontSize: 11.sp,
                            ),
                          ),
                          
                          if (product.condition != null || product.location != null) ...[
                            Gap(4.h),
                            Row(
                              children: [
                                if (product.condition != null) ...[
                                  Icon(Icons.sell_outlined, size: 10.sp, color: CostItColors.brightGrey.shade400),
                                  Gap(2.w),
                                  Text(
                                    product.condition!,
                                    style: context.bodySmall?.copyWith(
                                      fontSize: 10.sp,
                                      color: CostItColors.brightGrey.shade400,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                                if (product.condition != null && product.location != null) ...[
                                  Gap(6.w),
                                  Text('•', style: TextStyle(color: CostItColors.brightGrey.shade400, fontSize: 10.sp)),
                                  Gap(6.w),
                                ],
                                if (product.location != null) ...[
                                  Icon(Icons.location_on_outlined, size: 10.sp, color: CostItColors.brightGrey.shade400),
                                  Gap(2.w),
                                  Expanded(
                                    child: Text(
                                      product.location!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.bodySmall?.copyWith(
                                        fontSize: 10.sp,
                                        color: CostItColors.brightGrey.shade400,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                          Gap(12.h),
                          const Spacer(),

                          // Bottom Metrics Row
                          Row(
                            children: [
                              _StatusBadge(status: product.status),
                              const Spacer(),
                              if (!isDraft) ...[
                                _Metric(
                                  icon: Icons.visibility_outlined,
                                  value: product.views.toString(),
                                ),
                                Gap(8.w),
                                _Metric(
                                  icon: Icons.chat_bubble_outline_rounded,
                                  value: product.inquiries.toString(),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Overflow Menu or Selection Checkbox Positioned at top right
            Positioned(
              top: 8.h,
              right: 16.w,
              child: isSelectionMode
                  ? Container(
                      margin: EdgeInsets.only(top: 4.h, right: 4.w),
                      width: 22.r,
                      height: 22.r,
                      decoration: BoxDecoration(
                        color: isSelected ? context.color.primary : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isSelected ? null : Border.all(color: CostItColors.brightGrey.shade400, width: 2),
                      ),
                      child: isSelected
                          ? Icon(Icons.check_rounded, color: CostItColors.white, size: 14.sp)
                          : null,
                    )
                  : SellerProductOverflowMenu(
                      isDraft: isDraft,
                      onActionSelected: onActionSelected ?? (_) {},
                    ),
            ),

            // Special Offer Badge
            if (product.specialOffer?.isActive == true)
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: CostItColors.error,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    product.specialOffer!.discountLabel,
                    style: context.bodySmall?.copyWith(
                      color: CostItColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final String value;

  const _Metric({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: CostItColors.brightGrey.shade400),
        Gap(4.w),
        Text(
          value,
          style: context.bodySmall?.copyWith(
            color: CostItColors.brightGrey.shade400,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ListingStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;

    switch (status) {
      case ListingStatus.available:
        label = 'Published';
        color = CostItColors.success;
        break;
      case ListingStatus.unavailable:
      case ListingStatus.suspended:
        label = 'Draft';
        color = context.color.secondary;
        break;
      case ListingStatus.outOfStock:
        label = 'Out of Stock';
        color = CostItColors.error;
        break;
      case ListingStatus.pendingReview:
        label = 'Pending Review';
        color = CostItColors.primary;
        break;
      case ListingStatus.rejected:
        label = 'Rejected';
        color = CostItColors.error;
        break;
      case ListingStatus.archived:
        label = 'Archived';
        color = CostItColors.brightGrey.shade500;
        break;
    }

    final bgColor = color.withValues(alpha: 0.12);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Gap(4.w),
          Text(
            label,
            style: context.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderThumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.color.surface,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: CostItColors.brightGrey.shade300,
        size: 28.sp,
      ),
    );
  }
}
