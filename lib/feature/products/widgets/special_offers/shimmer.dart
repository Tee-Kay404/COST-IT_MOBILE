// lib/feature/products/components/special_offers/special_offers_shimmer.dart
import 'package:cost_it_mobile/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialOffersShimmer extends StatelessWidget {
  const SpecialOffersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, __) => ShimmerBox(
              width: MediaQuery.of(context).size.width * 0.88,
              height: 180,
              borderRadius: 16,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        // Indicator dots shimmer
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (_) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: ShimmerBox(width: 8, height: 8, borderRadius: 4),
            ),
          ),
        ),
      ],
    );
  }
}
