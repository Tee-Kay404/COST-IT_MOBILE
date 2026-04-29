import 'package:bot_toast/bot_toast.dart';
import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/global/config.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: CostItColors.primary2,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  AppConfig(environment: Environment.dev);
  runApp(ProviderScope(child: CostItApp()));
}

class CostItApp extends StatelessWidget {
  const CostItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: Size(411.43, 892.57),
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightMode,
        builder: BotToastInit(),
        initialRoute: PageRoutes.onBoarding.name,
        onGenerateRoute: onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
