import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AccountSuccessView extends StatefulWidget {
  const AccountSuccessView({super.key});

  @override
  State<AccountSuccessView> createState() => _AccountSuccessViewState();
}

class _AccountSuccessViewState extends State<AccountSuccessView>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _contentController;
  late Animation<double> _iconScale;
  late Animation<double> _iconFade;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _iconScale = CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    );
    _iconFade = CurvedAnimation(parent: _iconController, curve: Curves.easeOut);

    _contentFade = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
        );

    Future.delayed(const Duration(milliseconds: 200), () {
      _iconController.forward();
    });
    Future.delayed(const Duration(milliseconds: 450), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              ScaleTransition(
                scale: _iconScale,
                child: FadeTransition(
                  opacity: _iconFade,
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF6580CF).withOpacity(0.2),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 65.w,
                        height: 65.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6580CF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Gap(20.h),

              // Content
              FadeTransition(
                opacity: _contentFade,
                child: SlideTransition(
                  position: _contentSlide,
                  child: Column(
                    children: [
                      // Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6580CF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF6580CF),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Gap(6.w),
                            Text(
                              'Account Verified',
                              style: context.bodySmall?.copyWith(
                                color: context.color.onPrimary,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Gap(16.h),

                      Text(
                        "You're all set! 🎉",
                        style: context.bodyLarge,
                        textAlign: TextAlign.center,
                      ),

                      Gap(10.h),

                      Text(
                        'Your account has been successfully created.\nSign in to start building with Cost It.',
                        style: context.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: const Color(0xFF7A8199),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Gap(28.h),

                      // Info cards
                      _InfoRow(
                        iconColor: context.color.secondary,
                        iconBg: context.color.surface,
                        icon: Icons.star_rounded,
                        title: 'Welcome aboard',
                        subtitle: 'Your profile is ready to go',
                      ),
                      Gap(10.h),
                      _InfoRow(
                        iconColor: context.color.onPrimary,
                        iconBg: context.color.surface,
                        icon: Icons.lock_rounded,
                        title: 'Secure & verified',
                        subtitle: 'OTP verification complete',
                      ),

                      Gap(24.h),

                      // CTA Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            PageRoutes.login.name,
                            (route) => false,
                          ),
                          style: flatButtonStyle(
                            color: context.color.primary,
                            textColor: context.color.onSecondary,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            borderRadius: 14,
                          ).copyWith(
                            fixedSize: WidgetStatePropertyAll(Size(double.infinity, 50.h)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign In to Continue',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: context.color.onSecondary,
                                ),
                              ),
                              Gap(8.w),
                              Container(
                                width: 24.w,
                                height: 24.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.arrow_forward, size: 14.sp, color: context.color.onSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Gap(14.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Need help? ',
                            style: context.bodySmall?.copyWith(fontSize: 13.sp),
                          ),
                          Text(
                            ' Contact support',
                            style: context.bodySmall?.copyWith(
                              fontSize: 13.sp,
                              color: context.color.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.iconColor,
    required this.iconBg,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final Color iconColor;
  final Color iconBg;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: CostItColors.brightGrey.shade100,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 18.sp),
          ),
          Gap(12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.black : null,
                ),
              ),
              Gap(2.h),
              Text(
                subtitle,
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: CostItColors.brightGrey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
