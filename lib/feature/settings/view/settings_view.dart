import 'package:cost_it_mobile/app/global/models/app_version.dart';
import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/settings/component/account_card.dart';
import 'package:cost_it_mobile/feature/settings/component/modals.dart';
import 'package:cost_it_mobile/feature/settings/models/settings_tile_model.dart';
import 'package:cost_it_mobile/shared/appBar/costit_back_app_bar.dart';
import 'package:cost_it_mobile/widgets/dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../component/settings_section_group.dart';
import '../models/settings_data.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  void _handleTap(
    BuildContext context,
    WidgetRef ref,
    SettingsTileModel tile,
  ) {
    if (tile.isDestructive) {
      confirmDestructive(context, ref, tile.title);
      return;
    }

    if (tile.onTap != null) {
      tile.onTap!();
      return;
    }

    if (tile.route != null) {
      Navigator.pushNamed(context, tile.route!);
    } else {
      showFeatureNotEnabledDialog(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final user = appState.user;
    final currentMode = appState.settings.themeMode;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: CostItBackAppBar(title: 'Settings'),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        children: [
          AccountSummaryCard(
            displayName: user?.displayName ?? 'Guest',
            email: user?.email ?? '',
            photoUrl: user?.photoUrl,
          ),
          Gap(24.h),

          ...settingsSections.map((section) {
            final tiles = section.tiles.map((tile) {
              if (tile.title == 'Theme') {
                final modeString = currentMode == ThemeMode.light 
                    ? 'Light' 
                    : (currentMode == ThemeMode.dark ? 'Dark' : 'System');
                return SettingsTileModel(
                  title: tile.title,
                  icon: tile.icon,
                  route: tile.route,
                  valueLabel: modeString,
                  hasNotificationDot: tile.hasNotificationDot,
                  isDestructive: tile.isDestructive,
                  onTap: tile.onTap,
                );
              }
              return tile;
            }).toList();

            return Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: SettingsSectionGroup(
                sectionTitle: section.sectionTitle,
                tiles: tiles,
                onTileTap: (tile) => _handleTap(context, ref, tile),
              ),
            );
          }),

          const AppVersion(),
          Gap(32.h),
        ],
      ),
    );
  }
}
