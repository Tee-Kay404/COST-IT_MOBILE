import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToastMessage extends StatelessWidget {
  final String message;
  final Color color;
  final Color textColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double borderWidth;
  final Widget? leadingWidget;
  final Widget? trailingWidget;

  const ToastMessage({
    super.key,
    required this.message,
    this.textColor = CostItColors.error,
    this.color = CostItColors.primary,
    this.borderWidth = 1,
    this.backgroundColor,
    this.textStyle,
    this.leadingWidget,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12.sp),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.04),
          border: (borderWidth > 0)
              ? Border.all(color: textColor, width: borderWidth)
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingWidget != null) leadingWidget!,
            Expanded(
              child: Text(
                message,
                style: textStyle ?? context.bodySmall?.copyWith(color: color),
              ),
            ),
            if (trailingWidget != null) trailingWidget!,
          ],
        ),
      ),
    );
  }
}

showCustomToast(String message, Color? color, BuildContext context) {
  DelightToastBar(
    builder: (BuildContext context) {
      return ToastCard(
        leading: Icon(
          Icons.check_box,
          color: CostItColors.success,
          size: 24.sp,
        ),
        title: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: color, fontSize: 17.sp),
        ),
      );
    },
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
    snackbarDuration: Durations.extralong4,
  ).show(context);
}

showSuccessToast(BuildContext context, String message) {
  showCustomToast(message, CostItColors.success, context);
}
