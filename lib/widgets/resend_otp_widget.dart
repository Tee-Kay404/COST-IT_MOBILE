import 'dart:async';
import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/dialog/scaffold_message.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ResendOTPWidget extends StatefulWidget {
  final Future<bool> Function() onPress;
  final int timeLimit;
  final int resendThreshold;
  final String? introText;

  const ResendOTPWidget({
    super.key,
    required this.onPress,
    this.timeLimit = 60,
    this.resendThreshold = 3,
    this.introText,
  });

  @override
  State<ResendOTPWidget> createState() => _ResendOTPWidgetState();
}

class _ResendOTPWidgetState extends State<ResendOTPWidget> {
  bool _canResend = true;
  int _seconds = 0;
  int _resendCount = 0;
  Timer? _timer;
  bool isBlocked = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _canResend = false;
      _seconds = widget.timeLimit;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  void _handleResend() async {
    print("Resend count: $_resendCount");
    if (_resendCount >= widget.resendThreshold) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          ScaffoldMessage(
            message: 'Too many request, try again',
            context: context,
          ),
        );
      }

      setState(() {
        isBlocked = true;
        _canResend = false;
      });

      // optional: unblock after some time
      Future.delayed(Duration(seconds: widget.timeLimit * 2), () {
        if (!mounted) return;
        setState(() {
          isBlocked = false;
          _canResend = true;
        });
      });

      return;
    }

    final success = await widget.onPress();

    if (success) {
      _resendCount++;
      _startTimer();
    }
  }

  String get _timeFormatted {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.introText ?? "Didn't receive the code?",
          style: context.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
          ),
        ),

        Gap(6.w),

        GestureDetector(
          onTap: _canResend ? _handleResend : null,
          child: Text(
            isBlocked
                ? "Resend"
                : _canResend
                ? "Resend"
                : "Resend in $_timeFormatted",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: (_canResend || isBlocked)
                  ? CostItColors.error
                  : context.color.secondary,
            ),
          ),
        ),

        // if (_resendCount >= widget.resendThreshold)
        //   Padding(
        //     padding: EdgeInsets.only(top: 6.h),
        //     child: Text(
        //       "Too many requests. Please wait.",
        //       style: TextStyle(fontSize: 12.sp, color: CostItColors.error),
        //     ),
        //   ),
      ],
    );
  }
}
