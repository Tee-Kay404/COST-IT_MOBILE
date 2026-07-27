import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MyListingsSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSortTap;

  const MyListingsSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onFilterTap,
    this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: context.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: context.bodyMedium?.copyWith(
                  color: CostItColors.brightGrey.shade400,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: CostItColors.brightGrey.shade400,
                  size: 20.sp,
                ),
                filled: true,
                fillColor: context.color.surface,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: CostItColors.brightGrey.shade200,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: CostItColors.brightGrey.shade200,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: context.color.primary,
                  ),
                ),
              ),
            ),
          ),
          Gap(12.w),
          _ActionBtn(
            icon: Icons.tune_rounded,
            onTap: onFilterTap,
          ),
          Gap(8.w),
          _ActionBtn(
            icon: Icons.sort_rounded,
            onTap: onSortTap,
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: CostItColors.brightGrey.shade200,
          ),
        ),
        child: Icon(icon, size: 20.sp, color: context.color.onSurface),
      ),
    );
  }
}
