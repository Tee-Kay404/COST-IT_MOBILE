import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryCard extends StatelessWidget {
  final ProductCategory category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  IconData _getCategoryIcon(String id) {
    switch (id) {
      case 'cat_materials':
        return Icons.category;
      case 'cat_tools':
        return Icons.handyman;
      case 'cat_machinery':
        return Icons.precision_manufacturing;
      case 'cat_electrical':
        return Icons.electrical_services;
      case 'cat_plumbing':
        return Icons.plumbing;
      case 'cat_safety':
        return Icons.health_and_safety;
      case 'cat_finishing':
        return Icons.format_paint;
      case 'cat_logistics':
        return Icons.local_shipping;
      case 'cat_services':
        return Icons.design_services;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90.w,
        margin: EdgeInsets.only(right: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              width: 90.w,
              height: 90.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CostItColors.brightGrey.shade200,
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(category.id),
                  color: context.color.primary,
                  size: 45.sp,
                ),
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              category.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
