import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/product_details/components/components.dart';
import 'package:cost_it_mobile/feature/products/product_details/components/modals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Product product;
  final bool isCollapsed;

  const ProductDetailsAppBar({
    super.key,
    required this.product,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isCollapsed ? context.color.primary : Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          children: [
            AppBarCircleButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
              isCollapsed: isCollapsed,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: isCollapsed
                  ? Text(
                      product.title,
                      style: context.bodyMedium?.copyWith(
                        color: CostItColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox.shrink(),
            ),
            AppBarSaveButton(productId: product.id, isCollapsed: isCollapsed),
            SizedBox(width: 6.w),
            AppBarCircleButton(
              icon: Icons.more_vert_rounded,
              onTap: () =>
                  showMoreOptionsSheet(context, product),
              isCollapsed: isCollapsed,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
