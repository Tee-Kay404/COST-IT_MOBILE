import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewChatFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final String tooltip;

  const NewChatFAB({
    super.key,
    required this.onPressed,
    this.tooltip = 'New conversation',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      width: 60.w,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        onPressed: onPressed,
        tooltip: tooltip,
        backgroundColor: context.color.onPrimary,
        child: Icon(
          Icons.person_add_outlined,
          color: CostItColors.white,
          size: 28.sp,
        ),
      ),
    );
  }
}
