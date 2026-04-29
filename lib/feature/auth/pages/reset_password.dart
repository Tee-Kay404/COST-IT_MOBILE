import 'package:cost_it_mobile/feature/auth/views/reset_password_view.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  final ResetPasswordViewArguments args;
  const ResetPasswordPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return ResetPasswordView(args: args);
  }
}
