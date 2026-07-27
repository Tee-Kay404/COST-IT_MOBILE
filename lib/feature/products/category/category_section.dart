import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/category/category_card.dart';
import 'package:cost_it_mobile/feature/products/category/widgets/shimmer.dart';
import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      loading: () => const CategoriesShimmer(),
      error: (err, stack) {
        debugPrint(' Categories error: $err');
        debugPrint(' Categories stack: $stack');
        return Center(
          child: Text(
            'Could not load categories!!!',
            style: context.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
        );
      },
      data: (categories) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: 12.h),
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return CategoryCard(
                    category: cat,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PageRoutes.categories.name,
                        arguments: cat.id,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
