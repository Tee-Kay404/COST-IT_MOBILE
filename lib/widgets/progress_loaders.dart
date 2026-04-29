import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum LoaderType { popup, snack, sheet, none }

class Loaders {
  static BuildContext? currentContext;

  static Future<bool?> showModalLoading(context, {String? message}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        currentContext = context;
        return Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: [
                      const Center(
                        child: SizedBox(
                          height: 100,
                          width: 180,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message ?? "Loading",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<bool?> showSheetLoading(context, {String? message}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      // useRootNavigator: true,
      builder: (BuildContext context) {
        currentContext = context;
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.all(8.sp),
          backgroundColor: Colors.transparent,
          child: BottomLoader(message: message),
        );
      },
    );
  }

  static void showSnackLoading(BuildContext context, {String? message}) {
    ThemeData theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: context.theme.primaryColorLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.sp),
        ),
        duration: const Duration(seconds: 6),
        content: Row(
          children: <Widget>[
            SizedBox(
              height: 20,
              width: 20,
              child: Theme(
                data: theme.copyWith(
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    secondary: theme.colorScheme.secondary,
                  ),
                ),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.theme.primaryColorDark,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(message ?? 'Loading', style: context.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomLoader extends StatefulWidget {
  final String? message;

  const BottomLoader({super.key, this.message = "Loading"});

  @override
  State<BottomLoader> createState() => _BottomLoaderState();
}

class _BottomLoaderState extends State<BottomLoader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.sp,
            height: 40.sp,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 3.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.white.withOpacity(
                0.2,
              ), // optional subtle track
            ),
          ),
          Gap(30.sp),
          Expanded(
            child: Text(
              widget.message ?? "Loading",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularProgressLoader extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final bool adaptive;
  const CircularProgressLoader({
    super.key,
    this.color,
    this.adaptive = true,
    this.strokeWidth = 2,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: (adaptive)
            ? CircularProgressIndicator.adaptive(
                strokeWidth: strokeWidth,
                valueColor: (color != null)
                    ? AlwaysStoppedAnimation<Color>(color!)
                    : null,
              )
            : CircularProgressIndicator(
                strokeWidth: strokeWidth,
                valueColor: (color != null)
                    ? AlwaysStoppedAnimation<Color>(color!)
                    : null,
              ),
      ),
    );
  }
}
