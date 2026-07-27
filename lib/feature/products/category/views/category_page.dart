import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/category.dart';
import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';
import 'package:cost_it_mobile/shared/appBar/costit_back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../category.dart';

class CategoryPage extends ConsumerStatefulWidget {
  final String? initialCategoryId;
  const CategoryPage({super.key, this.initialCategoryId});

  @override
  ConsumerState<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  DisplayMode _displayMode = DisplayMode.grid;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';



  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      loading: () => Scaffold(
        appBar: const CostItBackAppBar(title: 'Category'),
        body: Center(
          child: CircularProgressIndicator(color: context.color.primary),
        ),
      ),

      error: (e, _) => Scaffold(
        appBar: CostItBackAppBar(title: 'Category'),
        body: Center(
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
                'Could not load categories',
                style: context.bodySmall?.copyWith(color: context.color.onSurface.withValues(alpha: 0.5), fontSize: 13.sp),
              ),
              TextButton(
                onPressed: () => ref.invalidate(categoriesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),

      data: (categories) {
        final allCategory = ProductCategory(id: 'all', label: 'All');
        final tabs = [allCategory, ...categories];


        final initialIndex = widget.initialCategoryId != null
            ? tabs.indexWhere((cat) => cat.id == widget.initialCategoryId)
            : 0;

        return DefaultTabController(
          length: tabs.length,
          initialIndex: initialIndex >= 0 ? initialIndex : 0,
          child: Scaffold(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            appBar: CostItBackAppBar(
              title: 'All Categories',
              bottom: CategoryBottomBar(
                searchController: _searchController,
                searchFocusNode: _searchFocusNode,
                displayMode: _displayMode,
                onSearchChanged: (v) =>
                    setState(() => _searchQuery = v.toLowerCase().trim()),
                onToggle: () => setState(() {
                  _displayMode = _displayMode == DisplayMode.grid
                      ? DisplayMode.list
                      : DisplayMode.grid;
                }),
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              children: tabs
                  .map(
                    (cat) => CategoryTabView(
                      key: ValueKey(cat.id),
                      category: cat,
                      searchQuery: _searchQuery,
                      displayMode: _displayMode,
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
