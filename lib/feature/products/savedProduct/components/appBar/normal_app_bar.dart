import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/components/dialog/saved_dialog.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/utils/saved_sort_option.dart';
import 'package:cost_it_mobile/shared/appBar/costit_overflow_menu.dart';
import 'package:cost_it_mobile/widgets/arrow_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SavedSortOption currentSort;
  final ValueChanged<SavedSortOption> onSortChanged;
  final VoidCallback onSelectMode;
  final VoidCallback onClearAll;

  const NormalAppBar({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
    required this.onSelectMode,
    required this.onClearAll,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.color.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: const ArrowBackButton(),
      title: Text(
        'Saved Products',
        style: context.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 18.sp,
          color: Colors.white,
        ),
      ),
      actions: [
        CostItOverflowMenu(
          currentSort: currentSort,
          onSortChanged: onSortChanged,
          onSelectMode: onSelectMode,
          onClearAll: () async {
            final bool? shouldClear = await confirmClearAll(context);
            if (shouldClear == true) {
              onClearAll();
            }
          },
          clearAllLabel: 'Clear All Saved',
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}
