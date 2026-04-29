import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpTextfield extends StatelessWidget {
  const OtpTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    // OTP controller
    final otpController = TextEditingController();
    // OTP textfieldshape
    return Container(
      height: 90.h,
      width: 60.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade500,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      // OTP textfield
      child: Center(
        child: TextField(
          controller: otpController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          // maxLengthEnforcement: MaxLengthEnforcement.none,
          maxLength: 1,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
            counterText: "",
            // hin
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
