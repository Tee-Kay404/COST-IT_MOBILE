import 'package:bot_toast/bot_toast.dart';
import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScaffoldMessage extends SnackBar {
  ScaffoldMessage({
    super.key,
    required String message,
    Color? color,
    required BuildContext context,
    super.behavior = SnackBarBehavior.floating,
  }) : super(
         showCloseIcon: false,
         backgroundColor: context.theme.primaryColorLight,
         content: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Expanded(
               child: Text(
                 message,
                 style: context.bodySmall?.copyWith(
                   fontSize: 14.sp,
                   color: color ?? context.theme.primaryColorDark,
                 ),
               ),
             ),
             SizedBox(width: 8.w),
             GestureDetector(
               onTap: () {
                 ScaffoldMessenger.of(context).hideCurrentSnackBar();
               },
               child: Icon(
                 Icons.close_rounded,
                 size: 18.sp,
                 color: context.theme.primaryColorDark,
               ),
             ),
           ],
         ),
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(10.sp),
         ),
       );
}

showErrorExceptionToast(
  BuildContext context,
  String message, {
  Color? color,
  Duration duration = const Duration(seconds: 3),
}) {
  BotToast.showCustomText(
    align: Alignment.topCenter,
    duration: duration,
    toastBuilder: (cancelFunc) {
      return Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 20.sp),
          constraints: BoxConstraints(maxWidth: 400),
          color: Colors.transparent,
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: double.maxFinite,
              child: ToastMessage(
                color: color ?? CostItColors.error,
                message: message,
                trailingWidget: Icon(
                  Icons.close_outlined,
                  size: 20.sp,
                  color: color ?? CostItColors.error,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
