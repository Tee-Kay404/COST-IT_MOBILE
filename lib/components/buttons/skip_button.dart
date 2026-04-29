import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkipButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final void Function()? onPressed;
  const SkipButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.grey[100],
            foregroundColor: Theme.of(context).colorScheme.secondary,
            textStyle: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
            minimumSize: Size(width.w, height)),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 15),
        ));
  }
}
