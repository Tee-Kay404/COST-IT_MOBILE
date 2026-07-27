import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/widgets/special_offers/special_offer_section.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialOfferCard extends StatelessWidget {
  final Product product;
  final int index;
  const SpecialOfferCard({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final offer = product.specialOffer!;
    final colors = OfferTheme.gradientFor(index);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          PageRoutes.productDetails.name,
          arguments: product,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.sp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CostItColors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              right: 30,
              top: -30,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CostItColors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
                  if (offer.badgeText != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: CostItColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: CostItColors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        offer.badgeText!,
                        style: context.bodySmall?.copyWith(
                          color: CostItColors.white,
                        ),
                      ),
                    ),

                  SizedBox(height: 10.h),

                  Text(
                    product.title,
                    style: context.bodyMedium?.copyWith(
                      color: CostItColors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4.h),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Up to ',
                          style: context.bodyMedium?.copyWith(
                            color: CostItColors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        TextSpan(
                          text: offer.discountLabel,
                          style: context.bodyLarge?.copyWith(
                            color: CostItColors.white,
                            fontSize: 38.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        TextSpan(
                          text: ' OFF',
                          style: TextStyle(
                            color: CostItColors.white.withValues(alpha: 0.85),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Price
                  Text(
                    '₦${product.price.toStringAsFixed(0)}/${product.unit}',
                    style: context.bodySmall?.copyWith(
                      color: CostItColors.white.withValues(alpha: 0.9),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // CTA
                  SizedBox(
                    height: 38.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          PageRoutes.productDetails.name,
                          arguments: product,
                        );
                      },
                      style: flatButtonStyle(
                        color: CostItColors.white,
                        textColor: colors.first,
                        borderRadius: 10,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: Text(
                        'View Deal',
                        style: context.bodyMedium?.copyWith(
                          color: colors.first,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
