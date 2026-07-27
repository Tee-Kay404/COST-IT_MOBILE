import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/app/global/styles/colors.dart';

class CategoryPillTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color borderColor;

  const CategoryPillTab({
    super.key,
    required this.label,
    required this.isSelected,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return Container(
        height: 34.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            label,
            style: context.bodySmall?.copyWith(color: CostItColors.white),
          ),
        ),
      );
    }

    return Container(
      height: 34.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Center(child: Text(label, style: context.bodySmall?.copyWith())),
    );
  }
}
