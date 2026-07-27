import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../category.dart';

class CategoryPillTabBar extends StatelessWidget {
  final List<ProductCategory> tabs;

  const CategoryPillTabBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final textColor =
        context.theme.textTheme.bodySmall?.color ?? Colors.black87;

    return Container(
      color: context.color.surface,
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        indicator: const BoxDecoration(),
        dividerHeight: 0,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: textColor,
        labelStyle: context.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
        ),
        unselectedLabelStyle: context.bodySmall?.copyWith(
          fontWeight: FontWeight.w400,
          color: CostItColors.brightGrey.shade800,
          fontSize: 13.sp,
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
        tabs: List.generate(tabs.length, (i) {
          return SelectionAwarePillTab(
            index: i,
            label: tabs[i].label,
            borderColor: textColor.withValues(alpha: 0.35),
          );
        }),
      ),
    );
  }
}
