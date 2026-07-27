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
  String get maskEmail {
    final parts = split('@');
    if (parts.length != 2) return this;

    final name = parts[0];
    final domain = parts[1];

    if (name.length <= 3) return this;

    final visibleStart = name.substring(0, 3);
    final maskedPart = '*' * (name.length - 3);

    return '$visibleStart$maskedPart@$domain';
  }

  /// Masks the middle digits of a phone number.
  /// Shows the first 3 characters and last 2 characters, masking everything
  /// in between with '*'.
  /// e.g. "08012345678" → "080*******78"
  String get maskPhone {
    final p = trim();
    if (p.length <= 5) return p;
    final prefix = p.substring(0, 3);
    final suffix = p.substring(p.length - 2);
    final stars = '*' * (p.length - 5);
    return '$prefix$stars$suffix';
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


String nameInitials(String first, String last) {
  final f = first.isNotEmpty ? first[0].toUpperCase() : '';
  final l = last.isNotEmpty ? last[0].toUpperCase() : '';
  return '$f$l'.ifEmpty('G');
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
