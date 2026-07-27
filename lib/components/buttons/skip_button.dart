import 'package:cost_it_mobile/app/global/styles/styles.dart';
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
        style: flatTextButtonStyle(
            backgroundColor: Colors.grey[100] ?? Colors.grey,
            textColor: Theme.of(context).colorScheme.secondary,
            borderRadius: 25,
        ).copyWith(
            minimumSize: WidgetStatePropertyAll(Size(width.w, height)),
            textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 15),
        ));
  }
}
