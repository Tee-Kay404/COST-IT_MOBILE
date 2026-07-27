import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConversationsSkeleton extends StatelessWidget {
  const ConversationsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 7,
      itemBuilder: (_, __) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            _Bone(width: 52.r, height: 52.r, radius: 26.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bone(width: 140.w, height: 14.h),
                  SizedBox(height: 8.h),
                  _Bone(width: double.infinity, height: 12.h),
                  SizedBox(height: 4.h),
                  _Bone(width: 100.w, height: 12.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _Bone({required this.width, required this.height, this.radius = 6});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
