import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/widgets/dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CostItSpeedDial extends StatelessWidget {
  const CostItSpeedDial({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SpeedDial(
      icon: (Icons.folder_outlined),
      mini: true,
      animatedIcon: AnimatedIcons.add_event,
      backgroundColor: CostItColors.primary2,
      foregroundColor: CostItColors.primaryLightes,
      overlayColor: CostItColors.primary2,
      overlayOpacity: 0.3.sp,
      spacing: 5.h,
      spaceBetweenChildren: 0.sp,
      children: [
        SpeedDialChild(
          backgroundColor: CostItColors.primary2,
          foregroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(Icons.note_add_outlined, size: 20),
          label: 'Sell',
          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 15.sp,
            color: theme.primaryColorLight,
          ),
          labelBackgroundColor: CostItColors.primary2,
          onTap: () {
            showFeatureNotEnabledDialog(context);
          },
        ),
        SpeedDialChild(
          backgroundColor: CostItColors.primary2,
          foregroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(Icons.list_alt_outlined, size: 20),
          label: 'BookMarks',
          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 15.sp,
            color: theme.primaryColorLight,
          ),
          labelBackgroundColor: CostItColors.primary2,
          onTap: () {
            showFeatureNotEnabledDialog(context);
          },
        ),
        SpeedDialChild(
          backgroundColor: CostItColors.primary2,
          foregroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(Icons.folder_outlined, size: 20),
          label: 'Orders',
          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 15.sp,
            color: theme.primaryColorLight,
          ),
          labelBackgroundColor: CostItColors.primary2,
          onTap: () {
            showFeatureNotEnabledDialog(context);
          },
        ),
        SpeedDialChild(
          backgroundColor: CostItColors.primary2,
          foregroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(Icons.search, size: 20),
          label: 'Search',
          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 15.sp,
            color: theme.primaryColorLight,
          ),
          labelBackgroundColor: CostItColors.primary2,
          onTap: () {
            showFeatureNotEnabledDialog(context);
          },
        ),
      ],
    );
  }
}
