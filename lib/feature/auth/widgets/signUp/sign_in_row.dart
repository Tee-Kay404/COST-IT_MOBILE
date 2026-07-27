import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SignInRow extends StatefulWidget {
  const SignInRow({super.key});

  @override
  State<SignInRow> createState() => _SignInRowState();
}

class _SignInRowState extends State<SignInRow> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: context.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
          ),
        ),
        Gap(4.w),
        GestureDetector(
          onTap: () {
            setState(() => _isTapped = !_isTapped);
            Navigator.pushNamed(context, PageRoutes.login.name);
          },
          child: Text(
            'Sign In',
            style: context.bodySmall?.copyWith(
              decoration: _isTapped ? TextDecoration.underline : null,
              decorationColor: context.color.secondary,
              decorationThickness: 1.sp,
              color: context.color.secondary,
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
            ),
          ),
        ),
      ],
    );
  }
}
