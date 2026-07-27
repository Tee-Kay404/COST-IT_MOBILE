import 'package:cost_it_mobile/feature/location/component/location_section_header.dart';
import 'package:flutter/material.dart';
import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LgaBody extends StatelessWidget {
  final String stateName;
  final String query;
  final List<String> filteredLgas;
  final ValueChanged<String> onLgaSelected;
  final VoidCallback onSelectWholeState;
  final String? activeLga;
  final String? activeState;

  const LgaBody({
    super.key,
    required this.stateName,
    required this.query,
    required this.filteredLgas,
    required this.onLgaSelected,
    required this.onSelectWholeState,
    required this.activeLga,
    required this.activeState,
  });

  @override
  Widget build(BuildContext context) {
    final wholeStateSelected = activeState == stateName && activeLga == null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? CostItColors.secondaryDark : context.color.primary;

    return ListView(
      children: [
        InkWell(
          onTap: onSelectWholeState,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'All $stateName',
                    style: context.bodyMedium?.copyWith(
                      color: wholeStateSelected ? activeColor : null,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (wholeStateSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: activeColor,
                    size: 20.sp,
                  ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1),

        const LocationSectionHeader(label: 'LOCAL GOVERNMENT AREAS'),

        ...filteredLgas.map((lga) {
          final isActive = activeLga == lga && activeState == stateName;
          return Column(
            children: [
              InkWell(
                onTap: () => onLgaSelected(lga),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          lga,
                          style: context.bodyMedium?.copyWith(
                            color: isActive ? activeColor : null,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isActive)
                        Icon(
                          Icons.check_circle_rounded,
                          color: activeColor,
                          size: 20.sp,
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1),
            ],
          );
        }),

        if (filteredLgas.isEmpty)
          Padding(
            padding: EdgeInsets.all(32.w),
            child: Center(
              child: Text(
                'No results for "$query"',
                style: context.bodySmall?.copyWith(
                  color: CostItColors.brightGrey.shade400,
                ),
              ),
            ),
          ),

        SizedBox(height: 32.h),
      ],
    );
  }
}

