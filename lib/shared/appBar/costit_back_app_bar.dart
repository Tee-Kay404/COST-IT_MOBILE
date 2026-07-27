import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/widgets/arrow_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CostItBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final Widget? leading;
  final double? leadingWidth;
  final List<Widget>? actions;

  const CostItBackAppBar({
    super.key,
    required this.title,
    this.bottom,
    this.showBackButton = true,
    this.leading,
    this.leadingWidth,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: context.color.primary,
      scrolledUnderElevation: 0,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      bottom: bottom,
      centerTitle: true,
      leading:
          leading ??
          (showBackButton
              ? ArrowBackButton(color: CostItColors.white, size: 24.sp)
              : null),
      leadingWidth: leadingWidth,
      actions: actions,
      title: Text(
        title,
        style: context.bodyLarge?.copyWith(
          color: CostItColors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(56.h + bottomHeight);
  }
}
