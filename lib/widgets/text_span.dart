import 'package:cost_it_mobile/extensions/textstyle_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TextSpanWithLink extends StatelessWidget {
  final List<TextWithLinkModel> textSpanList;
  final double? height;
  final TextAlign textAlign;
  final TextStyle? style;
  final Color linkColor;
  final TextStyle? linkStyle;
  final bool autoUnderlined;
  const TextSpanWithLink({
    super.key,
    required this.textSpanList,
    this.height,
    this.style,
    this.linkStyle,
    this.linkColor = Colors.blue,
    this.autoUnderlined = true,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: style,
        children: textSpanList.map((textSpan) {
          TextStyle textStyle =
              (textSpan.link == null && textSpan.onTap == null)
              ? ((style ?? Theme.of(context).textTheme.bodyMedium!).copyWith(
                  height: height,
                ))
              : ((linkStyle ??
                            style ??
                            Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                            ))
                        .copyWith(height: height))
                    .copyWith(color: linkColor);
          if (autoUnderlined &&
              (textSpan.link != null || textSpan.onTap != null)) {
            textStyle = textStyle.underlined(color: linkColor, distance: 1);
          }
          return TextSpan(
            text: textSpan.text,
            style: textStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (textSpan.link != null) {
                  final uri = Uri.parse(textSpan.link!);

                  final success = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );

                  if (!success) {
                    debugPrint('Could not launch $uri');
                  }
                } else if (textSpan.onTap != null) {
                  textSpan.onTap!();
                }
              },
          );
        }).toList(),
      ),
    );
  }
}

class TextWithLinkModel {
  final String text;
  final String? link;
  final VoidCallback? onTap;
  const TextWithLinkModel({required this.text, this.link, this.onTap});
}
