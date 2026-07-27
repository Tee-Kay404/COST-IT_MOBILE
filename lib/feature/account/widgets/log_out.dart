import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: outlinedButtonStyle(
          color: context.color.error,
          outlineColor: context.color.error.withOpacity(0.45),
          borderRadius: 16,
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 22.sp),
            SizedBox(width: 8.w),
            Text(
              'Log Out',
              style: context.bodyMedium?.copyWith(
                color: context.color.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}