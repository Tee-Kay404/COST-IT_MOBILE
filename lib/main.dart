import 'package:cost_it_mobile/app/global/utils/config.dart';
import 'package:cost_it_mobile/app/root/cost_it_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait only — consistent MVP experience across all phones.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Default system UI style — status bar is primary-colored with white icons.
  // Screens that extend behind the AppBar (e.g. product details) override this
  // locally via AnnotatedRegion. Login & signup also override via AnnotatedRegion.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF6580CF),          // light-theme primary
      statusBarIconBrightness: Brightness.light,  // white icons on primary
      systemNavigationBarColor: Color(0xFF6580CF),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  AppConfig(environment: Environment.dev);

  runApp(const ProviderScope(child: CostItApp()));
}