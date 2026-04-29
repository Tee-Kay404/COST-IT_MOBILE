import 'dart:developer';


class Validators {
  static String? validatePassword(String? value) {
    RegExp passwordMatch = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_~+-])[A-Za-z\d@$!%*?&_~+-]{8,}$",
    );
    if (value == null || value.isEmpty) {
      return "Password field is required";
    }
    if (value.length < 6) {
      return "Password must at least 8 characters long";
    }
    if (!passwordMatch.hasMatch(value)) {
      return "Password must contain at least one uppercase letter, one number and a symbol";
    }
    return null;
  }

  static String? isEqualTo(
    String? value, {
    required String compareValue,
    String errorMessage = "Values do not match",
  }) {
    log("Comparing: $value to $compareValue");
    if (value != compareValue) {
      return errorMessage;
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'This field is required';
    final RegExp emailRegex = RegExp(
      r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email';
    }
    return null;
  }

  static String? isNotEmpty(dynamic value) {
    return (value == null || value.isEmpty) ? 'This field is required' : null;
  }

  static String? userName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    final regex = RegExp(r'^[a-zA-Z]{3,}$');

    if (!regex.hasMatch(value.trim())) {
      return 'Name must be at least 3 letters';
    }

    return null;
  }

 static String? validatePhone(String? value) {
    final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';

    if (digits.isEmpty) {
      return 'Enter phone number';
    }

    if (digits.length < 11) {
      return 'Phone number is incomplete';
    }

    if (digits.length > 11) {
      return 'Enter a valid 11-digit phone number';
    }

    if (!RegExp(r'^0\d{10}$').hasMatch(digits)) {
      return 'Enter a valid Nigerian phone number';
    }

    return null;
  }
}

