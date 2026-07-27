import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VendorsTab extends StatelessWidget {
  final String query;

  const VendorsTab({super.key, required this.query});

  @override
  Widget build(BuildContext context) {

    // TODO: replace with real vendor search provider
    // For now shows the empty/stub state
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.storefront_outlined,
              size: 48.r,
              color: context.color.inverseSurface.withValues(alpha: 0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              query.isEmpty
                  ? 'Search for a vendor by name or product category'
                  : 'No vendors found for "$query"',
              style: context.bodyMedium?.copyWith(
                    color: context.color.inverseSurface.withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // TODO: navigate to product browse / vendor list
              },
              icon: const Icon(Icons.explore_outlined, size: 18),
              label: const Text('Browse Products'),
            ),
          ],
        ),
      ),
    );
  }
}

