import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

Future<void> showDialogMessage(
  BuildContext context, {
  Duration duration = const Duration(milliseconds: 4),
}) {
  return showDialog(
    useRootNavigator: true,
    animationStyle: AnimationStyle(curve: Curves.easeInOut),
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5), // optional
    context: context,
    builder: (BuildContext context) {
      final theme = Theme.of(context);
      return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: 30.w,
        ), // controls dialog width
        backgroundColor: theme.primaryColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min, // shrink to content
            children: [
              Gap(5.h),
              Row(
                children: [
                  Icon(
                    Icons.check_box_outlined,
                    color: CostItColors.success,
                    size: 25.sp,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Account Created Successfully',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              Gap(10.h),
              Text('Login to get Started', style: theme.textTheme.bodySmall),
              Gap(20.h),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: Theme.of(context).textButtonTheme.style,
                child: Center(child: Text('Cancel')),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showFeatureNotEnabledDialog(BuildContext context) {
  return showDialog(
    
    context: context,
    barrierDismissible: false, 
    builder: (context) {
      return Dialog(
        backgroundColor: CostItColors.brightGrey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.cancel, color: CostItColors.primary3),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              // Title
              Text(
                "Oops!",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              // Animation
              Lottie.asset(
                "assets/animations/sorry4.json",
                height: 100.h,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 12),

              // Content Text
              Text(
                "This feature is not yet enabled",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 16),

              // Close button
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    CostItColors.primary1,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
