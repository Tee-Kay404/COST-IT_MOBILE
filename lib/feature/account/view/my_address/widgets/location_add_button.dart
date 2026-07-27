import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/components/buttons/dashed_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddLocationButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddLocationButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: DashedContainer(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: context.color.onPrimary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: 20.sp,
                      color: context.color.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Add more locations',
          style: context.bodySmall?.copyWith(
            color: CostItColors.brightGrey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
