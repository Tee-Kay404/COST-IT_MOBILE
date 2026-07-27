import 'package:flutter/material.dart';

class PillIndicator extends Decoration {
  final Color color;
  final double radius;
  final double horizontalPadding;
  final double verticalPadding;

  const PillIndicator({
    required this.color,
    this.radius = 20,
    this.horizontalPadding = 0,
    this.verticalPadding = 5,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _PillPainter(
      color: color,
      radius: radius,
      hPad: horizontalPadding,
      vPad: verticalPadding,
    );
  }
}

class _PillPainter extends BoxPainter {
  final Color color;
  final double radius;
  final double hPad;
  final double vPad;

  _PillPainter({
    required this.color,
    required this.radius,
    required this.hPad,
    required this.vPad,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    final paint = Paint()..color = color;
    final rect = Rect.fromLTWH(
      offset.dx + hPad,
      offset.dy + vPad,
      (config.size?.width ?? 0) - hPad * 2,
      (config.size?.height ?? 0) - vPad * 2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }
}
