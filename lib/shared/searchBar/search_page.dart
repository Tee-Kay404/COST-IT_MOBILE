import 'dart:async';
import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/location/utils/providers.dart';
import 'package:cost_it_mobile/feature/products/components/product_format/list_card.dart';
import 'package:cost_it_mobile/feature/products/components/product_format/app_product_slivers.dart';
import 'package:cost_it_mobile/feature/products/models/category.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/widgets/global_products_card.dart';
import 'package:cost_it_mobile/feature/products/widgets/product_shimmer.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/arrow_back_button.dart';
import 'package:cost_it_mobile/shared/searchBar/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';

enum _SearchState { idle, loading, results, empty, error }

enum _SortOption { relevance, priceLow, priceHigh, newest }

enum _DisplayMode { grid, list }

// ignore: unused_element
class _ActiveFilter {
  final String label;
  final String key;
  const _ActiveFilter({required this.label, required this.key});
}

class SearchPage extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchPage({super.key, this.initialQuery});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  _SearchState _searchState = _SearchState.idle;
  _DisplayMode _displayMode = _DisplayMode.grid;
  _SortOption _sortOption = _SortOption.relevance;
  String _currentQuery = '';
  Map<String, dynamic> _searchParams = {'query': ''};

  // Active filter state
  String? _selectedCategoryId;
  String? _selectedCategoryLabel;
  double? _minPrice;
  double? _maxPrice;

  final List<String> _recentSearches = [
    'Dangote cement 50kg',
    'Iron rod 16mm',
    'Binding wire',
    'Plywood sheet',
    'PVC pipe',
  ];

  final List<String> _trendingSearches = [
    'Block moulding machine',
    'Granite chippings',
    'BRC mesh',
    'Roofing sheet',
    'Tower bolt',
    'Electrical conduit',
  ];


  final List<_CategorySuggestion> _categorySuggestions = [
    _CategorySuggestion(
      icon: Icons.layers_outlined,
      label: 'Materials',
      count: 142,
    ),
    _CategorySuggestion(
      icon: Icons.handyman_outlined,
      label: 'Tools',
      count: 87,
    ),
    _CategorySuggestion(
      icon: Icons.electrical_services_outlined,
      label: 'Electrical',
      count: 56,
    ),
    _CategorySuggestion(
      icon: Icons.plumbing_outlined,
      label: 'Plumbing',
      count: 34,
    ),
  ];

  Timer? _debounce;
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      _currentQuery = widget.initialQuery!;
      _triggerSearch(widget.initialQuery!);
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => FocusScope.of(context).requestFocus(_focusNode),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    if (value.trim().isEmpty) {
      setState(() => _searchState = _SearchState.idle);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 450), () {
      _triggerSearch(value.trim());
    });
  }

  void _triggerSearch(String query) {
    if (!mounted) return;
    setState(() {
      _currentQuery = query;
      _searchParams = {
        'query': query,
        if (_selectedCategoryId != null) 'category_id': _selectedCategoryId,
        if (_minPrice != null) 'min_price': _minPrice,
        if (_maxPrice != null) 'max_price': _maxPrice,
      };
      _searchState = _SearchState.results;
    });
  }

  void _applyFilters() {
    if (_currentQuery.isNotEmpty) _triggerSearch(_currentQuery);
  }

  void _onSubmitted(String query) {
    if (query.trim().isEmpty) return;
    _saveRecentSearch(query.trim());
    _triggerSearch(query.trim());
    _focusNode.unfocus();
  }

  void _saveRecentSearch(String query) {
    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 8) _recentSearches.removeLast();
    });
  }

  void _removeRecentSearch(String query) =>
      setState(() => _recentSearches.remove(query));

  void _clearRecentSearches() => setState(() => _recentSearches.clear());

  void _onSuggestionTap(String query) {
    _searchController.text = query;
    _onSubmitted(query);
  }

  // void _removeFilter(String key) =>
  //     setState(() => _activeFilters.removeWhere((f) => f.key == key));

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: context.color.primary,
      ),
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: _buildSearchAppBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildBody(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildSearchAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.color.primary,
      elevation: 0,
      leading: ArrowBackButton(color: CostItColors.white, size: 24.sp),
      leadingWidth: 56.w,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.only(right: 16.w),
        child: SizedBox(
          height: 45.h,
          child: CostItSearchBar(
            controller: _searchController,
            focusNode: _focusNode,
            hint: 'Search products, vendors...',
            mode: SearchMode.debounced,
            debounceDuration: const Duration(milliseconds: 450),
            isLoading: _searchState == _SearchState.loading,
            autofocus: true,
            onChanged: _onSearchChanged,
            onSubmitted: _onSubmitted,
            onCleared: () => setState(() {
              _currentQuery = '';
              _searchState = _SearchState.idle;
            }),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            focusBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_searchState) {
      case _SearchState.idle:
        return _buildIdleState(context);
      case _SearchState.loading:
        return _buildLoadingState(context);
      case _SearchState.results:
        return _buildResultsState(context);
      case _SearchState.empty:
        return _buildEmptyState(context);
      case _SearchState.error:
        return _buildErrorState(context);
    }
  }

  Widget _buildIdleState(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('idle'),
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            _SectionHeader(
              title: 'Recent Searches',
              action: 'Clear all',
              onAction: _clearRecentSearches,
            ),
            ..._recentSearches.map(
              (q) => _RecentSearchTile(
                query: q,
                onTap: () => _onSuggestionTap(q),
                onRemove: () => _removeRecentSearch(q),
              ),
            ),
            SizedBox(height: 8.h),
          ],

          _SectionHeader(title: 'Trending on CostIt'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _trendingSearches
                  .map(
                    (q) => GestureDetector(
                      onTap: () => _onSuggestionTap(q),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.color.surface,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: CostItColors.brightGrey.shade200,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              size: 14.sp,
                              color: context.color.primary,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              q,
                              style: context.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          SizedBox(height: 20.h),

          _SectionHeader(title: 'Browse by Category'),
          SizedBox(
            height: 100.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _categorySuggestions.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (_, i) =>
                  _CategoryCard(suggestion: _categorySuggestions[i]),
            ),
          ),

          SizedBox(height: 80.h),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('loading'),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterShimmer(context),
          SizedBox(height: 12.h),
          SyncedShimmerGrid(itemCount: 6, padding: EdgeInsets.zero),
        ],
      ),
    );
  }

  Widget _buildFilterShimmer(BuildContext context) {
    return SizedBox(
      height: 34.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, __) => Container(
          width: 80.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsState(BuildContext context) {
    final searchAsync = ref.watch(searchProductsProvider(_searchParams));

    return searchAsync.when(
      loading: () => _buildLoadingState(context),
      error: (e, _) => _buildErrorState(context),
      data: (products) {
        if (products.isEmpty) return _buildEmptyState(context);

        return Column(
          key: const ValueKey('results'),
          children: [
            if (_categorySuggestions.isNotEmpty)
              _buildCategorySuggestionRow(context),

            _buildFilterRow(context),

            _buildResultsHeader(context, products.length),

            _buildExpandLocationBanner(context),

            Expanded(child: _buildProductList(context, products)),
          ],
        );
      },
    );
  }

  Widget _buildCategorySuggestionRow(BuildContext context) {
    return Container(
      color: context.color.surface,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: SizedBox(
        height: 88.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: _categorySuggestions.length,
          separatorBuilder: (_, __) => SizedBox(width: 10.w),
          itemBuilder: (_, i) =>
              _CategoryCard(suggestion: _categorySuggestions[i]),
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    final selectedLocation = ref.watch(selectedLocationProvider);

    // Build chips dynamically based on active state
    final chips = <_FilterChipData>[
      // Location chip — shows selected location or default "Location"
      _FilterChipData(
        label: selectedLocation ?? 'Location',
        key: 'location',
        isActive: selectedLocation != null,
        onTap: () async {
          await Navigator.pushNamed(context, PageRoutes.location.name);
          // selectedLocationProvider is updated by the location page itself
          _applyFilters();
        },
        onRemove: selectedLocation != null
            ? () {
                ref.read(selectedLocationProvider.notifier).state = null;
                ref.read(selectedStateProvider.notifier).state = null;
                ref.read(selectedLgaProvider.notifier).state = null;
                _applyFilters();
              }
            : null,
      ),

      // Category chip
      _FilterChipData(
        label: _selectedCategoryLabel ?? 'Category',
        key: 'category',
        isActive: _selectedCategoryId != null,
        onTap: () => _showCategorySheet(context),
        onRemove: _selectedCategoryId != null
            ? () => setState(() {
                  _selectedCategoryId = null;
                  _selectedCategoryLabel = null;
                  _applyFilters();
                })
            : null,
      ),

      // Price chip
      _FilterChipData(
        label: (_minPrice != null || _maxPrice != null)
            ? '₦${_minPrice != null ? '${(_minPrice! / 1000).toStringAsFixed(0)}K' : '0'} – ${_maxPrice != null ? '${(_maxPrice! / 1000).toStringAsFixed(0)}K' : '∞'}'
            : 'Price ₦',
        key: 'price',
        isActive: _minPrice != null || _maxPrice != null,
        onTap: () => _showPriceFilterPage(context),
        onRemove: (_minPrice != null || _maxPrice != null)
            ? () => setState(() {
                  _minPrice = null;
                  _maxPrice = null;
                  _applyFilters();
                })
            : null,
      ),

      // Verified sellers
      _FilterChipData(
        label: 'Verified sellers',
        key: 'verified',
        isActive: false,
        onTap: () => _showVerifiedModal(context),
      ),
    ];

    return Container(
      color: context.color.surface,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: chips.map((c) => _FilterChipWidget(data: c)).toList(),
      ),
    );
  }

  Widget _buildResultsHeader(BuildContext context, int resultCount) {
    return Container(
      color: context.color.surface,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 12.w, 8.h),
      child: Row(
        children: [
          Text(
            'Found $resultCount ads',
            style: context.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showSortSheet(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                border: Border.all(color: CostItColors.brightGrey.shade300),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sort_rounded,
                    size: 14.sp,
                    color: Colors.grey.shade700,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Sort',
                    style: context.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 14.sp,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => setState(() {
              _displayMode = _displayMode == _DisplayMode.grid
                  ? _DisplayMode.list
                  : _DisplayMode.grid;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 34.w,
              height: 34.h,
              decoration: BoxDecoration(
                color: context.color.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _displayMode == _DisplayMode.grid
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                  key: ValueKey(_displayMode),
                  size: 20.sp,
                  color: CostItColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandLocationBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFFFB74D), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_searching_rounded,
            size: 16.sp,
            color: const Color(0xFFFF6F00),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'That may be all for Lagos. Would you like to see results across Nigeria?',
              style: context.bodySmall?.copyWith(
                color: const Color(0xFFE65100),
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Expand',
              style: context.bodySmall?.copyWith(
                color: const Color(0xFFFF6F00),
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context, List<Product> products) {
    return CustomScrollView(
      slivers: [
        if (_displayMode == _DisplayMode.grid)
          AppProductSliverGrid(
            itemCount: products.length,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            itemBuilder: (_, i) => ProductCard(product: products[i]),
          )
        else
          AppProductSliverList(
            itemCount: products.length,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 80.h),
            itemBuilder: (_, i) => ProductListCard(product: products[i]),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      key: const ValueKey('empty'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              'No results for "$_currentQuery"',
              style: context.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Try different keywords or remove some filters.',
              style: context.bodySmall?.copyWith(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            OutlinedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _currentQuery = '';
                  _searchState = _SearchState.idle;
                });
              },
              child: const Text('Clear search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      key: const ValueKey('error'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 40.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 12.h),
          Text(
            'Could not load results',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13.sp),
          ),
          TextButton(
            onPressed: () => _triggerSearch(_currentQuery),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    final options = {
      _SortOption.relevance: 'Most relevant',
      _SortOption.newest: 'Newest first',
      _SortOption.priceLow: 'Price: Low to High',
      _SortOption.priceHigh: 'Price: High to Low',
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Sort by',
              style: context.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12.h),
            ...options.entries.map(
              (e) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  e.value,
                  style: context.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: _sortOption == e.key
                    ? Icon(
                        Icons.check_rounded,
                        color: context.color.primary,
                        size: 20.sp,
                      )
                    : null,
                onTap: () {
                  setState(() => _sortOption = e.key);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Category bottom sheet ─────────────────────────────────────────────────
  void _showCategorySheet(BuildContext context) {
    final categoriesAsync = ref.read(categoriesProvider);
    final categories = categoriesAsync.valueOrNull ?? <ProductCategory>[];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollCtrl) => Container(
          decoration: BoxDecoration(
            color: context.color.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
                child: Row(
                  children: [
                    Text(
                      'Select Category',
                      style: context.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    if (_selectedCategoryId != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategoryId = null;
                            _selectedCategoryLabel = null;
                          });
                          Navigator.pop(context);
                          _applyFilters();
                        },
                        child: Text('Clear', style: TextStyle(color: context.color.primary)),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: scrollCtrl,
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: categories.isEmpty ? 1 : categories.length,
                  itemBuilder: (_, i) {
                    if (categories.isEmpty) {
                      return Center(
                        child: Text(
                          'Loading categories...',
                          style: context.bodySmall,
                        ),
                      );
                    }
                    final cat = categories[i];
                    final isSelected = _selectedCategoryId == cat.id;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryId = cat.id;
                          _selectedCategoryLabel = cat.label;
                        });
                        Navigator.pop(context);
                        _applyFilters();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.color.primary.withValues(alpha: 0.08)
                              : context.color.surface,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isSelected
                                ? context.color.primary
                                : CostItColors.brightGrey.shade200,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              cat.image,
                              width: 36.r,
                              height: 36.r,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.category_outlined,
                                size: 28.sp,
                                color: context.color.primary,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              cat.label,
                              style: context.bodySmall?.copyWith(
                                fontSize: 11.sp,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? context.color.primary : null,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Price filter full-screen page ─────────────────────────────────────────
  void _showPriceFilterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _PriceFilterPage(
          initialMin: _minPrice,
          initialMax: _maxPrice,
          onApply: (min, max) {
            setState(() {
              _minPrice = min;
              _maxPrice = max;
            });
            _applyFilters();
          },
          onClear: () {
            setState(() {
              _minPrice = null;
              _maxPrice = null;
            });
            _applyFilters();
          },
        ),
      ),
    );
  }

  // ── Verified sellers modal ────────────────────────────────────────────────
  void _showVerifiedModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.color.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.verified_outlined,
              size: 48.sp,
              color: context.color.primary,
            ),
            SizedBox(height: 16.h),
            Text(
              'No Verified Sellers Yet',
              style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Vendor verification is coming soon! You\'ll be able to filter results to only show listings from sellers we have verified.',
              style: context.bodySmall?.copyWith(
                color: CostItColors.brightGrey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: TextStyle(color: context.color.primary, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
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

class _RecentSearchTile extends StatelessWidget {
  final String query;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _RecentSearchTile({
    required this.query,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(
              Icons.history_rounded,
              size: 18.sp,
              color: Colors.grey.shade400,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                query,
                style: context.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close_rounded,
                size: 16.sp,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySuggestion {
  final IconData icon;
  final String label;
  final int count;
  const _CategorySuggestion({
    required this.icon,
    required this.label,
    required this.count,
  });
}

class _CategoryCard extends StatelessWidget {
  final _CategorySuggestion suggestion;
  const _CategoryCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 80.w,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: CostItColors.brightGrey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(suggestion.icon, size: 24.sp, color: context.color.primary),
            SizedBox(height: 6.h),
            Text(
              suggestion.label,
              style: context.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              '${suggestion.count} ads',
              style: context.bodySmall?.copyWith(
                color: Colors.grey.shade400,
                fontSize: 9.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChipData {
  final String label;
  final String key;
  final bool isActive;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const _FilterChipData({
    required this.label,
    required this.key,
    this.isActive = false,
    this.onTap,
    this.onRemove,
  });
}

class _FilterChipWidget extends StatelessWidget {
  final _FilterChipData data;
  const _FilterChipWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: data.isActive
              ? context.color.primary.withValues(alpha: 0.1)
              : context.color.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: data.isActive
                ? context.color.primary
                : CostItColors.brightGrey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (data.isActive)
              Icon(
                Icons.check_rounded,
                size: 12.sp,
                color: context.color.primary,
              ),
            if (data.isActive) SizedBox(width: 4.w),
            Text(
              data.label,
              style: context.bodySmall?.copyWith(
                color: data.isActive
                    ? context.color.primary
                    : Colors.grey.shade700,
                fontWeight: data.isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
            if (!data.isActive) ...[
              SizedBox(width: 4.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 14.sp,
                color: Colors.grey.shade600,
              ),
            ],
            if (data.isActive && data.onRemove != null) ...[
              SizedBox(width: 4.w),
              GestureDetector(
                onTap: data.onRemove,
                child: Icon(
                  Icons.close_rounded,
                  size: 12.sp,
                  color: context.color.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  PRICE FILTER PAGE
// ═══════════════════════════════════════════════════════════════════════════
class _PriceFilterPage extends StatefulWidget {
  final double? initialMin;
  final double? initialMax;
  final void Function(double? min, double? max) onApply;
  final VoidCallback onClear;

  const _PriceFilterPage({
    required this.onApply,
    required this.onClear,
    this.initialMin,
    this.initialMax,
  });

  @override
  State<_PriceFilterPage> createState() => _PriceFilterPageState();
}

class _PriceFilterPageState extends State<_PriceFilterPage> {
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();

  // Preset price ranges: [label, min, max] — max null means no upper bound
  final List<(String, double, double?)> _presets = [
    ('Under ₦100K', 0, 100000),
    ('₦100K – ₦250K', 100000, 250000),
    ('₦250K – ₦500K', 250000, 500000),
    ('₦500K – ₦1M', 500000, 1000000),
    ('More than ₦1M', 1000000, null),
  ];

  int? _selectedPreset;

  @override
  void initState() {
    super.initState();
    if (widget.initialMin != null) {
      _fromCtrl.text = widget.initialMin!.toStringAsFixed(0);
    }
    if (widget.initialMax != null) {
      _toCtrl.text = widget.initialMax!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  void _applyPreset(int index) {
    final (_, min, max) = _presets[index];
    setState(() {
      _selectedPreset = index;
      _fromCtrl.text = min.toStringAsFixed(0);
      _toCtrl.text = max != null ? max.toStringAsFixed(0) : '';
    });
  }

  void _apply() {
    final min = double.tryParse(_fromCtrl.text.replaceAll(',', ''));
    final max = double.tryParse(_toCtrl.text.replaceAll(',', ''));
    widget.onApply(min, max);
    Navigator.pop(context);
  }

  void _clear() {
    widget.onClear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.color.primary,
        leading: ArrowBackButton(color: Colors.white, size: 24.sp),
        leadingWidth: 56.w,
        title: Text(
          'Price Range',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // ── From / To fields ───────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _fromCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Min (₦)',
                            filled: true,
                            fillColor: context.color.surface,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 14.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(color: CostItColors.brightGrey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(color: CostItColors.brightGrey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(color: context.color.primary, width: 1.5),
                            ),
                          ),
                          onChanged: (_) => setState(() => _selectedPreset = null),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text('–', style: TextStyle(fontSize: 18.sp, color: Colors.grey)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _toCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Max (₦)',
                            filled: true,
                            fillColor: context.color.surface,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 14.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(color: CostItColors.brightGrey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(color: CostItColors.brightGrey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(color: context.color.primary, width: 1.5),
                            ),
                          ),
                          onChanged: (_) => setState(() => _selectedPreset = null),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(height: 24.h, color: CostItColors.brightGrey.shade200),

                // ── Preset ranges ──────────────────────────────
                ...List.generate(_presets.length, (i) {
                  final (label, _, __) = _presets[i];
                  final isSelected = _selectedPreset == i;
                  return InkWell(
                    onTap: () => _applyPreset(i),
                    child: Container(
                      color: isSelected
                          ? context.color.primary.withValues(alpha: 0.06)
                          : Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: context.bodySmall?.copyWith(
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? context.color.primary : null,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: isSelected
                                ? context.color.primary
                                : CostItColors.brightGrey.shade400,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // ── Bottom action buttons ─────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            decoration: BoxDecoration(
              color: context.color.surface,
              border: Border(top: BorderSide(color: CostItColors.brightGrey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: _clear,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(color: CostItColors.brightGrey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Clear',
                      style: context.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 5,
                  child: FilledButton(
                    onPressed: _apply,
                    style: FilledButton.styleFrom(
                      backgroundColor: context.color.primary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Apply Filter',
                      style: context.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// final _dummyProduct = Product(
//   id: 'dummy',
//   title: 'Dangote Cement 50kg',
//   categoryId: 'cat_materials',
//   categoryLabel: 'Materials',
//   price: 7500,
//   unit: 'bag',
//   status: ListingStatus.available,
//   vendor: ProductVendor(
//     id: 'v1',
//     name: 'Alhaji Stores',
//     isVerified: true,
//     location: 'Lagos',
//     rating: 4,
//   ),
//   pricingType: PricingType.open,
//   images: [],
//   createdAt: DateTime.now(),
//   updatedAt: DateTime.now(),
// );
