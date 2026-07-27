import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'CostIt Mobile',
          style: context.bodySmall?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade400,
          ),
        ),
        Gap(4.h),
        Text(
          'Version 1.0.0 · Build 1',
          style: context.bodySmall?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
