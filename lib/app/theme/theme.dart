import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static final baseTheme = ThemeData(
  primaryColor: Color.from(alpha: 1, red: 0.086, green: 0.608, blue: 0.984),
  fontFamily: "Satoshi", 
  useMaterial3: true,
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    filled: false,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF199FFC),
  ).copyWith(primary: Color(0xFF199FFC), brightness: Brightness.light),
);

  static final ThemeData lightMode = baseTheme.copyWith(
    colorScheme: baseTheme.colorScheme.copyWith(
      inversePrimary: Colors.white,
      surface: Color(0xFFF0F3FF),
      primary: Color(0xFF6580CF),
      secondary: Color(0xFFF6D460),
      brightness: Brightness.light,
    ),
    primaryColorLight: CostItColors.brightGrey.shade100,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Color(0xFF17BEFC),
    primaryColorDark: Colors.black,
    focusColor: Colors.blueAccent,

    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF17BEFC),

      systemOverlayStyle: SystemUiOverlayStyle.dark,
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
      titleTextStyle: TextStyle(
        fontSize: 16.h,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontStyle: FontStyle.italic,
      ),
    ),
    // IconTheme customization
    actionIconTheme: ActionIconThemeData(
      drawerButtonIconBuilder: (context) => Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          color: Color(0xFF17BEFC),

          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Icon(Icons.arrow_back_ios_new, color: Colors.blueAccent),
      ),
    ),

    // TextThemes
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        alignment: Alignment.center,
        minimumSize: WidgetStatePropertyAll(Size(80.w, 50.h)),
        padding: WidgetStatePropertyAll(EdgeInsets.all(8.sp)),
        splashFactory: NoSplash.splashFactory,
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(25.sp),
            side: BorderSide(style: BorderStyle.none),
          ),
        ),
      ),
    ),
  );
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get text => theme.textTheme;

  ColorScheme get color => theme.colorScheme;
  TextStyle? get bodyLarge => text.bodyLarge;
  TextStyle? get bodyMedium => text.bodyMedium;
  TextStyle? get bodySmall => text.bodySmall;
}
