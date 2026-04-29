import 'package:cost_it_mobile/Screens/onBoarding/get_started.dart';
import 'package:cost_it_mobile/feature/auth/pages/account_success_page.dart';
import 'package:cost_it_mobile/feature/auth/pages/complete_profile_page.dart';
import 'package:cost_it_mobile/feature/auth/pages/forgot_password.dart';
import 'package:cost_it_mobile/feature/auth/pages/login.dart';
import 'package:cost_it_mobile/feature/auth/pages/otp_reset_page.dart';
import 'package:cost_it_mobile/feature/auth/pages/otp_verification.dart';
import 'package:cost_it_mobile/feature/auth/pages/reset_password.dart';
import 'package:cost_it_mobile/feature/auth/pages/reset_password_success.dart';
import 'package:cost_it_mobile/feature/auth/pages/sign_up.dart';
import 'package:cost_it_mobile/feature/auth/views/otp_reset_password_view.dart';
import 'package:cost_it_mobile/feature/auth/views/otp_user_verification_view.dart';
import 'package:cost_it_mobile/Screens/dashboard.dart';
import 'package:cost_it_mobile/Screens/onBoarding/onboarding_pages.dart';
import 'package:cost_it_mobile/feature/auth/views/reset_password_view.dart';
import 'package:flutter/material.dart';

enum PageRoutes {
  onBoarding,
  login,
  signUp,
  forgotPassword,
  dashBoard,
  otpVerification,
  getStarted,
  accountSuccess,
  otpResetPassword,
  resetPassword,
  resetPasswordSuccess,
  completeProfile,
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  WidgetBuilder builder;
  switch (PageRoutesExtension.fromString(settings.name)) {
    case PageRoutes.onBoarding:
      builder = (ctx) => OnBoardingPage();
      break;
    case PageRoutes.login:
      builder = (ctx) => LoginPage();
      break;
    case PageRoutes.signUp:
      builder = (ctx) => SignUpPage();
      break;
    case PageRoutes.dashBoard:
      builder = (ctx) => DashBoard();
      break;
    case PageRoutes.otpVerification:
      builder = (ctx) =>
          OTPVerificationPage(info: settings.arguments as VerificationInfo);
      break;
    case PageRoutes.forgotPassword:
      builder = (ctx) => ForgotPasswordPage();
    case PageRoutes.getStarted:
      builder = (ctx) => GetStarted();
      break;
    case PageRoutes.accountSuccess:
      builder = (ctx) => AccountSuccessPage();
      break;
    case PageRoutes.otpResetPassword:
      builder = (ctx) => OTPResetPasswordPage(
        args: settings.arguments as OTPResetPasswordViewArguments,
      );
      break;
    case PageRoutes.resetPassword:
      builder = (ctx) => ResetPasswordPage(args: settings.arguments as ResetPasswordViewArguments);
      break;
    case PageRoutes.resetPasswordSuccess:
      builder = (ctx) => ResetPasswordSuccessPage();
      break;
    case PageRoutes.completeProfile:
      builder = (ctx) => CompleteProfilePage();
      break;
    default:
      builder = (ctx) => OnBoardingPage();
  }
  return MaterialPageRoute(builder: builder, settings: settings);
}

extension PageRoutesExtension on PageRoutes {
  static PageRoutes? fromString(String? value) {
    var route = PageRoutes.values.where((route) => route.name == value);
    if (route.isNotEmpty) {
      return route.first;
    } else {
      return null;
    }
  }
}
