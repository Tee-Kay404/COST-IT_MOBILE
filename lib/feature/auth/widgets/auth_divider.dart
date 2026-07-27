import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: CostItColors.brightGrey.shade800,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'Or',
            style: context.bodySmall?.copyWith(
              color: CostItColors.brightGrey.shade800,
              fontSize: 15.sp,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: CostItColors.brightGrey.shade800,
          ),
        ),
      ],
    );
  }
}
