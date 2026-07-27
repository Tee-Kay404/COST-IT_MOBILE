import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';
import 'package:cost_it_mobile/feature/products/widgets/global_products_card.dart';

import 'package:cost_it_mobile/feature/products/widgets/product_shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrendingSection extends ConsumerWidget {
  const TrendingSection({super.key});

  static const int _previewLimit = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingProductsProvider);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final crossAxisCount = screenWidth >= 900
        ? 5
        : screenWidth >= 700
        ? 4
        : 2;

    final padding = EdgeInsets.symmetric(horizontal: 15.w);

    return trendingAsync.when(
      loading: () => SyncedShimmerGrid(
        itemCount: 6,
        crossAxisCount: crossAxisCount,
        padding: padding,
      ),

      error: (e, _) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                color: Colors.grey.shade400,
                size: 30.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                'Could not load products',
                style: context.bodySmall?.copyWith(
                  color: context.color.onSurface.withValues(alpha: 0.5),
                  fontSize: 12.sp,
                ),
              ),
              TextButton(
                onPressed: () => ref.invalidate(trendingProductsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),

      data: (products) {
        if (products.isEmpty) return const SizedBox.shrink();

        final visible = products.take(_previewLimit).toList();

        return Padding(
          padding: padding,
          child: MasonryGridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
            ),
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            itemCount: visible.length,
            itemBuilder: (_, index) => ProductCard(product: visible[index]),
          ),
        );
      },
    );
  }
}
