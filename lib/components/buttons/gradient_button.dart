import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final void Function()? onPressed;
  const GradientButton({
    super.key,
    required this.text,
    this.height = 50,
    this.width = double.infinity,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.surface,
        minimumSize: Size(width.w, height.h),
        shape: StadiumBorder(),
        // textStyle: Theme.of(context).textTheme.titleMedium,
        padding: const EdgeInsets.symmetric(horizontal: 0),
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: onPressed == null
                ? [Colors.grey.shade400, Colors.grey.shade500]
                : [
                    Color(0xFF0871F5),
                    Color(0xFF1A9FFF),
                  ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
          child: Text(text),
        ),
      ),
    );
  }
}
