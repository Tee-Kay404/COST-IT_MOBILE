import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';


String formatQuantity(
  double? v, {
  int minDecimalPlaces = 0,
  int maxDecimalPlaces = 2,
}) {
  assert(minDecimalPlaces <= maxDecimalPlaces);
  if (v == null) return '';

  NumberFormat formatter = NumberFormat();
  formatter.minimumFractionDigits = minDecimalPlaces;
  formatter.maximumFractionDigits = maxDecimalPlaces;
  return formatter.format(v);
}

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (math.log(bytes) / math.log(1024)).floor();
  return '${(bytes / math.pow(1024, i)).toStringAsPrecision(decimals)}${suffixes[i]}';
}

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

String formatPrice(double price) {
  if (price >= 1000000) {
    double millions = price / 1000000;
    String formatted = millions.toStringAsFixed(1);
    if (formatted.endsWith('.0')) {
      formatted = formatted.substring(0, formatted.length - 2);
    }
    return '${formatted}M';
  }
  
  final formatter = NumberFormat("#,##0", "en_US");
  return formatter.format(price);
}

int parseInt(String? value, {int defaultValue = 0}) {
  return int.tryParse(value ?? '') ?? defaultValue;
}

String parseDate(
  DateTime? obj, {
  String emptyText = "NOT SET",
  String? localeString,
}) {
  if (obj == null) return emptyText;
  String? dlocale = localeString;
  return DateFormat.yMMMd(dlocale).format(obj);
}

String parseDate2(DateTime? obj) {
  if (obj == null) return "Not Set";
  return DateFormat('d MMM y').format(obj);
}

String parseDateTime(
  DateTime? obj, {
  String emptyText = "Not set",
  String? localeString,
}) {
  if (obj != null) {
    String? dlocale = localeString;
    return DateFormat.yMMMd(dlocale).add_jm().format(obj);
  }
  return emptyText;
}

String parseTime(
  DateTime? obj, {
  String emptyText = "Not set",
  String? localeString,
}) {
  if (obj != null) {
    return DateFormat.jm().format(obj);
  }
  return emptyText;
}

String parseDateTimeWithDay(DateTime? obj, {String emptyText = "Not set"}) {
  if (obj == null) return emptyText;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateToCheck = DateTime(obj.year, obj.month, obj.day);

  if (dateToCheck == today) {
    return "Today at ${DateFormat.jm().format(obj)}";
  } else if (dateToCheck == yesterday) {
    return "Yesterday at ${DateFormat.jm().format(obj)}";
  } else {
    return "${DateFormat('MMM d').format(obj)} at ${DateFormat.jm().format(obj)}";
  }
}

String extractMessage(Map<String, dynamic> data) {
  try {
    final msg = data['message'] ?? data['error'];

    if (msg is String) return msg;

    if (msg is List && msg.isNotEmpty) {
      return msg.first.toString();
    }

    if (data['errors'] is Map) {
      final errors = data['errors'] as Map;
      return errors.values.first.toString();
    }
  } catch (_) {}

  return _fallback;
}
const _fallback = 'Something went wrong, please try again';

String maskedString(String value, {int maskLength = 4, bool maskEnd = false}) {
  if (value.length <= maskLength) return value;
  if (maskEnd) {
    int startIndex = value.length - maskLength;
    String maskedValue = value.substring(0, startIndex);
    maskedValue += '*' * maskLength;
    return maskedValue;
  } else {
    return '${value.substring(0, maskLength)}${'*' * maskLength}${value.substring(value.length - maskLength)}';
  }
}

Future<String> uint8ListToFilePath(Uint8List data, String fileName) async {
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsBytes(data);
  return file.path;
}
