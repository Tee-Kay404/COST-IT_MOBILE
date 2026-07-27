import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/errors/error_handler.dart';
import 'package:cost_it_mobile/app/global/utils/exception.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/extensions/string_extension.dart';
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

typedef VerificationInfo = ({
  String firstName,
  String lastName,
  String email,
  String phoneNumber,
  String password,
  PageRoutes nextRoute,
});

class OTPVerificationView extends ConsumerStatefulWidget {
  final VerificationInfo info;

  const OTPVerificationView({super.key, required this.info});

  @override
  ConsumerState<OTPVerificationView> createState() =>
      _OTPVerificationViewState();
}

class _OTPVerificationViewState extends ConsumerState<OTPVerificationView> {
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

  Future<void> _verify() async {
    final otp = _pinController.text;

    if (otp.length != 4) return;

    final payload = {
      "firstName": widget.info.firstName,
      "lastName": widget.info.lastName,
      "email": widget.info.email,
      "phoneNumber": widget.info.phoneNumber,
      "password": widget.info.password,
      "token": otp,
    };
    await futureProgressCaller(
      context,
      loaderType: LoaderType.sheet,
      loadingMessage: "Verifying...",
      computation: () => ref.read(verifyFutureProvider(payload).future),
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
        Navigator.pushNamedAndRemoveUntil(
          context,
          widget.info.nextRoute.name,
          ModalRoute.withName("/"),
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

    final payload = {
      "firstName": widget.info.firstName,
      "lastName": widget.info.lastName,
      "email": widget.info.email,
      "phoneNumber": widget.info.phoneNumber,
      "password": widget.info.password,
    };

    return futureProgressCaller(
      context,
      loaderType: LoaderType.snack,
      loadingMessage: "Sending code...",
      computation: () => ref.read(resendOTPFutureProvider(payload).future),
      onError: (error) {
        ErrorHandler.handle(context, error);
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
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackArrowButton(),
                ),

                SizedBox(height: 10.h),

                Center(
                  child: Image.asset(
                    AppImages.verifyEmail,
                    width: size.width * 0.4,
                    height: size.height * 0.18,
                  ),
                ),

                SizedBox(height: 10.h),

                Text(
                  'E-mail Verification',
                  style: context.bodyLarge?.copyWith(
                    fontSize: 28.sp,
                    color: context.color.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 10.h),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: context.bodySmall?.copyWith(
                      color: CostItColors.brightGrey.shade500,
                    ),
                    children: [
                      TextSpan(text: "We've sent a one-time password to "),
                      TextSpan(
                        text: widget.info.email.maskEmail,
                        style: context.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.color.primary,
                        ),
                      ),
                      const TextSpan(
                        text: ". Please enter the code to verify your email.",
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                OTPField(
                  cursorColor: _hasError
                      ? CostItColors.error
                      : context.color.primary,
                  controller: _pinController,
                  focusNode: _focusNode,
                  forceErrorState: _hasError,
                  onCompleted: (_) => _verify(),
                  onChanged: (_) {
                    if (_hasError) {
                      setState(() {
                        _hasError = false;
                        _errorText = '';
                      });
                    }
                  },
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

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            children: [
              LoadingButton(text: "Verify", onTap: _verify),

              SizedBox(height: 12.h),

              Center(
                child: ResendOTPWidget(
                  timeLimit: 60,
                  resendThreshold: 4,
                  onPress: _resendOTP,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20.h),
      ],
    );
  }
}
