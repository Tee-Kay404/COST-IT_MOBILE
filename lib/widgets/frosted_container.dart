import 'dart:ui';

import 'package:flutter/material.dart';

final frostedBoxDecoration = BoxDecoration(
  color: Colors.white.withAlpha(38),
  border: Border.all(
    color: Colors.white.withAlpha(51),
    width: 0.5,
  ),
);

class FrostedContainer extends StatelessWidget {
  final Widget child;
  final ImageFilter? imageFilter;
  final BorderRadius borderRadius;
  final BoxDecoration? boxDecoration;
  const FrostedContainer({
    super.key,
    required this.child,
    this.imageFilter,
    this.borderRadius = BorderRadius.zero,
    this.boxDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: imageFilter ?? ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: ColoredBox(
          color: Theme.of(context).cardColor.withAlpha(150),
          child: Container(
            decoration: boxDecoration ?? frostedBoxDecoration,
            child: child,
          ),
        ),
      ),
    );
  }
}
