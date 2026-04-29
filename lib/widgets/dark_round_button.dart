import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackArrowButton extends StatelessWidget {
  final void Function()? onTap;
   const BackArrowButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        height: 40.h,
        width: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.color.primary,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(Icons.arrow_back_ios, size: 20.sp, color: Colors.white),
        ),
      ),
    );
  }
}
