import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/services/product_service.dart';
import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';
import 'package:cost_it_mobile/feature/vendor/listings/my_listings/widgets/my_listings_empty_state.dart';
import 'package:cost_it_mobile/feature/vendor/listings/my_listings/widgets/my_listings_shimmer.dart';
import 'package:cost_it_mobile/feature/vendor/listings/my_listings/widgets/my_listings_summary_cards.dart';
import 'package:cost_it_mobile/feature/vendor/listings/my_listings/widgets/seller_product_card.dart';
import 'package:cost_it_mobile/feature/vendor/listings/my_listings/widgets/seller_product_overflow_menu.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/shared/appBar/costit_back_app_bar.dart';
import 'package:cost_it_mobile/shared/appBar/costit_overflow_menu.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/utils/saved_sort_option.dart';
import 'package:cost_it_mobile/widgets/costit_refresh_indicator.dart';
import 'package:cost_it_mobile/widgets/arrow_back_button.dart';
import 'package:cost_it_mobile/shared/searchBar/search_bar.dart';
import 'package:cost_it_mobile/feature/vendor/listings/providers/sell_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MyListingsPage extends ConsumerStatefulWidget {
  const MyListingsPage({super.key});

  @override
  ConsumerState<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends ConsumerState<MyListingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedIds = {};
  bool _isSelectionMode = false;
  bool _searchActive = false;
  final FocusNode _searchFocusNode = FocusNode();
  SavedSortOption _currentSort = SavedSortOption.newest;

  final List<String> _tabs = [
    'All',
    'Published',
    'Drafts',
    'Special Offers',
    'Reported',
    'Archived',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _searchActive = false;
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
    });
  }

  MyListingsStats _calculateStats(List<Product> products) {
    int published = 0;
    int drafts = 0;
    int pending = 0;
    int outOfStock = 0;
    int totalViews = 0;

    for (final p in products) {
      if (p.status == ListingStatus.available) published++;
      if (p.status == ListingStatus.unavailable ||
          p.status == ListingStatus.suspended) {
        drafts++;
      }
      if (p.status == ListingStatus.pendingReview) pending++;
      if (p.status == ListingStatus.outOfStock) outOfStock++;
      totalViews += p.views;
    }

    return MyListingsStats(
      totalListings: products.length,
      published: published,
      drafts: drafts,
      pending: pending,
      outOfStock: outOfStock,
      totalViews: totalViews,
    );
  }

  List<Product> _filterProducts(List<Product> products, int tabIndex) {
    var filtered = products;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) =>
                p.title.toLowerCase().contains(_searchQuery) ||
                p.categoryLabel.toLowerCase().contains(_searchQuery),
          )
          .toList();
    }

    // Apply tab filter
    switch (tabIndex) {
      case 0:
        break;
      case 1: // Published
        filtered = filtered
            .where((p) => p.status == ListingStatus.available)
            .toList();
        break;
      case 2: // Drafts
        filtered = filtered
            .where(
              (p) =>
                  p.status == ListingStatus.unavailable ||
                  p.status == ListingStatus.suspended,
            )
            .toList();
        break;
      case 3: // Special Offers
        filtered = filtered
            .where((p) => p.specialOffer?.isActive == true)
            .toList();
        break;
      case 4: // Reported (Rejected under the hood)
        filtered = filtered
            .where((p) => p.status == ListingStatus.rejected)
            .toList();
        break;
      case 5: // Archived
        filtered = filtered
            .where((p) => p.status == ListingStatus.archived)
            .toList();
        break;
    }

    // Apply sorting
    switch (_currentSort) {
      case SavedSortOption.newest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SavedSortOption.oldest:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SavedSortOption.nameAZ:
        filtered.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case SavedSortOption.nameZA:
        filtered.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
        break;
      case SavedSortOption.priceLow:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SavedSortOption.priceHigh:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    return filtered;
  }

  EmptyStateType _getEmptyStateType(int tabIndex) {
    if (_searchQuery.isNotEmpty) return EmptyStateType.search;
    switch (tabIndex) {
      case 0:
        return EmptyStateType.all;
      case 1:
        return EmptyStateType.published;
      case 2:
        return EmptyStateType.drafts;
      case 3:
        return EmptyStateType.specialOffers;
      case 4:
        return EmptyStateType.rejected;
      case 5:
        return EmptyStateType.archived;
      default:
        return EmptyStateType.all;
    }
  }

  Future<void> _handleProductAction(
    ProductAction action,
    Product product,
  ) async {
    if (action == ProductAction.delete) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: ctx.color.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Delete Listing?',
            style: ctx.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17.sp,
            ),
          ),
          content: Text(
            'This will permanently remove "${product.title}" from your listings.',
            style: ctx.bodySmall?.copyWith(
              color: CostItColors.brightGrey.shade400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancel',
                style: ctx.bodyMedium?.copyWith(
                  color: CostItColors.brightGrey.shade400,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: CostItColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Delete',
                style: ctx.bodyMedium?.copyWith(
                  color: CostItColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        try {
          await ref.read(productServiceProvider).deleteProduct(product.id);
          ref.read(myListingsProvider.notifier).removeLocally(product.id);
        } catch (_) {}
      }
    } else if (action == ProductAction.edit) {
      // Pass the product as route argument — SellFormView will auto-fill
      // the form via initializeWithProduct()
      ref.read(sellFormProvider.notifier).clearAll();
      if (mounted) {
        Navigator.pushNamed(context, PageRoutes.sell.name, arguments: product);
      }
    } else if (action == ProductAction.unpublish) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: ctx.color.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Unpublish Listing?',
            style: ctx.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17.sp,
            ),
          ),
          content: Text(
            '"${product.title}" will be hidden from buyers and moved to your Drafts. You can re-publish it at any time.',
            style: ctx.bodySmall?.copyWith(
              color: CostItColors.brightGrey.shade400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancel',
                style: ctx.bodyMedium?.copyWith(
                  color: CostItColors.brightGrey.shade400,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: context.color.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Move to Drafts',
                style: ctx.bodyMedium?.copyWith(
                  color: CostItColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        try {
          await ref.read(productServiceProvider).editProduct(product.id, {
            'status': 'unavailable',
          });
          ref
              .read(myListingsProvider.notifier)
              .updateStatusLocally(product.id, ListingStatus.unavailable);
        } catch (_) {}
      }
    } else if (action == ProductAction.archive) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: ctx.color.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Archive Listing?',
            style: ctx.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17.sp,
            ),
          ),
          content: Text(
            '"${product.title}" will be moved to your Archived tab. It will no longer be visible to buyers.',
            style: ctx.bodySmall?.copyWith(
              color: CostItColors.brightGrey.shade400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancel',
                style: ctx.bodyMedium?.copyWith(
                  color: CostItColors.brightGrey.shade400,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: context.color.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Archive',
                style: ctx.bodyMedium?.copyWith(
                  color: CostItColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        try {
          await ref.read(productServiceProvider).editProduct(product.id, {
            'status': 'archived',
          });
          ref
              .read(myListingsProvider.notifier)
              .updateStatusLocally(product.id, ListingStatus.archived);
        } catch (_) {}
      }
    }
    // Handle other actions as needed (publish, duplicate, etc.)
  }

  Future<void> _handleBulkDelete() async {
    if (_selectedIds.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.color.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Delete ${_selectedIds.length} Listings?',
          style: ctx.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 17.sp,
          ),
        ),
        content: Text(
          'This will permanently remove the selected listings.',
          style: ctx.bodySmall?.copyWith(
            color: CostItColors.brightGrey.shade400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: ctx.bodyMedium?.copyWith(
                color: CostItColors.brightGrey.shade400,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: CostItColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Delete All',
              style: ctx.bodyMedium?.copyWith(
                color: CostItColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      for (final id in _selectedIds) {
        try {
          await ref.read(productServiceProvider).deleteProduct(id);
          ref.read(myListingsProvider.notifier).removeLocally(id);
        } catch (_) {}
      }
      _clearSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listingsAsync = ref.watch(myListingsProvider);

    return Scaffold(
      backgroundColor: context.color.surface.withValues(
        alpha: 0.95,
      ), // Slight off-white for contrast
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: _searchActive
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: _isSelectionMode
              ? AppBar(
                  backgroundColor: context.color.surface,
                  leading: IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: context.color.onSurface,
                    ),
                    onPressed: _clearSelection,
                  ),
                  title: Text(
                    '${_selectedIds.length} Selected',
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: CostItColors.error,
                      ),
                      onPressed: _handleBulkDelete,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share_outlined,
                        color: context.color.onSurface,
                      ),
                      onPressed: () {
                        // Bulk share
                      },
                    ),
                  ],
                )
              : CostItBackAppBar(
                  title: 'My Listings',
                  leading: ArrowBackButton(
                    color: CostItColors.white,
                    size: 24.sp,
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          PageRoutes.dashBoard.name,
                          (route) => false,
                        );
                      }
                    },
                  ),
                  actions: [
                    Transform.translate(
                      offset: Offset(22.w, 0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _searchActive = true);
                          Future.delayed(const Duration(milliseconds: 100), () {
                            if (mounted) _searchFocusNode.requestFocus();
                          });
                        },
                        child: Icon(
                          Icons.search_rounded,
                          color: CostItColors.white,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    CostItOverflowMenu(
                      currentSort: _currentSort,
                      onSortChanged: (sort) {
                        setState(() {
                          _currentSort = sort;
                        });
                      },
                      onSelectMode: () {
                        setState(() {
                          _isSelectionMode = true;
                        });
                      },
                    ),
                    SizedBox(width: 4.w),
                  ],
                ),
          secondChild: AppBar(
            backgroundColor: context.color.primary,
            titleSpacing: 0,
            leading: ArrowBackButton(
              color: CostItColors.white,
              size: 24.sp,
              onPressed: _clearSearch,
            ),
            leadingWidth: 56.w,
            title: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: SizedBox(
                height: 45.h,
                child: CostItSearchBar(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  hint: 'Search listings...',
                  onChanged: (_) {},
                  mode: SearchMode.instant,
                ),
              ),
            ),
          ),
        ),
      ),
      body: listingsAsync.when(
        loading: () => const MyListingsShimmer(),
        error: (e, _) =>
            _BuildError(onRetry: () => ref.invalidate(myListingsProvider)),
        data: (allListings) {
          final stats = _calculateStats(allListings);

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(child: MyListingsSummaryCards(stats: stats)),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                      indicatorColor: context.color.onPrimary,
                      labelColor: context.color.onPrimary,
                      unselectedLabelColor: CostItColors.brightGrey.shade400,
                      labelStyle: context.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: context.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: _tabs.map((t) => Tab(text: t)).toList(),
                    ),
                    color: context.theme.scaffoldBackgroundColor,
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: List.generate(_tabs.length, (index) {
                final tabProducts = _filterProducts(allListings, index);

                if (tabProducts.isEmpty) {
                  return MyListingsEmptyState(type: _getEmptyStateType(index));
                }

                return CostItRefreshIndicator(
                  type: RefreshType.myListings,
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                    itemCount: tabProducts.length,
                    itemBuilder: (context, i) {
                      final p = tabProducts[i];
                      return SellerProductCard(
                        product: p,
                        isSelected: _selectedIds.contains(p.id),
                        isSelectionMode: _isSelectionMode,
                        onLongPress: () {
                          setState(() {
                            _isSelectionMode = true;
                            _toggleSelection(p.id);
                          });
                        },
                        onTap: () {
                          if (_isSelectionMode) {
                            _toggleSelection(p.id);
                          } else {
                            Navigator.pushNamed(
                              context,
                              PageRoutes.vendorProductDetail.name,
                              arguments: p,
                            );
                          }
                        },
                        onActionSelected: (action) =>
                            _handleProductAction(action, p),
                      );
                    },
                  ),
                );
              }),
            ),
          );
        },
      ),
      floatingActionButton: Transform.scale(
        scale: 0.85,
        child: FloatingActionButton.extended(
          onPressed: () {
            ref.read(sellFormProvider.notifier).clearAll();
            Navigator.pushNamed(context, PageRoutes.sell.name);
          },
          backgroundColor: context.color.primary,
          foregroundColor: CostItColors.white,
          icon: const Icon(Icons.add_rounded),
          label: Text(
            'Add Product',
            style: context.bodyMedium?.copyWith(
              color: CostItColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildError extends StatelessWidget {
  final VoidCallback onRetry;
  const _BuildError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            color: CostItColors.brightGrey.shade400,
            size: 36.sp,
          ),
          Gap(10.h),
          Text(
            'Could not load listings',
            style: context.bodySmall?.copyWith(
              color: CostItColors.brightGrey.shade400,
              fontSize: 13.sp,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: context.bodySmall?.copyWith(
                color: context.color.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color _color;

  _SliverAppBarDelegate(this._tabBar, {required Color color}) : _color = color;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: _color, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
