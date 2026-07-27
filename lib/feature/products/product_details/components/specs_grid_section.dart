// lib/feature/products/product_details/components/specs_grid_section.dart

import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecsGridSection extends StatelessWidget {
  final Product product;

  const SpecsGridSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final specs = <_SpecEntry>[
      _SpecEntry('Category', product.categoryLabel),
      _SpecEntry('Unit', product.unit),
      _SpecEntry('Vendor', product.vendor.name),
      _SpecEntry('Condition', 'New'),
      _SpecEntry('Min. Order', '1 ${product.unit}'),
      _SpecEntry('Delivery', 'Available'),
    ];

    return Container(
      color: context.color.surface,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Details',
            style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
          ...List.generate((specs.length / 2).ceil(), (row) {
            final left = specs[row * 2];
            final right = (row * 2 + 1 < specs.length)
                ? specs[row * 2 + 1]
                : null;
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Expanded(child: _SpecTile(entry: left)),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: right != null
                        ? _SpecTile(entry: right)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SpecEntry {
  final String label;
  final String value;
  const _SpecEntry(this.label, this.value);
}

class _SpecTile extends StatelessWidget {
  final _SpecEntry entry;
  const _SpecTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entry.value,
          style: context.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 2.h),
        Text(
          entry.label,
          style: context.bodySmall?.copyWith(
            color: Colors.grey.shade500,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}
