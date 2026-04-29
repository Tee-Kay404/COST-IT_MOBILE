extension StringExtension on String {
  String get toJpg => "assets/images/$this.jpg";
  String get toPng => "assets/images/$this.png";
  String get toSvg => "assets/icons/$this.svg";

  String lastChars(int n) => substring(length - n);

  String get capitalize {
    if (isEmpty) return '';
    String val = toLowerCase();
    return "${val[0].toUpperCase()}${val.substring(1)}";
  }

  String get titleCase {
    if (isEmpty) return '';
    return split(' ').map((str) => str.capitalize).join(' ');
  }

  String get stripExtraQuotes {
    return trim().replaceAll('"', '');
  }
String maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2) return email;

  final name = parts[0];
  final domain = parts[1];

  if (name.length <= 3) return email;

  final visibleStart = name.substring(0, 3);
  final maskedPart = '*' * (name.length - 3);

  return '$visibleStart$maskedPart@$domain';
}

  String get initials {
    if (isEmpty) return '';
    return split(' ').map((str) => str[0].capitalize).join('');
  }

  String pluralize(bool Function() checkCallback, {String? plural}) {
    if (checkCallback()) {
      return plural ?? "${this}s";
    } else {
      return this;
    }
  }

  static String camelToSentence(String text) {
    var result = text.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), r" ");
    var finalResult = result[0].toUpperCase() + result.substring(1);
    return finalResult;
  }

  bool get isUppercase {
    return this == toUpperCase();
  }
}
