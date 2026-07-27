import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:cost_it_mobile/app/theme/theme.dart';

class BillingHeader extends StatelessWidget {
  const BillingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: context.titleLarge?.copyWith(
                fontSize: 34.sp,
                fontWeight: FontWeight.w800,
                height: 1.12,
                letterSpacing: -0.8,
              ),
              children: [
                TextSpan(
                  text: 'More\n',
                  style: TextStyle(color: context.color.inverseSurface),
                ),
                TextSpan(text: 'Con', style: TextStyle(color: context.color.primary)),
                TextSpan(text: 'struction', style: TextStyle(color: context.color.secondary)),
                TextSpan(
                  text: ' Sales.',
                  style: TextStyle(color: context.color.inverseSurface),
                ),
              ],
            ),
          ),
          Gap(10.h),
          Text(
            'Reach more buyers, get verified, and close\n'
            'more deals across Nigeria.',
            style: context.bodySmall?.copyWith(
              fontSize: 13.sp,
              color: context.color.inverseSurface.withOpacity(0.5),
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}