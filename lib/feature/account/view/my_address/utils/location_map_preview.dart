import 'package:flutter/material.dart';


class LocationMapPreview extends StatelessWidget {
  final String imagePath;

  const LocationMapPreview({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;

    return SizedBox(
      width: double.infinity,
      height: screenH * 0.40,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, _, __) =>
                _MapImageFallback(height: screenH * 0.40),
          ),


        ],
      ),
    );
  }
}


class _MapImageFallback extends StatelessWidget {
  final double height;

  const _MapImageFallback({required this.height});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      height: height,
      color: color.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 36, color: color.primary.withOpacity(0.4)),
            const SizedBox(height: 8),
            Text(
              'Map image not found',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color.onSurface.withOpacity(0.4),
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add your asset and pass the path to LocationMapPreview',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color.onSurface.withOpacity(0.25),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}