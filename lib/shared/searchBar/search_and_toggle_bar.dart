import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/display_mode.dart';
import 'package:cost_it_mobile/shared/searchBar/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchAndToggleBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String sectionTitle;
  final DisplayMode displayMode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onToggle;

  const SearchAndToggleBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.sectionTitle,
    required this.displayMode,
    required this.onSearchChanged,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.color.surface,
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50.h,
              child: CostItSearchBar(
                controller: controller,
                focusNode: focusNode,
                hint: 'Search $sectionTitle...',
                mode: SearchMode.instant,
                onChanged: onSearchChanged,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: context.color.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  displayMode == DisplayMode.grid
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                  key: ValueKey(displayMode),
                  size: 22.sp,
                  color: CostItColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
