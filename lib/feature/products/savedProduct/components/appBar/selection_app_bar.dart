import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedCount;
  final int totalCount;
  final VoidCallback onExitSelection;
  final VoidCallback onSelectAll;
  final VoidCallback onDeleteSelected;
  final VoidCallback onShareSelected;
  final PreferredSizeWidget? bottom;

  const SelectionAppBar({
    super.key, 
    required this.selectedCount,
    required this.totalCount,
    required this.onExitSelection,
    required this.onSelectAll,
    required this.onDeleteSelected,
    required this.onShareSelected,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final allSelected = selectedCount == totalCount;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? Colors.white : context.color.primary;

    return AppBar(
      backgroundColor: context.color.primary.withValues(alpha: 0.06),
      elevation: 0,
      bottom: bottom,
      leading: IconButton(
        icon: Icon(Icons.close_rounded, size: 22.r, color: activeColor),
        onPressed: onExitSelection,
      ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: Text(
          selectedCount == 0 ? 'Select Items' : '$selectedCount selected',
          key: ValueKey(selectedCount),
          style: context.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: activeColor,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: onSelectAll,
          child: Text(
            allSelected ? 'Deselect All' : 'Select All',
            style: context.bodyMedium?.copyWith(
              color: activeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (selectedCount > 0) ...[
          IconButton(
            icon: Icon(
              Icons.share_rounded,
              size: 20.r,
              color: context.color.onSurface,
            ),
            onPressed: onShareSelected,
            tooltip: 'Share',
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 22.r,
              color: const Color(0xFFE53935),
            ),
            onPressed: onDeleteSelected,
            tooltip: 'Remove selected',
          ),
        ],
        SizedBox(width: 4.w),
      ],
    );
  }
}

