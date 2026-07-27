import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedContainer extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap;
  const RoundedContainer({super.key, required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.all(4),
      icon: Container(
        height: 60.h,
        width: 60.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: CostItColors.brightGrey.shade100),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Image.asset(imagePath),
        ),
      ),
    );
  }
}
