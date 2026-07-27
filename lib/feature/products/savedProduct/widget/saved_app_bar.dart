import 'package:cost_it_mobile/feature/products/savedProduct/components/appBar/normal_app_bar.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/components/appBar/selection_app_bar.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/utils/saved_sort_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSelectionMode;
  final int selectedCount;
  final int totalCount;
  final SavedSortOption currentSort;
  final VoidCallback onEnterSelection;
  final VoidCallback onExitSelection;
  final VoidCallback onSelectAll;
  final VoidCallback onClearAll;
  final VoidCallback onDeleteSelected;
  final VoidCallback onShareSelected;
  final ValueChanged<SavedSortOption> onSortChanged;

  const SavedAppBar({
    super.key,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.totalCount,
    required this.currentSort,
    required this.onEnterSelection,
    required this.onExitSelection,
    required this.onSelectAll,
    required this.onClearAll,
    required this.onDeleteSelected,
    required this.onShareSelected,
    required this.onSortChanged,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    if (isSelectionMode) {
      return SelectionAppBar(
        selectedCount: selectedCount,
        totalCount: totalCount,
        onExitSelection: onExitSelection,
        onSelectAll: onSelectAll,
        onDeleteSelected: onDeleteSelected,
        onShareSelected: onShareSelected,
      );
    }

    return NormalAppBar(
      currentSort: currentSort,
      onSortChanged: onSortChanged,
      onSelectMode: onEnterSelection,
      onClearAll: onClearAll,
    );
  }
}




