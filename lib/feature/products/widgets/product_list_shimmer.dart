import 'package:cost_it_mobile/extensions/list_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';

class ProductListShimmer extends StatelessWidget {
  const ProductListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = context.color.surface;
    final highlightColor = context.theme.scaffoldBackgroundColor;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 100.w,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(12.r),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List<Widget>.generate(
                    8,
                    (_) => Container(
                      width: double.infinity,
                      height: 8.h,
                      color: baseColor,
                    ),
                  ).separatedBy(SizedBox(height: 8.h)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
