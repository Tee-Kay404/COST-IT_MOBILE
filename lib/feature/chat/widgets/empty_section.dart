import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptySection extends StatelessWidget {
  final IconData icon;
  final String message;
  final Widget? action;

  const EmptySection({super.key, required this.icon, required this.message, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
      child: Column(
        children: [
          Icon(icon, size: 32.r, color: context.color.inverseSurface.withValues(alpha: 0.5)),
          SizedBox(height: 8.h),
          Text(
            message,
            style: context.bodySmall?.copyWith(
                  color: context.color.inverseSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[SizedBox(height: 12.h), action!],
        ],
      ),
    );
  }
}