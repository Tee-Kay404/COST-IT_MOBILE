import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashedContainer extends StatelessWidget {
  final Widget child;

  const DashedContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(color: context.color.onPrimary),
      child: ClipRRect(borderRadius: BorderRadius.circular(16.r), child: child),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const radius = Radius.circular(16);
    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      radius,
    );

    final path = Path()..addRRect(rRect);
    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final start = distance;
        final end = (distance + dashWidth).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(start, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) => old.color != color;
}
