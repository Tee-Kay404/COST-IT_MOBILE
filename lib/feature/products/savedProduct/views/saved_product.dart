import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/app/storage/saved_products.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/utils/saved_product_provider.dart';
import 'package:cost_it_mobile/feature/products/models/display_mode.dart';
import 'package:cost_it_mobile/feature/products/components/product_format/list_card.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/models/saved_products_export.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/widget/saved_browse_button.dart';
import 'package:cost_it_mobile/feature/products/services/product_service.dart';

import 'package:cost_it_mobile/feature/products/components/product_format/app_product_slivers.dart';
import 'package:cost_it_mobile/feature/products/widgets/global_products_card.dart';

import 'package:cost_it_mobile/shared/searchBar/search_and_toggle_bar.dart';
import 'package:cost_it_mobile/feature/products/widgets/product_shimmer.dart';
import 'package:cost_it_mobile/widgets/costit_refresh_indicator.dart';
import 'package:cost_it_mobile/widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedProductPage extends ConsumerStatefulWidget {
  const SavedProductPage({super.key});

  @override
  ConsumerState<SavedProductPage> createState() => _SavedProductPageState();
}

class _SavedProductPageState extends ConsumerState<SavedProductPage> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _enterSelectionMode(String firstId) {
    setState(() {
      _isSelectionMode = true;
      _selectedIds.add(firstId);
    });
  }

  void _enterSelectionModeEmpty() {
    setState(() {
      _isSelectionMode = true;
    });
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

    final count = _selectedIds.length;

    // Capture before clearing
    final toRemove = Set<String>.from(_selectedIds);
    _exitSelectionMode();

    for (final id in toRemove) {
      await ref.read(savedProductsLocalProvider.notifier).toggle(id);
      try {
        await ref.read(productServiceProvider).removeSavedProduct(id);
      } catch (e) {
        ref.read(savedProductsLocalProvider.notifier).toggle(id);
      }
    }

    if (mounted) {
      showSavedToast(
        context,
        '$count product${count == 1 ? '' : 's'} removed',
        icon: Icons.delete_outline_rounded,
      );
    }
  }

  Future<void> _removeSingle(String productId) async {
    await ref.read(savedProductsLocalProvider.notifier).toggle(productId);

    try {
      await ref.read(productServiceProvider).removeSavedProduct(productId);
    } catch (e) {
      ref.read(savedProductsLocalProvider.notifier).toggle(productId);
    }

    if (mounted) {
      showSavedToast(
        context,
        'Removed from saved products',
        icon: Icons.close_outlined,
      );
    }
  }

  Future<void> _clearAll() async {
    final currentIds = ref.read(savedProductsLocalProvider).valueOrNull ?? {};
    await ref.read(savedProductsLocalProvider.notifier).clearAll();

    for (final id in currentIds) {
      try {
        await ref.read(productServiceProvider).removeSavedProduct(id);
      } catch (_) {}
    }

    if (mounted) {
      showSavedToast(
        context,
        'All saved products cleared',
        icon: Icons.delete_sweep_outlined,
      );
    }
  }

  void _shareSelected() {
    // TODO: implement share sheet
    // Share.share('Check out these products on CostIt: ...');
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(filteredSavedProductsProvider);
    final savedAsync = ref.watch(savedProductsLocalProvider);
    final sort = ref.watch(savedSortProvider);
    final displayMode = ref.watch(savedDisplayModeProvider);
    final unfilteredCount = ref.watch(unfilteredSavedProductsProvider).length;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: SavedAppBar(
        isSelectionMode: _isSelectionMode,
        selectedCount: _selectedIds.length,
        totalCount: products.length,
        currentSort: sort,
        onEnterSelection: _enterSelectionModeEmpty,
        onExitSelection: _exitSelectionMode,
        onSelectAll: () => _selectAll(products),
        onClearAll: _clearAll,
        onDeleteSelected: _removeSelected,
        onShareSelected: _shareSelected,
        onSortChanged: (s) => ref.read(savedSortProvider.notifier).state = s,
      ),
      body: savedAsync.when(
        loading: () => SyncedShimmerGrid(
          itemCount: 6,
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        ),
        error: (e, _) => SavedErrorState(
          onRetry: () => ref.invalidate(savedProductsLocalProvider),
        ),
        data: (_) => Column(
          children: [
            SearchAndToggleBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              sectionTitle: 'saved products',
              displayMode: displayMode,
              onSearchChanged: (v) =>
                  ref.read(savedSearchProvider.notifier).state = v,
              onToggle: () {
                final current = ref.read(savedDisplayModeProvider);
                ref
                    .read(savedDisplayModeProvider.notifier)
                    .state = current == DisplayMode.grid
                    ? DisplayMode.list
                    : DisplayMode.grid;
              },
            ),

            if (unfilteredCount > 0)
              SavedCountHeader(
                count: products.length,
                total: unfilteredCount,
                isFiltered: ref.watch(savedSearchProvider).isNotEmpty,
              ),

            Expanded(
              child: products.isEmpty
                  ? SavedEmptyState(
                      isFiltered: unfilteredCount > 0,
                      onBrowse: () => Navigator.pop(context),
                    )
                  : CostItRefreshIndicator(
                      type: RefreshType.savedProducts,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                        displayMode == DisplayMode.grid
                            ? AppProductSliverGrid(
                                itemCount: products.length,
                                padding: EdgeInsets.fromLTRB(
                                  16.w,
                                  12.h,
                                  16.w,
                                  0,
                                ),
                                itemBuilder: (context, i) {
                                  final p = products[i];
                                  final isSelected = _selectedIds.contains(
                                    p.id,
                                  );
                                  return GestureDetector(
                                    onTap: () {
                                      if (_isSelectionMode) {
                                        _toggleSelected(p.id);
                                      } else {
                                        // TODO: navigate to product detail
                                      }
                                    },
                                    onLongPress: () {
                                      if (!_isSelectionMode) {
                                        _enterSelectionMode(p.id);
                                      }
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
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
                                              isSaved: true,
                                              isSelectionMode: _isSelectionMode,
                                              onSave: () => _removeSingle(p.id),
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
                                itemCount: products.length,
                                padding: EdgeInsets.fromLTRB(
                                  16.w,
                                  12.h,
                                  16.w,
                                  0,
                                ),
                                itemBuilder: (context, i) {
                                  final p = products[i];
                                  final isSelected = _selectedIds.contains(
                                    p.id,
                                  );
                                  return GestureDetector(
                                    onTap: () {
                                      if (_isSelectionMode) {
                                        _toggleSelected(p.id);
                                      }
                                    },
                                    onLongPress: () {
                                      if (!_isSelectionMode) {
                                        _enterSelectionMode(p.id);
                                      }
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
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
                                              isSaved: true,
                                              isSelectionMode: _isSelectionMode,
                                              onSave: () => _removeSingle(p.id),
                                            ),
                                          ),
                                          if (_isSelectionMode)
                                            Positioned(
                                              top: 12.h,
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
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 80.h),
                            child: BrowseProductButton(
                              onBrowse: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ],
        ),
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
