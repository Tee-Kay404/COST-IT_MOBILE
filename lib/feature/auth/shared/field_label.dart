import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, bottom: 6.h),
          child: Text(
            label,
            style: context.bodySmall?.copyWith(
              color: context.color.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}
