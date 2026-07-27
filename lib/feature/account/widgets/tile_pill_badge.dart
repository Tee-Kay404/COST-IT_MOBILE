import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TilePillBadge extends StatelessWidget {
  const TilePillBadge({
    super.key,
    this.label = 'Manage',
    this.color,
  });

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? context.color.secondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: resolvedColor.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: context.bodySmall?.copyWith(
          color: resolvedColor,
          fontWeight: FontWeight.w700,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
