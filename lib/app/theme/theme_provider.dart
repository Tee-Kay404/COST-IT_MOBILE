// import 'package:flutter/material.dart';
// import 'package:facilpay/app/theme/theme.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ThemeNotifier extends ChangeNotifier {
//   ThemeData _currentTheme;
//   final String key = 'theme';
//   SharedPreferences? _prefs;

//   ThemeNotifier({required bool initialDarkMode})
//       : _currentTheme = initialDarkMode ? AppTheme.darkMode : AppTheme.lightMode;

//   ThemeData get themeData => _currentTheme;

//   bool get isDarkMode => _currentTheme == AppTheme.darkMode;

//   Future<void> _initPrefs() async {
//     _prefs ??= await SharedPreferences.getInstance();
//   }

//   Future<void> _loadFromPrefs() async {
//     await _initPrefs();
//     bool isDark = _prefs?.getBool(key) ?? false;
//     _currentTheme = isDark ? AppTheme.darkMode : AppTheme.lightMode;
//     notifyListeners();
//   }

//   Future<void> _saveToPrefs() async {
//     await _initPrefs();
//     _prefs?.setBool(key, isDarkMode);
//   }

//   void toggleTheme() {
//     _currentTheme = isDarkMode ? AppTheme.lightMode : AppTheme.darkMode;
//     notifyListeners();
//     _saveToPrefs();
//   }
// }
