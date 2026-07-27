import 'package:flutter/material.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'settings_tile_model.dart';

final List<SettingsSectionModel> settingsSections = [
  SettingsSectionModel(
    sectionTitle: 'Security',
    tiles: [
      SettingsTileModel(
        title: 'Password & Security',
        icon: Icons.lock_outline_rounded,
        route: PageRoutes.loginSettings.name,
      ),
      SettingsTileModel(
        title: 'Two-Factor Authentication',
        icon: Icons.verified_user_outlined,
      ),
      SettingsTileModel(
        title: 'Login Activity',
        icon: Icons.devices_outlined,
      ),
    ],
  ),
  SettingsSectionModel(
    sectionTitle: 'Notifications',
    tiles: [
      SettingsTileModel(
        title: 'Push Notifications',
        icon: Icons.notifications_none_rounded,
        hasNotificationDot: true,
      ),
      SettingsTileModel(
        title: 'Email Alerts',
        icon: Icons.mail_outline_rounded,
      ),
      SettingsTileModel(
        title: 'SMS Alerts',
        icon: Icons.sms_outlined,
      ),
    ],
  ),
  SettingsSectionModel(
    sectionTitle: 'Preferences',
    tiles: [
      SettingsTileModel(
        title: 'Theme',
        icon: Icons.contrast_rounded,
        route: PageRoutes.theme.name,
        valueLabel: 'Light',
      ),
      SettingsTileModel(
        title: 'Language',
        icon: Icons.language_rounded,
        valueLabel: 'English',
      ),
      SettingsTileModel(
        title: 'Currency',
        icon: Icons.attach_money_rounded,
        valueLabel: 'NGN',
      ),
      SettingsTileModel(
        title: 'Unit System',
        icon: Icons.square_foot_rounded,
        valueLabel: 'Metric',
      ),
    ],
  ),
  SettingsSectionModel(
    sectionTitle: 'Privacy & Data',
    tiles: [
      SettingsTileModel(
        title: 'Data & Privacy',
        icon: Icons.privacy_tip_outlined,
      ),
      SettingsTileModel(
        title: 'Clear Cache',
        icon: Icons.cleaning_services_outlined,
      ),
      SettingsTileModel(
        title: 'Delete Account',
        icon: Icons.delete_forever_outlined,
        route: PageRoutes.deleteAccount.name,
        isDestructive: true,
      ),
    ],
  ),
];

