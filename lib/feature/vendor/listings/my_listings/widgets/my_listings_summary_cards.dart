import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MyListingsStats {
  final int totalListings;
  final int published;
  final int drafts;
  final int pending;
  final int outOfStock;
  final int totalViews;

  const MyListingsStats({
    this.totalListings = 0,
    this.published = 0,
    this.drafts = 0,
    this.pending = 0,
    this.outOfStock = 0,
    this.totalViews = 0,
  });
}

class MyListingsSummaryCards extends StatelessWidget {
  final MyListingsStats stats;

  const MyListingsSummaryCards({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: _buildCard(
              context,
              title: 'Total',
              value: stats.totalListings.toString(),
              icon: Icons.inventory_2_outlined,
              color: context.color.primary,
            ),
          ),
          Gap(8.w),
          Expanded(
            child: _buildCard(
              context,
              title: 'Published',
              value: stats.published.toString(),
              icon: Icons.check_circle_outline_rounded,
              color: CostItColors.success,
            ),
          ),
          Gap(8.w),
          Expanded(
            child: _buildCard(
              context,
              title: 'Drafts',
              value: stats.drafts.toString(),
              icon: Icons.edit_document,
              color: context.color.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.color.inversePrimary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18.sp),
          ),
          Gap(8.h),
          Text(
            value,
            style: context.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          Gap(4.h),
          Text(
            title,
            style: context.bodySmall?.copyWith(
              color: CostItColors.brightGrey.shade400,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
