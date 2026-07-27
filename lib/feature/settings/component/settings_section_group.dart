import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/settings_tile_model.dart';
import 'settings_list_tile.dart';

class SettingsSectionGroup extends StatelessWidget {
  final String sectionTitle;
  final List<SettingsTileModel> tiles;
  final void Function(SettingsTileModel tile) onTileTap;

  const SettingsSectionGroup({
    super.key,
    required this.sectionTitle,
    required this.tiles,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
          child: Text(
            sectionTitle.toUpperCase(),
            style: context.bodySmall?.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
              letterSpacing: 0.8,
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (int i = 0; i < tiles.length; i++) ...[
                SettingsListTile(
                  title: tiles[i].title,
                  icon: tiles[i].icon,
                  valueLabel: tiles[i].valueLabel,
                  hasNotificationDot: tiles[i].hasNotificationDot,
                  isDestructive: tiles[i].isDestructive,
                  onTap: () => onTileTap(tiles[i]),
                ),
                if (i < tiles.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 64.w,
                    endIndent: 16.w,
                    color: Colors.grey.withOpacity(0.15),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
