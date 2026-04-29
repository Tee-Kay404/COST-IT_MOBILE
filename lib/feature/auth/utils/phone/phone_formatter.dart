import 'package:flutter/services.dart';

class NigerianPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Strip leading zero — package handles the +234 prefix,
    // so the local part should never start with 0
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }

    // Cap at 10 digits (local number without leading zero)
    if (digits.length > 10) {
      digits = digits.substring(0, 10);
    }

    // Format for display: 803 344 5577
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) buffer.write(' ');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}