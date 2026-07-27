import 'package:cost_it_mobile/app/global/utils/text_links.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/text_span.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';

void showAuthGateModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AuthGateSheet(),
  );
}

class _AuthGateSheet extends ConsumerWidget {
  const _AuthGateSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.fromLTRB(
        24.w,
        20.h,
        24.w,
        16.h + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Continue With',
            style: context.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          Gap(16.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: SocialLoginProvider.values.map((provider) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    provider.tapHandler(context, ref)?.call();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.41,
                    height: 50.h,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.h),
                      border: Border.all(
                        color: const Color(0xFF2D2C2C),
                        width: 1.5.w,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(provider.logoPath, height: 20.h),
                        Gap(10.w),
                        Text(
                          provider.name == 'google' ? 'Google' : 'Apple',
                          style: context.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            color: context.color.inverseSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Gap(24.h),

          SharedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, PageRoutes.login.name);
            },
            text: 'Log in with email or phone',
          ),
          Gap(15.h),

          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, PageRoutes.signUp.name);
            },
            child: Text.rich(
              TextSpan(
                text: "Don't have an account? ",
                style: context.bodyMedium?.copyWith(
                  color: context.color.inverseSurface,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: 'Create one now',
                    style: context.bodyMedium?.copyWith(
                      color: context.color.secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(18.h),

          TextSpanWithLink(
            textAlign: TextAlign.center,
            style: context.bodySmall?.copyWith(
              color: Colors.grey.shade500,
              height: 1.5,
              fontSize: 12.sp,
            ),
            linkColor: context.color.onPrimary,
            autoUnderlined: true,
            textSpanList: [
              const TextWithLinkModel(text: 'By continuing you agree to the\n'),
              TextLink.termsOfService.model,
              const TextWithLinkModel(text: ' and '),
              TextLink.privacyPolicy.model,
            ],
          ),
        ],
      ),
    );
  }
}
