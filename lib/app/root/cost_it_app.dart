import 'dart:developer';

import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/app/root/splash_screen.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'root_app.dart';

/// Root of the widget tree.
///
/// Responsible only for one decision: what to show while [appStateLoaderProvider]
/// is loading, if it fails, and what to hand off to once app state is ready.
/// All "real app" concerns (navigation, MaterialApp config, error widget
/// overrides, notification/deep-link wiring) live in [RootAppWidget] —
/// this widget never needs to change when those grow.
class CostItApp extends ConsumerWidget {
  const CostItApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStateAsync = ref.watch(appStateLoaderProvider);

    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: Size(411.43, 892.57),
      builder: (context, child) {
        return appStateAsync.when(
          loading: () => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightMode,
            home: const AppSplashScreen(),
          ),
          error: (error, stack) {
            log('Error starting app: $error', stackTrace: stack);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightMode,
              home: Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Text(
                      'Something went wrong starting the app.\nPlease restart.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                    ),
                  ),
                ),
              ),
            );
          },
          data: (appState) => RootAppWidget(appState: appState),
        );
      },
    );
  }
}