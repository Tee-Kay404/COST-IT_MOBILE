import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const SavedErrorState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.r,
            color: context.color.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'Could not load saved products',
            style: context.bodyMedium?.copyWith(
              color: context.color.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 20.h),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
