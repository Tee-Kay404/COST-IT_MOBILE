import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum EmptyStateType {
  all,
  published,
  drafts,
  pending,
  rejected,
  archived,
  outOfStock,
  search,
  specialOffers,
}

class MyListingsEmptyState extends StatelessWidget {
  final EmptyStateType type;

  const MyListingsEmptyState({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                color: context.color.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(),
                size: 42.sp,
                color: context.color.primary,
              ),
            ),
            Gap(20.h),
            Text(
              _getTitle(),
              style: context.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            Text(
              _getDescription(),
              textAlign: TextAlign.center,
              style: context.bodySmall?.copyWith(
                color: CostItColors.brightGrey.shade400,
                height: 1.5,
              ),
            ),
            Gap(28.h),
            if (_showAction())
              FilledButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, PageRoutes.sell.name),
                style: FilledButton.styleFrom(
                  backgroundColor: context.color.primary,
                  foregroundColor: CostItColors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: const Icon(Icons.add_rounded, color: CostItColors.white),
                label: Text(
                  _getActionLabel(),
                  style: context.bodyMedium?.copyWith(
                    color: CostItColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case EmptyStateType.all:
        return Icons.inventory_2_outlined;
      case EmptyStateType.published:
        return Icons.check_circle_outline_rounded;
      case EmptyStateType.drafts:
        return Icons.edit_document;
      case EmptyStateType.pending:
        return Icons.hourglass_empty_rounded;
      case EmptyStateType.rejected:
        return Icons.error_outline_rounded;
      case EmptyStateType.archived:
        return Icons.archive_outlined;
      case EmptyStateType.outOfStock:
        return Icons.remove_shopping_cart_outlined;
      case EmptyStateType.search:
        return Icons.search_off_rounded;
      case EmptyStateType.specialOffers:
        return Icons.local_offer_outlined;
    }
  }

  String _getTitle() {
    switch (type) {
      case EmptyStateType.all:
        return 'No listings yet';
      case EmptyStateType.published:
        return 'No published products';
      case EmptyStateType.drafts:
        return 'No saved drafts';
      case EmptyStateType.pending:
        return 'No pending reviews';
      case EmptyStateType.rejected:
        return 'No reported listings';
      case EmptyStateType.archived:
        return 'No archived products';
      case EmptyStateType.outOfStock:
        return 'All stocked up!';
      case EmptyStateType.search:
        return 'No products found';
      case EmptyStateType.specialOffers:
        return 'No special offers';
    }
  }

  String _getDescription() {
    switch (type) {
      case EmptyStateType.all:
        return 'Start selling by creating your first product listing.';
      case EmptyStateType.published:
        return 'You haven\'t published any products yet. Drafts or pending items will appear in their respective tabs.';
      case EmptyStateType.drafts:
        return 'You don\'t have any unfinished product drafts.';
      case EmptyStateType.pending:
        return 'There are no products currently waiting for admin approval.';
      case EmptyStateType.rejected:
        return 'Great! None of your product listings have been reported.';
      case EmptyStateType.archived:
        return 'You haven\'t archived any of your listings.';
      case EmptyStateType.outOfStock:
        return 'None of your active products are currently out of stock.';
      case EmptyStateType.search:
        return 'Try adjusting your search or filters to find what you\'re looking for.';
      case EmptyStateType.specialOffers:
        return 'You don\'t have any active special offers running.';
    }
  }

  bool _showAction() {
    return type == EmptyStateType.all ||
        type == EmptyStateType.published ||
        type == EmptyStateType.drafts;
  }

  String _getActionLabel() {
    switch (type) {
      case EmptyStateType.drafts:
        return 'Create New Product';
      default:
        return 'Create Listing';
    }
  }
}
