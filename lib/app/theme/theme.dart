import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/app/global/styles/styles.dart';

class AppTheme {
  static const String _fontFamily = 'Satoshi';

  static TextTheme get _baseTextTheme => TextTheme(
    titleLarge: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
    titleSmall: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
    bodySmall: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
  );

  static TextTheme get _lightTextTheme => _baseTextTheme.apply(
    fontFamily: _fontFamily,
    bodyColor: Colors.black,
    displayColor: Colors.black,
  );

  static TextTheme get _darkTextTheme => _baseTextTheme.apply(
    fontFamily: _fontFamily,
    bodyColor: Colors.white,
    displayColor: Colors.white,
  );

  static TextStyle _appBarTitleStyle(Color color) => TextStyle(
    fontSize: 16.h,
    fontWeight: FontWeight.w600,
    color: color,
    fontStyle: FontStyle.italic,
  );

  static ThemeData get baseTheme => ThemeData(
    fontFamily: _fontFamily,
    useMaterial3: true,
    primaryColor: const Color(0xFF199FFC),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      filled: false,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF199FFC),
    ).copyWith(primary: const Color(0xFF199FFC), brightness: Brightness.light),
  );

  static ThemeData get lightMode => baseTheme.copyWith(
    textTheme: _lightTextTheme, // ← one line, done
    colorScheme: baseTheme.colorScheme.copyWith(
      onPrimary: CostItColors.primary,
      inversePrimary: Colors.white,
      inverseSurface: Colors.black,
      surface: const Color(0xFFF0F3FF),
      primary: const Color(0xFF6580CF),
      secondary: const Color(0xFFFFC107),
      onSecondary: CostItColors.primary,
      brightness: Brightness.light,
    ),
    primaryColorLight: CostItColors.brightGrey.shade100,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    primaryColor: const Color(0xFF17BEFC),
    primaryColorDark: Colors.black,
    focusColor: CostItColors.primary,
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF6580CF),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: const Color(0xFF6580CF),
      ),
      actionsPadding: EdgeInsets.only(right: 15.sp),
      actionsIconTheme: IconThemeData(
        size: 24.sp,
        color: Colors.white,
        fill: 1.0,
      ),
      iconTheme: IconThemeData(
        size: 24.sp,
        color: CostItColors.brightGrey.shade400,
        fill: 1.0,
      ),
      titleTextStyle: _appBarTitleStyle(Colors.white),
    ),
    textButtonTheme: TextButtonThemeData(style: flatTextButtonStyle()),
    elevatedButtonTheme: ElevatedButtonThemeData(style: flatButtonStyle()),
    outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonStyle()),
    filledButtonTheme: FilledButtonThemeData(style: flatButtonStyle()),
  );

  static ThemeData get darkMode => baseTheme.copyWith(
    textTheme: _darkTextTheme,
    brightness: Brightness.dark,
    colorScheme: baseTheme.colorScheme.copyWith(
      onPrimary: CostItColors.secondaryDark,
      inversePrimary: Colors.black,
      surface: const Color(0xFF1A1D2E),
      primary: CostItColors.primaryDark,
      inverseSurface: const Color(0xFFFFFFFF),
      secondary: const Color(0xFFCCAC00),
      onSecondary: CostItColors.white,
      brightness: Brightness.dark,
    ),
    primaryColorLight: CostItColors.brightGrey.shade900,
    scaffoldBackgroundColor: const Color(0xFF111320),
    primaryColor: CostItColors.primaryDark,
    primaryColorDark: Colors.white,
    focusColor: CostItColors.white,
    cardColor: const Color(0xFF1A1D2E),
    canvasColor: const Color(0xFF111320),
    appBarTheme: AppBarTheme(
      backgroundColor: CostItColors.primaryDark,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: CostItColors.primaryDark,
      ),
      actionsPadding: EdgeInsets.only(right: 15.sp),
      actionsIconTheme: IconThemeData(
        size: 24.sp,
        color: CostItColors.white,
        fill: 1.0,
      ),
      iconTheme: IconThemeData(
        size: 24.sp,
        color: CostItColors.brightGrey.shade300,
        fill: 1.0,
      ),
      titleTextStyle: _appBarTitleStyle(Colors.white),
    ),
    textButtonTheme: TextButtonThemeData(style: flatTextButtonStyle()),
    elevatedButtonTheme: ElevatedButtonThemeData(style: flatButtonStyle()),
    outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonStyle()),
    filledButtonTheme: FilledButtonThemeData(style: flatButtonStyle()),
    dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF1A1D2E)),
  );
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get text => theme.textTheme;
  ColorScheme get color => theme.colorScheme;
  TextStyle? get titleLarge => text.titleLarge;
  TextStyle? get titleMedium => text.titleMedium;
  TextStyle? get titleSmall => text.titleSmall;
  TextStyle? get bodyLarge => text.bodyLarge;
  TextStyle? get bodyMedium => text.bodyMedium;
  TextStyle? get bodySmall => text.bodySmall;
}
