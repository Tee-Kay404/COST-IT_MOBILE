import 'package:cost_it_mobile/feature/auth/views/otp_reset_password_view.dart';
import 'package:flutter/material.dart';

class OTPResetPasswordPage extends StatelessWidget {
  final OTPResetPasswordViewArguments args;
  const OTPResetPasswordPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return OTPResetPasswordView(args: args);
  }
}