import 'package:cost_it_mobile/feature/auth/views/otp_user_verification_view.dart';
import 'package:flutter/material.dart';

class OTPVerificationPage extends StatelessWidget {
  final VerificationInfo info;
  const OTPVerificationPage({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(child: OTPVerificationView(info: info)),
    );
  }
}
