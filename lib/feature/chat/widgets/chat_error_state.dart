import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const ChatErrorState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_outlined,
              size: 48.r,
              color: color.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: 16.h),
            Text(
              'Couldn\'t load conversations',
              style: context.bodyLarge?.copyWith(
                color: color.onSurface.withValues(alpha: 0.55),
              ),
            ),
            SizedBox(height: 16.h),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
