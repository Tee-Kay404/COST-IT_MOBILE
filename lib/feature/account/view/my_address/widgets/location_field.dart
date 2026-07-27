import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/components/textfields/costit_textfield.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/widgets/read_only_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final IconData prefixIcon;
  final String hint;
  final int maxLines;
  final FocusNode? focusNode;
  final bool isDefault;
  final VoidCallback? onDefaultTap;

  const LocationField({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditing,
    required this.prefixIcon,
    required this.hint,
    this.maxLines = 1,
    this.focusNode,
    this.isDefault = false,
    this.onDefaultTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: context.bodySmall?.copyWith(
                  color: CostItColors.brightGrey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (onDefaultTap != null)
              GestureDetector(
                onTap: onDefaultTap,
                child: Icon(
                  isDefault ? Icons.star_rounded : Icons.star_border_rounded,
                  color: isDefault
                      ? context.color.onPrimary
                      : CostItColors.brightGrey.shade400,
                  size: 24.sp,
                ),
              ),
          ],
        ),
        SizedBox(height: 6.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: isEditing
              ? CostItTextfield(
                  focusNode: focusNode,
                  hintText: hint,
                  controller: controller,
                  maxLines: maxLines,
                  prefixIcon: Icon(
                    prefixIcon,
                    size: 18.sp,
                    color: context.theme.focusColor,
                  ),
                )
              : ReadOnlyField(
                  controller: controller,
                  prefixIcon: prefixIcon,
                  maxLines: maxLines,
                ),
        ),
      ],
    );
  }
}
