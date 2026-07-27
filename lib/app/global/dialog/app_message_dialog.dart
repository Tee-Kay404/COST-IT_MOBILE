import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppMessageDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;
  final String buttonText;
  final VoidCallback? onRetry;

  const AppMessageDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.buttonText,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.theme.primaryColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      splashColor: Colors.transparent,
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: 24.sp,
                        color: context.color.inverseSurface,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12.sp),

            Icon(icon, size: 30.sp, color: context.color.onPrimary),

            SizedBox(height: 12.h),

            Text(
              message,
              textAlign: TextAlign.center,
              style: context.bodySmall?.copyWith(
                color: context.color.inverseSurface,
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              style: flatTextButtonStyle(
                backgroundColor: context.color.onPrimary,
                borderRadius: 20,
              ).copyWith(fixedSize: WidgetStatePropertyAll(Size(120.w, 40.h))),
              onPressed: () {
                Navigator.of(context).pop(true);
                onRetry?.call();
              },
              child: Center(
                child: Text(
                  buttonText,
                  style: context.bodyMedium?.copyWith(
                    color: context.color.surface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showAppMessageDialog(
  BuildContext context,
  String title,
  IconData iconData,
  String content,
  String buttonText, {
  VoidCallback? onRetry,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AppMessageDialog(
      title: title,
      icon: iconData,
      message: content,
      buttonText: buttonText,
      onRetry: onRetry,
    ),
  );
}
