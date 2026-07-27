import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/components/product_format/list_card.dart';
import 'package:cost_it_mobile/feature/products/components/seeAll/enums.dart';
import 'package:cost_it_mobile/feature/products/components/seeAll/provider/see_all_provider.dart';
import 'package:cost_it_mobile/feature/products/widgets/global_products_card.dart';
import 'package:cost_it_mobile/feature/products/widgets/product_shimmer.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/widget/saved_browse_button.dart';
import 'package:cost_it_mobile/shared/appBar/costit_back_app_bar.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/components/appBar/selection_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cost_it_mobile/app/storage/recently_viewed_products.dart';
import 'package:cost_it_mobile/widgets/costit_refresh_indicator.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/components/dialog/saved_dialog.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/utils/saved_sort_option.dart';
import 'package:cost_it_mobile/shared/appBar/costit_overflow_menu.dart';
import 'package:cost_it_mobile/shared/searchBar/search_and_toggle_bar.dart';
import 'package:cost_it_mobile/feature/products/components/product_format/app_product_slivers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import '../../models/display_mode.dart';

class SeeAllPage extends ConsumerStatefulWidget {
  final SeeAllSection section;
  const SeeAllPage({super.key, required this.section});

  @override
  ConsumerState<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends ConsumerState<SeeAllPage> {
  DisplayMode _displayMode = DisplayMode.grid;
  SavedSortOption _currentSort = SavedSortOption.newest;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(seeAllProvider(widget.section).notifier).fetchNextPage();
    }
  }

  void _enterSelectionMode(String id) {
    if (widget.section == SeeAllSection.recentlyViewed) {
      setState(() {
        _isSelectionMode = true;
        _selectedIds.add(id);
      });
    }
  }

  void _enterSelectionModeEmpty() {
    if (widget.section == SeeAllSection.recentlyViewed) {
      setState(() {
        _isSelectionMode = true;
      });
    }
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedIds.clear();
    });
  }

  void _toggleSelected(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _selectAll(List<Product> products) {
    setState(() {
      if (_selectedIds.length == products.length) {
        _selectedIds.clear();
      } else {
        _selectedIds.addAll(products.map((p) => p.id));
      }
    });
  }

  Future<void> _removeSelected() async {
    if (_selectedIds.isEmpty) return;

    if (widget.section == SeeAllSection.recentlyViewed) {
      await ref.read(recentlyViewedProvider.notifier).removeProducts(_selectedIds);
      if (mounted) {
        _exitSelectionMode();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final seeAllAsync = ref.watch(seeAllProvider(widget.section));
    final items = seeAllAsync.valueOrNull?.items ?? [];

    var filtered = _searchQuery.isEmpty
        ? List<Product>.from(items)
        : items
              .where(
                (p) =>
                    p.title.toLowerCase().contains(_searchQuery) ||
                    p.categoryLabel.toLowerCase().contains(
                      _searchQuery,
                    ) ||
                    p.vendor.name.toLowerCase().contains(_searchQuery),
              )
              .toList();

    if (widget.section == SeeAllSection.recentlyViewed) {
      switch (_currentSort) {
        case SavedSortOption.newest:
          filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case SavedSortOption.oldest:
          filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case SavedSortOption.nameAZ:
          filtered.sort((a, b) => a.title.compareTo(b.title));
          break;
        case SavedSortOption.nameZA:
          filtered.sort((a, b) => b.title.compareTo(a.title));
          break;
        case SavedSortOption.priceLow:
          filtered.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SavedSortOption.priceHigh:
          filtered.sort((a, b) => b.price.compareTo(a.price));
          break;
      }
    }

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _isSelectionMode
          ? SelectionAppBar(
              selectedCount: _selectedIds.length,
              totalCount: filtered.length,
              onExitSelection: _exitSelectionMode,
              onSelectAll: () => _selectAll(filtered),
              onDeleteSelected: _removeSelected,
              onShareSelected: () {}, // No-op, sharing bulk recent items is not defined yet
            ) as PreferredSizeWidget
          : CostItBackAppBar(
              title: widget.section.title,
              actions: widget.section == SeeAllSection.recentlyViewed
                  ? [
                      CostItOverflowMenu(
                        currentSort: _currentSort,
                        onSortChanged: (sort) => setState(() => _currentSort = sort),
                        onSelectMode: _enterSelectionModeEmpty,
                        onClearAll: () async {
                          final bool? shouldClear = await confirmClearAll(context);
                          if (shouldClear == true) {
                            ref.read(recentlyViewedProvider.notifier).clearAll();
                          }
                        },
                        clearAllLabel: 'Clear All Viewed',
                      ),
                      SizedBox(width: 8.w),
                    ]
                  : null,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(68.h),
                child: SearchAndToggleBar(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  sectionTitle: widget.section.title,
                  displayMode: _displayMode,
                  onSearchChanged: (v) =>
                      setState(() => _searchQuery = v.toLowerCase().trim()),
                  onToggle: () => setState(() {
                    _displayMode = _displayMode == DisplayMode.grid
                        ? DisplayMode.list
                        : DisplayMode.grid;
                  }),
                ),
              ),
            ),
      body: seeAllAsync.when(
        loading: () => SyncedShimmerGrid(
          padding: EdgeInsets.fromLTRB(15.w, 16.h, 15.w, 0),
        ),
        error: (e, _) => _buildError(e),
        data: (state) {
          if (filtered.isEmpty && _searchQuery.isNotEmpty) {
            return _buildEmptySearch();
          }

          if (filtered.isEmpty) {
            return _buildEmptySection();
          }

          return CostItRefreshIndicator(
            type: RefreshType.seeAll,
            seeAllSection: widget.section,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
            slivers: [
              if (widget.section == SeeAllSection.recentlyViewed)
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15.w, 16.h, 15.w, 0),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.color.onPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: context.color.onPrimary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18.sp,
                          color: context.color.onPrimary,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Products are automatically removed 30 days after you view them.',
                            style: context.bodySmall?.copyWith(
                              color: context.color.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              _displayMode == DisplayMode.grid
                  ? AppProductSliverGrid(
                      itemCount: filtered.length,
                      padding: EdgeInsets.fromLTRB(15.w, 16.h, 15.w, 0),
                      itemBuilder: (context, i) {
                        final p = filtered[i];
                        final isSelected = _selectedIds.contains(p.id);
                        return GestureDetector(
                          onTap: _isSelectionMode ? () => _toggleSelected(p.id) : null,
                          onLongPress: _isSelectionMode ? null : () => _enterSelectionMode(p.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isSelected
                                    ? context.color.onPrimary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                IgnorePointer(
                                  ignoring: _isSelectionMode,
                                  child: ProductCard(
                                    product: p,
                                    isSelectionMode: _isSelectionMode,
                                  ),
                                ),
                                if (_isSelectionMode)
                                  Positioned(
                                    bottom: 12.h,
                                    right: 12.w,
                                    child: _SelectionRadioButton(
                                      isSelected: isSelected,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : AppProductSliverList(
                      itemCount: filtered.length,
                      padding: EdgeInsets.fromLTRB(15.w, 16.h, 15.w, 0),
                      itemBuilder: (context, i) {
                        final p = filtered[i];
                        final isSelected = _selectedIds.contains(p.id);
                        return GestureDetector(
                          onTap: _isSelectionMode ? () => _toggleSelected(p.id) : null,
                          onLongPress: _isSelectionMode ? null : () => _enterSelectionMode(p.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isSelected
                                    ? context.color.onPrimary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                IgnorePointer(
                                  ignoring: _isSelectionMode,
                                  child: ProductListCard(
                                    product: p,
                                    isSelectionMode: _isSelectionMode,
                                  ),
                                ),
                                if (_isSelectionMode)
                                  Positioned(
                                    bottom: 12.h,
                                    right: 12.w,
                                    child: _SelectionRadioButton(
                                      isSelected: isSelected,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
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
                  child: BrowseProductButton(
                    onBrowse: () => Navigator.pop(context),
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 80.h)),
            ],
          ),
          );
        },
      ),
    );
  }

  Widget _buildError(Object e) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            color: Colors.grey.shade400,
            size: 36.sp,
          ),
          SizedBox(height: 10.h),
          Text(
            'Could not load products',
            style: context.bodySmall?.copyWith(
              color: context.color.onSurface.withValues(alpha: 0.5),
              fontSize: 13.sp,
            ),
          ),
          TextButton(
            onPressed: () => ref.invalidate(seeAllProvider(widget.section)),
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
          Icon(
            Icons.search_off_rounded,
            color: Colors.grey.shade400,
            size: 36.sp,
          ),
          SizedBox(height: 10.h),
          Text(
            'No results for "$_searchQuery"',
            style: context.bodySmall?.copyWith(
              color: context.color.onSurface.withValues(alpha: 0.5),
              fontSize: 13.sp,
            ),
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
            style: context.bodySmall?.copyWith(
              color: context.color.onSurface.withValues(alpha: 0.5),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionRadioButton extends StatelessWidget {
  final bool isSelected;

  const _SelectionRadioButton({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
        color: context.color.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? context.color.onPrimary
              : context.color.onSurface.withValues(alpha: 0.3),
          width: isSelected ? 6.r : 1.5,
        ),
      ),
    );
  }
}

