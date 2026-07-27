import 'dart:ui';

import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Frosted bottom bar with Edit/Continue-Editing, Publish/Unpublish,
/// and a More button. Edit always uses primary; Publish uses
/// success-green, Unpublish uses neutral grey.
class BottomActionBar extends StatelessWidget {
  final Product product;
  final bool isDraft;
  final Animation<double> fabAnim;
  final VoidCallback onEdit;
  final VoidCallback onMore;
  final VoidCallback onPublishToggle;

  const BottomActionBar({
    super.key,
    required this.product,
    required this.isDraft,
    required this.fabAnim,
    required this.onEdit,
    required this.onMore,
    required this.onPublishToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 28.h),
          decoration: BoxDecoration(
            color: (isDark ? CostItColors.primaryDark : context.color.surface)
                .withValues(alpha: 0.92),
            border: Border(
              top: BorderSide(color: CostItColors.brightGrey.shade100, width: 1),
            ),
          ),
          child: ScaleTransition(
            scale: fabAnim,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _ActionBtn(
                    icon: Icons.edit_outlined,
                    label: isDraft ? 'Continue Editing' : 'Edit',
                    onTap: onEdit,
                    color: context.color.primary,
                  ),
                ),
                Gap(10.w),
                Expanded(
                  flex: 3,
                  child: _ActionBtn(
                    icon: isDraft
                        ? Icons.publish_rounded
                        : Icons.unpublished_outlined,
                    label: isDraft ? 'Publish' : 'Unpublish',
                    onTap: onPublishToggle,
                    color: isDraft
                        ? CostItColors.success
                        : CostItColors.brightGrey.shade500,
                  ),
                ),
                Gap(10.w),
                _MoreCircleBtn(onTap: onMore),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18.sp),
            Gap(6.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreCircleBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _MoreCircleBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          color: CostItColors.brightGrey.shade100,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: CostItColors.brightGrey.shade200),
        ),
        child: Icon(
          Icons.more_horiz_rounded,
          color: context.color.onSurface,
          size: 22.sp,
        ),
      ),
    );
  }
}