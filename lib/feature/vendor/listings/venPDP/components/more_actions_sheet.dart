import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/vendor/listings/my_listings/widgets/seller_product_overflow_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Bottom sheet listing secondary actions: duplicate, share,
/// analytics, preview, archive, delete.
class MoreActionsSheet extends StatelessWidget {
  final Product product;
  final bool isDraft;
  final ValueChanged<ProductAction> onAction;

  const MoreActionsSheet({
    super.key,
    required this.product,
    required this.isDraft,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1D2E) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: CostItColors.brightGrey.shade200,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 4.h),
            child: Row(
              children: [
                Text(
                  'More Actions',
                  style: context.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: CostItColors.brightGrey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16.sp,
                      color: CostItColors.brightGrey.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: CostItColors.brightGrey.shade100,
            height: 1,
            indent: 20.w,
            endIndent: 20.w,
          ),
          _SheetTile(
            icon: Icons.file_copy_outlined,
            label: 'Duplicate Listing',
            color: context.color.onPrimary,
            onTap: () => onAction(ProductAction.duplicate),
          ),
          _SheetTile(
            icon: Icons.share_outlined,
            label: 'Share Listing',
            color: context.color.onPrimary,
            onTap: () => onAction(ProductAction.share),
          ),
          if (!isDraft)
            _SheetTile(
              icon: Icons.analytics_outlined,
              label: 'View Analytics',
              color: CostItColors.successGreen,
              onTap: () => onAction(ProductAction.viewAnalytics),
            ),
          _SheetTile(
            icon: Icons.visibility_outlined,
            label: 'Preview as Buyer',
            color: CostItColors.brightGrey.shade500,
            onTap: () => onAction(ProductAction.preview),
          ),
          Divider(
            color: CostItColors.brightGrey.shade100,
            height: 1,
            indent: 20.w,
            endIndent: 20.w,
          ),
          _SheetTile(
            icon: Icons.archive_outlined,
            label: 'Archive Listing',
            color: CostItColors.brightGrey.shade500,
            onTap: () => onAction(ProductAction.archive),
          ),
          _SheetTile(
            icon: Icons.delete_outline_rounded,
            label: isDraft ? 'Delete Draft' : 'Delete Listing',
            color: CostItColors.error,
            isDestructive: true,
            onTap: () => onAction(ProductAction.delete),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
        ],
      ),
    );
  }
}

class _SheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SheetTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 18.sp, color: color),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: context.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDestructive ? CostItColors.error : null,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              size: 18.sp,
              color: CostItColors.brightGrey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}