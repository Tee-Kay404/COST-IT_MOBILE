import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/app/global/styles/colors.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key, this.onTap, this.hasNotification = true});

  final VoidCallback? onTap;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Colors.white.withAlpha(60),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),
          ),

          if (hasNotification)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 15.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: CostItColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    // white ring around dot so it
                    // pops against any background
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
