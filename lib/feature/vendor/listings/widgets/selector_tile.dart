import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectorTile extends StatelessWidget {
  final String label;
  final String? value;
  final IconData? leadingIcon;
  final VoidCallback onTap;
  final String? errorText;
  final bool required;

  const SelectorTile({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.leadingIcon,
    this.errorText,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: context.color.inversePrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: hasError
                    ? context.color.error
                    : hasValue
                    ? context.color.primary.withOpacity(0.6)
                    : Colors.grey.shade300,
                width: hasValue ? 1.2 : 1,
              ),
            ),
            child: Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    size: 18.sp,
                    color: CostItColors.brightGrey.shade500,
                  ),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: label,
                          style: context.bodySmall?.copyWith(
                            color: CostItColors.brightGrey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            if (required)
                              const TextSpan(text: ' *')
                            else if (!hasValue)
                              TextSpan(
                                text: ' (optional)',
                                style: context.bodySmall?.copyWith(
                                  color: CostItColors.brightGrey,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (hasValue) ...[
                        SizedBox(height: 2.h),
                        Text(
                          value!,
                          style: context.bodyMedium?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: context.color.inverseSurface,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20.sp,
                  color: CostItColors.brightGrey.shade400,
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Text(
              errorText!,
              style: context.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: context.color.error,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
