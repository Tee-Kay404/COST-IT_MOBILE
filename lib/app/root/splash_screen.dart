import 'package:cost_it_mobile/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shown while [appStateLoaderProvider] is resolving on cold start.
///
/// This is intentionally a plain widget, not a route — [CostItApp] renders
/// it directly as the `loading` branch of the top-level AsyncValue, so
/// there's no navigation involved and no risk of a double-splash flicker.
class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({super.key});

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 5),
            Center(
              child: Image.asset(
                AppImages.logoWhite, 
                         height: 240.h,
                width: 180.w,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(flex: 4),
            FadeTransition(
              opacity: _pulseAnimation,
              child: Text(
                'Loading',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}