import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/components/product_format/list_card.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/widgets/global_products_card.dart';
import 'package:cost_it_mobile/feature/products/components/product_format/app_product_slivers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/widget/saved_browse_button.dart';

enum RelatedDisplayMode { grid, list }

class RelatedProductsSection extends StatelessWidget {
  final Product product;
  final RelatedDisplayMode mode;
  final VoidCallback onToggleMode;

  const RelatedProductsSection({
    super.key,
    required this.product,
    required this.mode,
    required this.onToggleMode,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: replace with actual related products from provider
    const itemCount = 6;

    return Container(
      color: context.color.surface,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#Related Products',
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.color.onPrimary,
                ),
              ),
              GestureDetector(
                onTap: onToggleMode,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: context.color.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      mode == RelatedDisplayMode.grid
                          ? Icons.view_list_rounded
                          : Icons.grid_view_rounded,
                      key: ValueKey(mode),
                      size: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          if (mode == RelatedDisplayMode.grid)
            AppProductGrid(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              itemBuilder: (_, i) => ProductCard(product: product),
            )
          else
            AppProductList(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              itemBuilder: (_, i) => ProductListCard(product: product),
            ),
          
          SizedBox(height: 20.h),
          BrowseProductButton(
            onBrowse: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
