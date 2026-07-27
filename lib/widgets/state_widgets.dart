import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final TextStyle? titleTextStyle, subtitleTextStyle;
  final Widget? icon;
  final Color? iconBackground;
  final Decoration? iconDecoration;
  final bool mini;
  final double iconSize;
  final VoidCallback? actionCallback;
  final Widget? actionWidget;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText = "Refresh",
    this.titleTextStyle,
    this.iconDecoration,
    this.subtitleTextStyle,
    this.iconSize = 80,
    this.iconBackground,
    this.mini = false,
    this.actionWidget,
    this.actionCallback,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(
          visible: icon != null,
          child: Container(
            width: (mini) ? null : iconSize.sp,
            height: (mini) ? null : iconSize.sp,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: iconDecoration ??
                BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconBackground ??
                        const Color.fromRGBO(196, 196, 196, 0.1)),
            child: Center(
              child: icon ??
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    size: iconSize.sp,
                  ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: titleTextStyle ??
                context.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      color: context.titleLarge?.color,
                    ),
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: subtitleTextStyle ??
                Theme.of(context).textTheme.bodyMedium!.copyWith(
                      height: 1.5,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withAlpha(180),
                      fontWeight: FontWeight.w300,
                    ),
          ),
        if (actionWidget != null) actionWidget!,
        if (actionCallback != null)
          Padding(
            padding: EdgeInsets.only(
                top: (mini)
                    ? 16.h
                    : (subtitle != null)
                        ? 24.h
                        : 16.h),
            child: SizedBox(
              height: 48.h,
              width: (mini) ? 120.w : null,
              child: TextButton(
                onPressed: actionCallback,
                style: flatTextButtonStyle(),
                child: Text(actionText!),
              ),
            ),
          )
      ],
    );
  }
}

class ErrorsWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextStyle? titleTextStyle, subtitleTextStyle;

  final String? actionText;
  final Widget? icon;
  final bool mini;
  final VoidCallback? actionCallback;

  const ErrorsWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.actionText,
    this.actionCallback,
    this.icon,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: title,
      mini: mini,
      subtitle: subtitle,
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
      icon: icon ??
          Icon(
            Icons.error,
            size: 50,
            color: Theme.of(context).colorScheme.error.withOpacity(0.1),
          ),
      actionText: actionText ?? "Refresh",
      actionCallback: actionCallback,
    );
  }
}
