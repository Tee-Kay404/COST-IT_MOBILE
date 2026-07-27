import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReadOnlyField extends StatelessWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final int maxLines;

  const ReadOnlyField({
    super.key,
    required this.controller,
    required this.prefixIcon,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FE),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: CostItColors.brightGrey.shade200),
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(
            prefixIcon,
            size: 18.sp,
            color: CostItColors.brightGrey.shade400,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              controller.text.isEmpty ? '—' : controller.text,
              style: context.bodyMedium?.copyWith(
                color: CostItColors.brightGrey.shade700,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
