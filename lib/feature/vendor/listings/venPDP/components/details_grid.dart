import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/widgets/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'shared_widgets.dart';

/// Product details grid — Category, Condition, Location, Qty
/// Available, SKU, Listed date. Each tile is a plain white card,
/// gently elevated (since the page background isn't pure white),
/// with the icon accented in primary color only.
class DetailsGrid extends StatelessWidget {
  final Product product;
  const DetailsGrid({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final items = <_DetailItem>[
      _DetailItem(
        icon: Icons.category_outlined,
        label: 'Category',
        value: product.categoryLabel,
      ),
      if (product.condition != null)
        _DetailItem(
          icon: Icons.sell_outlined,
          label: 'Condition',
          value: product.condition!,
        ),
      if (product.location != null)
        _DetailItem(
          icon: Icons.location_on_outlined,
          label: 'Location',
          value: product.location!,
        ),
      _DetailItem(
        icon: Icons.inventory_outlined,
        label: 'Qty Available',
        value: product.quantityAvailable == 0
            ? 'Not specified'
            : '${product.quantityAvailable} units',
      ),
      if (product.vendorSKU != null)
        _DetailItem(
          icon: Icons.qr_code_outlined,
          label: 'SKU',
          value: product.vendorSKU!,
        ),
      _DetailItem(
        icon: Icons.calendar_today_outlined,
        label: 'Listed',
        value: parseDate2(product.createdAt),
      ),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(label: 'Product Details'),
          Gap(12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 2.4,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) => _DetailTile(item: items[i]),
          ),
        ],
      ),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _DetailTile extends StatelessWidget {
  final _DetailItem item;
  const _DetailTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? context.color.inversePrimary 
            : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: context.color.onPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(item.icon, size: 14.sp, color: context.color.onPrimary),
          ),
          Gap(8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: CostItColors.brightGrey.shade400,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                Gap(1.h),
                Text(
                  item.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? context.color.inverseSurface 
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}