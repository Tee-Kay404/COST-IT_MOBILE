import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppErrorDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;
  final String buttonText;

  const AppErrorDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.buttonText,
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
            // Cancel Icon at top right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
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
                      icon: Icon(Icons.cancel_outlined, size: 24.sp),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12.sp),

            // animation or text
            Icon(icon, size: 30.sp, color: context.color.primary),

            SizedBox(height: 12.h),

            // Content Text
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.bodySmall,
            ),

            const SizedBox(height: 16),

            // Close button
            TextButton(
              style: TextButton.styleFrom(
                fixedSize: Size(120.w, 40.h),
                backgroundColor: (context.color.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20.sp),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
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

void showExceptionErrorMessage(
  BuildContext context,
  String title,
  IconData iconData,
  String content,
  String buttonText,
) {
  showDialog(
    context: context,
    builder: (_) => AppErrorDialog(
      title: title,
      icon: iconData,
      message: content,
      buttonText: buttonText,
    ),
  );
}
