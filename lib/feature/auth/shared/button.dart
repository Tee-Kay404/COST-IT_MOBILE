import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingButton extends StatefulWidget {
  final String text;
  final Color? disabled;
  final Future<void> Function()? onTap;

  const LoadingButton({
    super.key,
    required this.text,
    this.disabled,
    this.onTap,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool isLoading = false;
  Future<void> _onTap() async {
    if (widget.onTap == null) return;

    setState(() {
      isLoading = true;
    });
    try {
      await widget.onTap!();
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final background = (widget.onTap == null)
        ? (widget.disabled ?? Colors.grey) // true disabled
        : context.color.primary; // enabled
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.sp),
        ),
        splashFactory: NoSplash.splashFactory,
        backgroundColor: background,
        foregroundColor: widget.disabled,
        elevation: 1,
        alignment: Alignment.center,
        minimumSize: Size(double.infinity.w, 50),
        side: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      ),
      onPressed: widget.onTap == null ? null : _onTap,
      child: Center(
        child: isLoading
            ? SizedBox(
                height: 30.h,
                width: 30.h,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 5.w,
                  backgroundColor: context.color.primary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.color.surface,
                  ), //
                ),
              )
            : Text(
                widget.text.toString(),
                style: context.bodyMedium?.copyWith(
                  color: context.color.surface,
                ),
              ),
      ),
    );
  }
}
