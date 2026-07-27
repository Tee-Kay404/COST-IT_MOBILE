import 'package:cost_it_mobile/widgets/text_span.dart';
import 'package:url_launcher/url_launcher.dart';

enum TextLink {
  termsOfService,
  privacyPolicy,
}

extension TextLinkExtension on TextLink {
  String get url {
    switch (this) {
      case TextLink.termsOfService:
        return 'https://cost-it-j1z9.onrender.com/cost-it/terms';
      case TextLink.privacyPolicy:
        return 'https://cost-it-j1z9.onrender.com/cost-it/privacy';
    }
  }

  String get text {
    switch (this) {
      case TextLink.termsOfService:
        return 'Terms of Service';
      case TextLink.privacyPolicy:
        return 'Privacy Policy';
    }
  }

  Future<bool> launch() async {
    final uri = Uri.parse(url);
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  TextWithLinkModel get model => TextWithLinkModel(
        text: text,
        textLink: this,
      );
}
