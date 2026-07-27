import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarPopupMenu<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final PopupMenuItemSelected<T>? onSelected;
  final Color? iconColor;
  final Color? color;

  const AppBarPopupMenu({
    super.key,
    required this.itemBuilder,
    this.onSelected,
    this.iconColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(22.w, 0),
      child: PopupMenuButton<T>(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.more_vert_rounded,
          color: iconColor ?? CostItColors.white,
          size: 22.r,
        ),
        color: color ?? Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        offset: Offset(0, 48.h),
        itemBuilder: itemBuilder,
        onSelected: onSelected,
      ),
    );
  }
}
