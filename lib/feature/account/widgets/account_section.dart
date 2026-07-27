import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/widgets/dialogbox.dart';

import 'account_list_tile.dart';
import 'account_section_header.dart';
import 'account_tile_container.dart';

class AccountTileModel {
  final String title;
  final IconData icon;
  final String? route;
  final VoidCallback? onTap;
  final Color? iconColor;
  final String? valueLabel;
  final int? badgeCount;
  final bool hasNotificationDot;
  final Widget? customTrailing;

  const AccountTileModel({
    required this.title,
    required this.icon,
    this.route,
    this.onTap,
    this.iconColor,
    this.valueLabel,
    this.badgeCount,
    this.hasNotificationDot = false,
    this.customTrailing,
  });
}

class AccountSection extends StatelessWidget {
  const AccountSection({super.key, required this.title, required this.tiles});

  final String title;
  final List<AccountTileModel> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccountSectionHeader(title: title),
        ...List.generate(tiles.length, (index) {
          final tile = tiles[index];
          return Column(
            children: [
              AccountTileContainer(
                children: [
                  AccountListTile(
                    title: tile.title,
                    icon: tile.icon,
                    iconColor: tile.iconColor,
                    valueLabel: tile.valueLabel,
                    badgeCount: tile.badgeCount,
                    hasNotificationDot: tile.hasNotificationDot,
                    customTrailing: tile.customTrailing,
                    onTap:
                        tile.onTap ??
                        (tile.route != null
                            ? () => Navigator.of(context).pushNamed(tile.route!)
                            : () => showFeatureNotEnabledDialog(context)),
                  ),
                ],
              ),
              if (index < tiles.length - 1) SizedBox(height: 5.h),
            ],
          );
        }),
      ],
    );
  }
}
