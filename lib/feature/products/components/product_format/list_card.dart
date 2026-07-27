import 'package:cached_network_image/cached_network_image.dart';
import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/widgets/tools.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/widgets/product_shimmer.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/feature/products/widgets/global_products_card.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/widget/saved_icon.dart';

class ProductListCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onSave;
  final bool isSaved;
  final bool isSelectionMode;

  const ProductListCard({
    super.key,
    required this.product,
    this.onSave,
    this.isSaved = false,
    this.isSelectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            PageRoutes.productDetails.name,
            arguments: product,
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            color: context.color.inversePrimary,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: context.color.primary.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 0, 8.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.42,
                    height: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildImage(context),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: SaveIconButton(
                            productId: product.id,
                            style: SaveIconStyle.floatingOnImage,
                            backgroundColor: Colors.black.withValues(
                              alpha: 0.30,
                            ),
                            iconColor: CostItColors.white,
                            size: 32.w,
                          ),
                        ),
                        if (!product.isAvailable)
                          Positioned(
                            top: 8.h,
                            left: 8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: product.status == ListingStatus.outOfStock
                                    ? const Color(0xFFFF9800)
                                    : const Color(0xFFE53935),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                product.status == ListingStatus.outOfStock
                                    ? 'Out of Stock'
                                    : 'Unavailable',
                                style: context.bodySmall?.copyWith(
                                  color: CostItColors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.title,
                        style: context.bodySmall?.copyWith(
                          color: context.color.inverseSurface,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '₦${formatPrice(product.price)}',
                            style: context.bodySmall?.copyWith(
                              color: context.color.onPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                          ),
                          if (product.bulkSize != null && product.bulkSize!.isNotEmpty) ...[
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                'per ${product.bulkSize}',
                                style: context.bodySmall?.copyWith(
                                  color: CostItColors.brightGrey.shade400,
                                  fontSize: 11.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        formatLocationCondition(product, excludeCondition: isSelectionMode),
                        style: context.bodySmall?.copyWith(
                          color: CostItColors.brightGrey.shade400,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final fallback = Container(
      color: context.color.surface,
      child: Center(
        child: Icon(
          Icons.category_outlined,
          size: 28.sp,
          color: context.color.primary,
        ),
      ),
    );
    if (product.displayImage == null) return fallback;
    return CachedNetworkImage(
      imageUrl: product.displayImage!,
      fit: BoxFit.cover,
      placeholder: (_, __) => const ProductImageShimmer(),
      errorWidget: (_, __, ___) => fallback,
      fadeInDuration: const Duration(milliseconds: 250),
    );
  }
}
