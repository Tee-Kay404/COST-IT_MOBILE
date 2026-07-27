import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool?> confirmClearAll(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: context.color.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: CostItColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_sweep_outlined,
                size: 36.r,
                color: CostItColors.error,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Clear All Saved?',
              textAlign: TextAlign.center,
              style: context.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.color.onPrimary,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'All saved products will be removed from your list. This action cannot be undone.',
              textAlign: TextAlign.center,
              style: context.bodyMedium?.copyWith(
                color: context.color.onSurface.withValues(alpha: 0.6),
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(
                          color: context.color.onSurface.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: context.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.color.onPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: CostItColors.error,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Clear All',
                      style: context.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
