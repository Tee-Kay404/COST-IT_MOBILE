import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/widgets/app_bar_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ProductAction {
  edit,
  publish,
  unpublish,
  duplicate,
  archive,
  delete,
  share,
  preview,
  viewAnalytics,
}

class SellerProductOverflowMenu extends StatelessWidget {
  final bool isDraft;
  final ValueChanged<ProductAction> onActionSelected;

  const SellerProductOverflowMenu({
    super.key,
    required this.isDraft,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppBarPopupMenu<ProductAction>(
      iconColor: context.color.inverseSurface,
      color: context.color.surface,
      itemBuilder: (_) {
        return [
          _buildItem(
            context,
            value: ProductAction.edit,
            icon: Icons.edit_outlined,
            label: isDraft ? 'Continue Editing' : 'Edit Product',
          ),
          if (isDraft)
            _buildItem(
              context,
              value: ProductAction.publish,
              icon: Icons.publish_rounded,
              label: 'Publish Draft',
            )
          else
            _buildItem(
              context,
              value: ProductAction.unpublish,
              icon: Icons.unpublished_outlined,
              label: 'Unpublish',
            ),
          _buildItem(
            context,
            value: ProductAction.preview,
            icon: Icons.visibility_outlined,
            label: 'Preview Product',
          ),
          const PopupMenuDivider(),
          _buildItem(
            context,
            value: ProductAction.duplicate,
            icon: Icons.file_copy_outlined,
            label: 'Duplicate Listing',
          ),
          _buildItem(
            context,
            value: ProductAction.share,
            icon: Icons.share_outlined,
            label: 'Share Listing',
          ),
          if (!isDraft)
            _buildItem(
              context,
              value: ProductAction.viewAnalytics,
              icon: Icons.analytics_outlined,
              label: 'View Analytics',
            ),
          const PopupMenuDivider(),
          _buildItem(
            context,
            value: ProductAction.archive,
            icon: Icons.archive_outlined,
            label: 'Archive',
          ),
          _buildItem(
            context,
            value: ProductAction.delete,
            icon: Icons.delete_outline_rounded,
            label: isDraft ? 'Delete Draft' : 'Delete',
            isDestructive: true,
          ),
        ];
      },
      onSelected: onActionSelected,
    );
  }

  PopupMenuItem<ProductAction> _buildItem(
    BuildContext context, {
    required ProductAction value,
    required IconData icon,
    required String label,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? CostItColors.error : context.color.inverseSurface;

    return PopupMenuItem<ProductAction>(
      value: value,
      height: 44.h,
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: color),
          SizedBox(width: 10.w),
          Text(
            label,
            style: context.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
