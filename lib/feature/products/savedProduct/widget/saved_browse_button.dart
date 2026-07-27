import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrowseProductButton extends StatelessWidget {
  final VoidCallback onBrowse;

  const BrowseProductButton({super.key, required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You've seen it all",
              style: context.bodyMedium?.copyWith(
                color: context.color.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            FilledButton.icon(
              onPressed: onBrowse,
              icon: Icon(Icons.storefront_outlined, size: 15.r),
              label: Text(
                'Browse Products',
                style: context.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: CostItColors.white,
                ),
              ),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
