import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _fadeSlow;
  late Animation<Offset> _slide;
  late Animation<Offset> _slideSubtle;

  final List<String> headlines = [
    "Build With Confidence and Reliability.",
    "Plan Smart. Build Faster and Better.",
    "Everything Construction In One Place.",
    "No Stress. Just Progress All The Way.",
    "Track Costs. Stay On Budget.",
    "From Ground Up. We've Got You.",
    "Labour. Materials. One App.",
    "Your Blueprint For Success.",
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _fadeSlow = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );

    _slide = Tween<Offset>(begin: const Offset(0, 0.14), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.1, 0.9, curve: Curves.easeOutCubic),
          ),
        );

    _slideSubtle = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage(AppImages.getStarted), context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _glassCard(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 26.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            color: Colors.white.withOpacity(0.07),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1.2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.13),
                Colors.white.withOpacity(0.02),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: [
        Expanded(
          child: Container(height: 0.5, color: Colors.white.withOpacity(0.2)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            "or",
            style: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 12.sp,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: Container(height: 0.5, color: Colors.white.withOpacity(0.2)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final height = mq.size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.getStarted, fit: BoxFit.cover),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 0.65, 1.0],
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.92),
                  ],
                ),
              ),
            ),
          ),

          // Logo
          Positioned(
            top: -12.h,
            left: -10.w,
            child: FadeTransition(
              opacity: _fade,
              child: Image.asset(
                "assets/images/cost-it_logo.png",
                height: 180.h,
                width: 220.w,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(height * 0.09),

                  const Spacer(),

                  FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Welcome to ",
                              style: TextStyle(
                                fontSize: 50.sp,
                                fontWeight: FontWeight.w500,
                                color: context.color.surface,
                                height: 1.15,
                                letterSpacing: -3.2,
                              ),
                            ),
                            TextSpan(
                              text: "COST-IT",
                              style: TextStyle(
                                fontSize: 50.sp,
                                fontWeight: FontWeight.w800,
                                color: context.color.secondary,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Gap(16.h),

                  //
                  SizedBox(
                    height: height * 0.20,
                    child: FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: _slide,
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: headlines
                              .map(
                                (text) => TypewriterAnimatedText(
                                  text,
                                  speed: const Duration(milliseconds: 55),
                                  textStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 46.sp,
                                    fontWeight: FontWeight.w900,
                                    height: 1.12,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),

                  // accent bar
                  FadeTransition(
                    opacity: _fadeSlow,
                    child: Row(
                      children: [
                        Container(
                          height: 4.h,
                          width: 48.w,
                          decoration: BoxDecoration(
                            color: context.color.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Gap(6.w),
                        Container(
                          height: 4.h,
                          width: 14.w,
                          decoration: BoxDecoration(
                            color: context.color.secondary.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Gap(32.h),

                  //  Glass card
                  FadeTransition(
                    opacity: _fadeSlow,
                    child: SlideTransition(
                      position: _slideSubtle,
                      child: _glassCard(
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Your all-in-one construction partner.\nFrom labour to materials — at your fingertips.",
                              textAlign: TextAlign.center,
                              style: context.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.85),
                                height: 1.6,
                                letterSpacing: 0.1,
                              ),
                            ),

                            Gap(22.h),

                            // Primary CTA
                            SharedButton(
                              text: 'Get Started',

                              onPressed: () => Navigator.pushNamed(
                                context,
                                PageRoutes.login.name,
                              ),
                            ),

                            Gap(20.h),

                            _divider(),

                            Gap(20.h),

                            // Login / Sign Up row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildAuthButton(
                                  label: "Log In",
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    PageRoutes.login.name,
                                  ),
                                ),
                                Gap(12.w),
                                Container(
                                  width: 1,
                                  height: 18.h,
                                  color: Colors.white.withOpacity(0.25),
                                ),
                                Gap(12.w),
                                _buildAuthButton(
                                  label: "Sign Up",
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    PageRoutes.signUp.name,
                                  ),
                                  isPrimary: true,
                                ),
                              ],
                            ),

                            Gap(16.h),

                            // Guest link
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Continue as Guest",
                                    style: TextStyle(
                                      color: context.color.secondary,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                      decoration: TextDecoration.underline,
                                      decorationColor: context.color.secondary
                                          .withOpacity(0.5),
                                      decorationThickness: 1.2,
                                    ),
                                  ),
                                  Gap(4.w),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: context.color.secondary,
                                    size: 14.sp,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Gap(height * 0.04),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Log In / Sign Up
  Widget _buildAuthButton({
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isPrimary
              ? context.color.secondary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isPrimary
                ? context.color.secondary.withOpacity(0.6)
                : Colors.white.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: context.bodySmall?.copyWith(
            color: isPrimary ? context.color.secondary : Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
