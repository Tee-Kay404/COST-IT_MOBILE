import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountSectionHeader extends StatelessWidget {
  const AccountSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Text(
        title.toUpperCase(),
        style: context.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: CostItColors.brightGrey.shade500,
          fontSize: 12.sp,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
