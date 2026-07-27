import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/utils/saved_sort_option.dart';
import 'package:cost_it_mobile/widgets/app_bar_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum OverflowMenuAction {
  sortNewest,
  sortOldest,
  sortNameAZ,
  sortNameZA,
  sortPriceLow,
  sortPriceHigh,
  select,
  clearAll,
}

class CostItOverflowMenu extends StatelessWidget {
  final SavedSortOption currentSort;
  final ValueChanged<SavedSortOption>? onSortChanged;
  final VoidCallback? onSelectMode;
  final VoidCallback? onClearAll;
  final String clearAllLabel;

  const CostItOverflowMenu({
    super.key,
    required this.currentSort,
    this.onSortChanged,
    this.onSelectMode,
    this.onClearAll,
    this.clearAllLabel = 'Clear All',
  });

  @override
  Widget build(BuildContext context) {
    return AppBarPopupMenu<OverflowMenuAction>(
      itemBuilder: (_) {
        final List<Map<String, dynamic>> actionItems = [
          if (onSelectMode != null)
            {
              'value': OverflowMenuAction.select,
              'icon': Icons.check_circle_outline_rounded,
              'label': 'Select Items',
              'isDestructive': false,
            },
          if (onClearAll != null)
            {
              'value': OverflowMenuAction.clearAll,
              'icon': Icons.delete_sweep_outlined,
              'label': clearAllLabel,
              'isDestructive': true,
            },
        ];

        return [
          if (onSortChanged != null) ..._buildSortItems(context),
          if (onSortChanged != null && actionItems.isNotEmpty)
            const PopupMenuDivider(),
          ...actionItems.map(
            (item) => _buildItem(
              context,
              value: item['value'] as OverflowMenuAction,
              icon: item['icon'] as IconData,
              label: item['label'] as String,
              isDestructive: item['isDestructive'] as bool,
            ),
          ),
        ];
      },
      onSelected: (action) => _handleAction(context, action),
    );
  }

  List<PopupMenuEntry<OverflowMenuAction>> _buildSortItems(
      BuildContext context) {
    return [
      PopupMenuItem<OverflowMenuAction>(
        enabled: false,
        height: 32.h,
        child: Text(
          'Sort by',
          style: context.bodySmall?.copyWith(
            color: context.color.inverseSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      ...SavedSortOption.values.map(
        (opt) => PopupMenuItem<OverflowMenuAction>(
          value: OverflowMenuAction.values.firstWhere(
            (a) => a.name.toLowerCase() == 'sort${opt.name}'.toLowerCase(),
            orElse: () => OverflowMenuAction.sortNewest,
          ),
          height: 44.h,
          child: Row(
            children: [
              Icon(
                currentSort == opt
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                size: 18.r,
                color: currentSort == opt
                    ? context.color.onPrimary
                    : context.color.inverseSurface.withValues(alpha: 0.4),
              ),
              SizedBox(width: 10.w),
              Text(
                opt.label,
                style: context.bodyMedium?.copyWith(
                  fontWeight:
                      currentSort == opt ? FontWeight.w600 : FontWeight.w400,
                  color: currentSort == opt
                      ? context.color.onPrimary
                      : context.color.inverseSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  PopupMenuItem<OverflowMenuAction> _buildItem(
    BuildContext context, {
    required OverflowMenuAction value,
    required IconData icon,
    required String label,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? CostItColors.error : context.color.inverseSurface;

    return PopupMenuItem<OverflowMenuAction>(
      value: value,
      height: 44.h,
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: color),
          SizedBox(width: 10.w),
          Text(
            label,
            style: context.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, OverflowMenuAction action) {
    switch (action) {
      case OverflowMenuAction.sortNewest:
        onSortChanged?.call(SavedSortOption.newest);
        break;
      case OverflowMenuAction.sortOldest:
        onSortChanged?.call(SavedSortOption.oldest);
        break;
      case OverflowMenuAction.sortNameAZ:
        onSortChanged?.call(SavedSortOption.nameAZ);
        break;
      case OverflowMenuAction.sortNameZA:
        onSortChanged?.call(SavedSortOption.nameZA);
        break;
      case OverflowMenuAction.sortPriceLow:
        onSortChanged?.call(SavedSortOption.priceLow);
        break;
      case OverflowMenuAction.sortPriceHigh:
        onSortChanged?.call(SavedSortOption.priceHigh);
        break;
      case OverflowMenuAction.select:
        onSelectMode?.call();
        break;
      case OverflowMenuAction.clearAll:
        onClearAll?.call();
        break;
    }
  }
}
