import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarouselIndicator extends StatelessWidget {
  final int count;
  final int current;
  final Color activeColor;

  const CarouselIndicator({
    super.key,
    required this.count,
    required this.current,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: index == current ? 22 : 5,
          height: 7,
          decoration: BoxDecoration(
            color: index == current ? activeColor : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8.sp),
          ),
        ),
      ),
    );
  }
}
