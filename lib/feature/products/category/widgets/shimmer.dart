import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesShimmer extends StatefulWidget {
  const CategoriesShimmer({super.key});

  @override
  State<CategoriesShimmer> createState() => _CategoriesShimmerState();
}

class _CategoriesShimmerState extends State<CategoriesShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    return SizedBox(
      height: 120.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, __) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment(-1 + (_controller.value * 2), 0),
                    end: Alignment(1 + (_controller.value * 2), 0),
                    colors: [
                      baseColor,
                      highlightColor,
                      baseColor,
                    ],
                    stops: const [0.25, 0.5, 0.75],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
                child: child,
              );
            },
            child: Container(
              width: 90.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 90.w,
                    height: 90.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 60.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}