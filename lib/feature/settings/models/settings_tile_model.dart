import 'package:flutter/material.dart';

/// A strongly-typed model representing a single settings tile.
///
/// Replaces the previous `Map<String, dynamic>` pattern, giving us:
///  - Compile-time type safety (no more `tile['icon'] as IconData` casts)
///  - Auto-complete in the IDE
///  - A single source of truth that `SettingsSectionGroup`, `SettingsListTile`
///    and `SettingsView` all reference — no drift between callers.
class SettingsTileModel {
  final String title;
  final IconData icon;
  final String? route;
  final String? valueLabel;
  final bool hasNotificationDot;
  final bool isDestructive;
  /// Optional override callback. When null the view falls back to route push.
  final VoidCallback? onTap;

  const SettingsTileModel({
    required this.title,
    required this.icon,
    this.route,
    this.valueLabel,
    this.hasNotificationDot = false,
    this.isDestructive = false,
    this.onTap,
  });
}

/// A strongly-typed model representing a labelled group of [SettingsTileModel]s.
class SettingsSectionModel {
  final String sectionTitle;
  final List<SettingsTileModel> tiles;

  const SettingsSectionModel({
    required this.sectionTitle,
    required this.tiles,
  });
}
