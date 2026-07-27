import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/components/seeAll/enums.dart';
import 'package:cost_it_mobile/feature/products/components/seeAll/see_all_page.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeader extends StatelessWidget {
  final SeeAllSection? section;
  final String? label;

  const SectionHeader({super.key, this.section, this.label});

  @override
  Widget build(BuildContext context) {
    final displayLabel = label ?? section?.title ?? '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: [
          Text(
            displayLabel,
            style: context.bodyLarge?.copyWith(
              fontSize: 18.sp,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (section != null)
            GestureDetector(
              onTap: () {
                if (section == SeeAllSection.categories) {
                  Navigator.pushNamed(context, PageRoutes.categories.name);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeeAllPage(section: section!),
                    ),
                  );
                }
              },
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: context.bodyMedium?.copyWith(
                      color: context.color.onPrimary,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10.sp,
                    color: context.color.onPrimary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
