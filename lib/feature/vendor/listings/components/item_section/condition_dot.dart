import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConditionDot extends StatelessWidget {
  final String condition;

  const ConditionDot({super.key, required this.condition});

  Color get _color => switch (condition) {
    'Brand New'   => const Color(0xFF22C55E),
    'Fairly Used' => const Color(0xFF3B82F6),
    'Old Stock'   => const Color(0xFFF97316),
    'Second Hand' => const Color(0xFF94A3B8),
    _             => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
    );
  }
}
