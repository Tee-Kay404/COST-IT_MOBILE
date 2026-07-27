import 'package:flutter/material.dart';

class ArrowBackButton extends StatelessWidget {
  final Color color;
  final double? size;
  final VoidCallback? onPressed;

  const ArrowBackButton({
    super.key,
    this.color = Colors.white,
    this.size,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: color, size: size),
      onPressed: onPressed ?? () => Navigator.pop(context),
    );
  }
}
