import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/dialog/scaffold_message.dart';
import 'package:cost_it_mobile/app/global/utils/exception.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:cost_it_mobile/feature/auth/shared/button.dart';
import 'package:cost_it_mobile/feature/auth/shared/loaders.dart';
import 'package:cost_it_mobile/feature/auth/utils/otp_field.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/dark_round_button.dart';
import 'package:cost_it_mobile/widgets/progress_loaders.dart';
import 'package:cost_it_mobile/widgets/resend_otp_widget.dart';
import 'package:cost_it_mobile/widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

typedef OTPResetPasswordViewArguments = ({
  String identifier,
  PageRoutes nextRoute,
});

class OTPResetPasswordView extends ConsumerStatefulWidget {
  final OTPResetPasswordViewArguments args;
  const OTPResetPasswordView({super.key, required this.args});

  @override
  ConsumerState<OTPResetPasswordView> createState() =>
      _OTPResetPasswordViewState();
}

class _OTPResetPasswordViewState extends ConsumerState<OTPResetPasswordView>
    with SingleTickerProviderStateMixin {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  bool _hasError = false;
  String _errorText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = _pinController.text;
    if (otp.length != 4) return;

    final payload = {"identifier": widget.args.identifier, "otp": otp};

    await futureProgressCaller(
      context,
      loaderType: LoaderType.sheet,
      loadingMessage: "Verifying OTP...",
      computation: () =>
          ref.read(confirmForgotPasswordOTPProvider(payload).future),
      onError: (error) {
        final ex = error is GlobalException ? error : null;
        final backendMessage = ex?.message ?? 'Invalid OTP, please try again';

        setState(() {
          _hasError = true;
          _errorText = backendMessage;
        });
        _pinController.clear();
        _focusNode.requestFocus();
        return false;
      },
    ).then((result) {
      if (result == true) {
        Navigator.pushNamed(
          context,
          PageRoutes.resetPassword.name,
          arguments: (
            identifier: widget.args.identifier,
            otp: otp,
            nextRoute: widget.args.nextRoute,
          ),
        );
      } else {
        setState(() {
          _hasError = true;
          _errorText = "Invalid OTP";
        });

        _pinController.clear();
        _focusNode.requestFocus();
      }
    });
  }

  Future<bool> _resendOTP({bool initial = false}) async {
    setState(() {
      _hasError = false;
      _errorText = '';
    });
    _pinController.clear();

    final payload = {"identifier": widget.args.identifier};

    return futureProgressCaller(
      context,
      loaderType: LoaderType.snack,
      loadingMessage: "Sending code...",
      computation: () =>
          ref.read(resendForgotPasswordOTPProvider(payload).future),
      onError: (error) {
        final ex = error is GlobalException ? error : null;
        final msg = ex?.message ?? 'Failed to resend OTP';
        showErrorExceptionToast(context, msg);
        return false;
      },
    ).then((value) {
      if (value == true && !initial) {
        showSuccessToast(context, "OTP sent successfully");
      }
      return value == true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20.h),
              BackArrowButton(),
              Gap(20.h),
              Text(
                'Reset Password',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 25.sp,
                  color: context.color.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your privacy is our priority.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Gap(20.h),
                  Text(
                    "Please enter the OTP sent to your email or SMS  to reset your password.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: CostItColors.brightGrey.shade600,
                    ),
                  ),
                ],
              ),
              Gap(40.h),

              Center(
                child: OTPField(
                  cursorColor: _hasError
                      ? CostItColors.error
                      : context.color.primary,
                  controller: _pinController,
                  focusNode: _focusNode,
                  forceErrorState: _hasError,
                  onCompleted: (_) => _verifyOtp(),
                  onChanged: (_) {
                    if (_hasError) {
                      setState(() {
                        _hasError = false;
                        _errorText = '';
                      });
                    }
                  },
                ),
              ),

              if (_hasError) ...[
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    _errorText,
                    style: context.bodySmall?.copyWith(
                      color: CostItColors.error,
                    ),
                  ),
                ),
              ],

              Spacer(),

              //  Button
              LoadingButton(text: 'Verify', onTap: _verifyOtp),
              Gap(5.h),
              Center(
                child: ResendOTPWidget(
                  timeLimit: 60,
                  resendThreshold: 4,
                  onPress: _resendOTP,
                ),
              ),
              Gap(15.h),
            ],
          ),
        ),
      ),
    );
  }
}
