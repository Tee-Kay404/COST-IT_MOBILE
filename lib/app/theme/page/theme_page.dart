import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/app/theme/components/theme_tile.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/shared/appBar/costit_back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ThemesPage extends ConsumerWidget {
  const ThemesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeModeProvider);

    final options = [
      ThemeOption(
        mode: ThemeMode.light,
        title: 'Light Mode',
        subtitle: 'Clean and bright interface',
        icon: Icons.wb_sunny_rounded,
      ),
      ThemeOption(
        mode: ThemeMode.dark,
        title: 'Dark Mode',
        subtitle: 'Easier on the eyes at night',
        icon: Icons.nightlight_round,
      ),
      ThemeOption(
        mode: ThemeMode.system,
        title: 'System Default',
        subtitle: 'Follows your device settings',
        icon: Icons.brightness_auto_rounded,
      ),
    ];

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: const CostItBackAppBar(title: 'Appearance'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: context.color.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    currentMode == ThemeMode.light
                        ? Icons.wb_sunny_rounded
                        : currentMode == ThemeMode.dark
                        ? Icons.nightlight_round
                        : Icons.brightness_auto_rounded,
                    size: 14.sp,
                    color: context.color.onPrimary,
                  ),
                  Gap(6.w),
                  Text(
                    currentMode == ThemeMode.light
                        ? 'Light Mode active'
                        : currentMode == ThemeMode.dark
                        ? 'Dark Mode active'
                        : 'System Default active',
                    style: context.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: context.color.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Gap(20.h),

            ...options.map(
              (opt) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: ThemeTile(
                  option: opt,
                  isSelected: currentMode == opt.mode,
                  onTap: () => ref
                      .read(appStateProvider.notifier)
                      .setThemeMode(opt.mode),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
