import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';

class TxtButton extends StatelessWidget {
  final String text;
  final Color? color;
  final double height;
  final double width;
  final Color? textColor;
  final void Function()? onPressed;
  final Color backgroundColor;
  const TxtButton({
    super.key,
    required this.text,
    this.color,
    this.height = 40,
    this.width = 80,
    this.textColor,
    this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: flatTextButtonStyle(
        backgroundColor: backgroundColor,
        borderRadius: 15,
      ).copyWith(
        fixedSize: WidgetStatePropertyAll(Size(width, height)),
      ),
      child: Text(
        text,
        style: context.bodySmall?.copyWith(
          color: textColor ?? context.color.surface,
        ),
      ),
    );
  }
}
