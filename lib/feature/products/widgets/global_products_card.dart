import 'package:cached_network_image/cached_network_image.dart';
import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/widgets/tools.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/widget/saved_icon.dart';
import 'package:cost_it_mobile/feature/products/widgets/product_shimmer.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onSave;
  final bool isSaved;
  final bool isSelectionMode;

  const ProductCard({
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
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            PageRoutes.productDetails.name,
            arguments: product,
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: context.color.inversePrimary,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: context.color.primary.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image — fills card width, square (bounded by LayoutBuilder)
              LayoutBuilder(
                builder: (context, constraints) {
                  final side = constraints.maxWidth;
                  return SizedBox(
                    width: side,
                    height: side,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
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
                                    color:
                                        product.status == ListingStatus.outOfStock
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
                  );
                },
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
          _categoryIcon(product.categoryId),
          size: 36.sp,
          color: context.color.primary,
        ),
      ),
    );

    if (product.displayImage == null) return fallback;

    return CachedNetworkImage(
      imageUrl: product.displayImage!,
      fit: BoxFit.cover,
      placeholder: (context, url) => const ProductImageShimmer(),
      errorWidget: (context, url, error) => fallback,
      fadeInDuration: const Duration(milliseconds: 250),
      fadeOutDuration: const Duration(milliseconds: 150),
    );
  }
}

IconData _categoryIcon(String categoryId) {
  switch (categoryId) {
    case 'cat_materials':
      return Icons.layers_outlined;

    case 'cat_tools':
      return Icons.handyman_outlined;

    case 'cat_machinery':
      return Icons.precision_manufacturing_outlined;

    case 'cat_electrical':
      return Icons.electrical_services_outlined;

    case 'cat_plumbing':
      return Icons.plumbing_outlined;

    case 'cat_safety':
      return Icons.health_and_safety_outlined;

    case 'cat_finishing':
      return Icons.format_paint_outlined;

    case 'cat_logistics':
      return Icons.local_shipping_outlined;

    case 'cat_services':
      return Icons.construction_outlined;

    default:
      return Icons.category_outlined;
  }
}

String formatLocationCondition(Product product, {bool excludeCondition = false}) {
  final parts = <String>[];
  
  if (product.location != null && product.location!.isNotEmpty) {
    // If the location has State or LGA, we strip them to keep it clean.
    var loc = product.location!
        .replaceAll(RegExp(r'\bState\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'\bLGA\b', caseSensitive: false), '')
        .trim();
    // Fix possible trailing commas from replacements
    loc = loc.replaceAll(RegExp(r',\s*$'), '');
    parts.add(loc);
  }

  if (!excludeCondition && product.condition != null && product.condition!.isNotEmpty) {
    parts.add(product.condition!);
  }

  return parts.join(' • ');
}
