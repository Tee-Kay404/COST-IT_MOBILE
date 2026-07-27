import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../category.dart';
import 'package:cost_it_mobile/shared/searchBar/search_and_toggle_bar.dart';
import 'package:cost_it_mobile/feature/products/models/category.dart';

abstract final class CategoryBarHeights {
  static const double searchBar = 70;

  static const double tabBar = 60;

  static const double total = searchBar + tabBar;
}

class CategoryBottomBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final DisplayMode displayMode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onToggle;
  final List<ProductCategory> tabs;

  const CategoryBottomBar({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.displayMode,
    required this.onSearchChanged,
    required this.onToggle,
    required this.tabs,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    CategoryBarHeights.searchBar.h + CategoryBarHeights.tabBar.h,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: CategoryBarHeights.searchBar.h,
          child: SearchAndToggleBar(
            controller: searchController,
            focusNode: searchFocusNode,
            sectionTitle: 'categories',
            displayMode: displayMode,
            onSearchChanged: onSearchChanged,
            onToggle: onToggle,
          ),
        ),
        SizedBox(
          height: CategoryBarHeights.tabBar.h,
          child: CategoryPillTabBar(tabs: tabs),
        ),
      ],
    );
  }
}
