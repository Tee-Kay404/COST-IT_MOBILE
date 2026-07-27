import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardHeader extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onToggle;
  final VoidCallback onCancel;

  const CardHeader({
    super.key, 
    required this.isEditing,
    required this.onToggle,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Icon(
            Icons.bookmark_outline_rounded,
            size: 18.sp,
            color: context.color.primary,
          ),
          SizedBox(width: 8.w),
          Text('Saved location', style: context.titleSmall),
          const Spacer(),

          if (isEditing) ...[
            GestureDetector(
              onTap: onCancel,
              child: Text(
                'Cancel',
                style: context.bodySmall?.copyWith(
                  color: CostItColors.brightGrey.shade400,
                ),
              ),
            ),
            SizedBox(width: 14.w),
          ],

          GestureDetector(
            onTap: onToggle,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                isEditing ? 'Save' : 'Edit',
                key: ValueKey(isEditing),
                style: context.bodySmall?.copyWith(
                  color: context.color.onPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
