import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationSectionHeader extends StatelessWidget {
  final String label;
  const LocationSectionHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: CostItColors.brightGrey.shade100,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Text(
        label,
        style: context.bodySmall?.copyWith(
          fontSize: 13.sp,
          color: CostItColors.brightGrey.shade500,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

