import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/components/product_format/list_card.dart';
import 'package:cost_it_mobile/feature/products/components/seeAll/enums.dart';
import 'package:cost_it_mobile/feature/products/components/seeAll/provider/see_all_provider.dart';
import 'package:cost_it_mobile/feature/products/models/category.dart';
import 'package:cost_it_mobile/feature/products/widgets/global_products_card.dart';
import 'package:cost_it_mobile/feature/products/widgets/product_list_shimmer.dart';
import 'package:cost_it_mobile/feature/products/widgets/product_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cost_it_mobile/feature/products/components/product_format/app_product_slivers.dart';
import '../../models/display_mode.dart';
import '../utils/product_filter_cache.dart';

class CategoryTabView extends ConsumerStatefulWidget {
  final ProductCategory category;
  final String searchQuery;
  final DisplayMode displayMode;
  // Removed gridDelegate

  const CategoryTabView({
    super.key, // caller should pass ValueKey(category.id)
    required this.category,
    required this.searchQuery,
    required this.displayMode,
    // Removed gridDelegate parameter
  });

  @override
  ConsumerState<CategoryTabView> createState() => _CategoryTabViewState();
}

class _CategoryTabViewState extends ConsumerState<CategoryTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();

 
  bool _paginating = false;

  final ProductFilterCache _filterCache = ProductFilterCache();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _filterCache.invalidate();
    super.dispose();
  }

  
  void _onScroll() {
    if (!_scrollController.hasClients || _paginating) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) {
      _paginating = true;
      ref
          .read(seeAllProvider(SeeAllSection.categories).notifier)
          .fetchNextPage()
          .whenComplete(() => _paginating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 

    final seeAllAsync = ref.watch(seeAllProvider(SeeAllSection.categories));

    return seeAllAsync.when(
      loading: _buildShimmer,
      error: (e, _) => _buildError(e),
      data: (state) {
        final filtered = _filterCache.filter(
          items: state.items,
          categoryId: widget.category.id,
          searchQuery: widget.searchQuery,
        );

        if (filtered.isEmpty && widget.searchQuery.isNotEmpty) {
          return _buildEmptySearch();
        }
        if (filtered.isEmpty) {
          return _buildEmptySection();
        }

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            widget.displayMode == DisplayMode.grid
                ? AppProductSliverGrid(
                    itemCount: filtered.length,
                    padding: EdgeInsets.fromLTRB(15.w, 16.h, 15.w, 0),
                    itemBuilder: (_, i) => ProductCard(product: filtered[i]),
                  )
                : AppProductSliverList(
                    itemCount: filtered.length,
                    padding: EdgeInsets.fromLTRB(15.w, 16.h, 15.w, 0),
                    itemBuilder: (_, i) => ProductListCard(product: filtered[i]),
                  ),

            if (state.isFetchingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.color.primary,
                    ),
                  ),
                ),
              ),

            if (!state.hasMore && filtered.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: Text(
                      "You've seen it all",
                      style: context.bodySmall?.copyWith(
                        color: CostItColors.brightGrey.shade400,
                      ),
                    ),
                  ),
                ),
              ),

            SliverToBoxAdapter(child: SizedBox(height: 80.h)),
          ],
        );
      },
    );
  }


  Widget _buildShimmer() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 16.h, 15.w, 0),
      child: widget.displayMode == DisplayMode.grid
          ? SyncedShimmerGrid(
              itemCount: 8,
              padding: EdgeInsets.zero,
            )
          : ListView.separated(
              itemCount: 8,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (_, __) => const ProductListShimmer(),
            ),
    );
  }

  Widget _buildError(Object e) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded,
              color: Colors.grey.shade400, size: 36.sp),
          SizedBox(height: 10.h),
          Text(
            'Could not load products',
            style: context.bodySmall?.copyWith(color: context.color.onSurface.withValues(alpha: 0.5), fontSize: 13.sp),
          ),
          TextButton(
            onPressed: () =>
                ref.invalidate(seeAllProvider(SeeAllSection.categories)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded,
              color: Colors.grey.shade400, size: 36.sp),
          SizedBox(height: 10.h),
          Text(
            'No results for "${widget.searchQuery}"',
            style: context.bodySmall?.copyWith(color: context.color.onSurface.withValues(alpha: 0.5), fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySection() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, color: Colors.grey.shade400, size: 36.sp),
          SizedBox(height: 10.h),
          Text(
            'Nothing here yet',
            style: context.bodySmall?.copyWith(color: context.color.onSurface.withValues(alpha: 0.5), fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}