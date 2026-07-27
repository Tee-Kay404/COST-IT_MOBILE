import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/location/component/all_nigeria_tile.dart';
import 'package:cost_it_mobile/feature/location/component/location_section_header.dart';
import 'package:cost_it_mobile/feature/location/utils/providers.dart';
import 'package:cost_it_mobile/feature/location/views/location_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatesBody extends ConsumerWidget {
  final String query;
  final List<String> filteredPopular;
  final List<String> filteredOthers;
  final ValueChanged<String> onStateSelected;
  final VoidCallback onMyLocationTapped;
  final String? activeState;

  const StatesBody({
    super.key,
    required this.query,
    required this.filteredPopular,
    required this.filteredOthers,
    required this.onStateSelected,
    required this.onMyLocationTapped,
    required this.activeState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gpsState = ref.watch(gpsLocationProvider);
    final hasResults = filteredPopular.isNotEmpty || filteredOthers.isNotEmpty;

    return ListView(
      children: [
        InkWell(
          onTap: gpsState.isLoading ? null : onMyLocationTapped,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Icon(
                  Icons.my_location_rounded,
                  color: context.color.onPrimary,
                  size: 22.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My location', style: context.bodyMedium),
                      if (gpsState.isLoading)
                        Row(
                          children: [
                            SizedBox(
                              width: 12.w,
                              height: 12.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: context.color.primary,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Detecting...',
                              style: context.bodySmall?.copyWith(
                                fontSize: 12.sp,
                                color: CostItColors.brightGrey.shade300,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          'Tap to find',
                          style: context.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            color: CostItColors.brightGrey.shade300,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1),

        if (query.isEmpty) const AllNigeriaTile(),

        if (filteredPopular.isNotEmpty) ...[
          const LocationSectionHeader(label: 'POPULAR'),
          ...filteredPopular.map(
            (state) => StateTile(
              state: state,
              onTap: () => onStateSelected(state),
              isActive: activeState == state,
            ),
          ),
        ],

        if (filteredOthers.isNotEmpty) ...[
           LocationSectionHeader(label: 'OTHER'),
          ...filteredOthers.map(
            (state) => StateTile(
              state: state,
              onTap: () => onStateSelected(state),
              isActive: activeState == state,
            ),
          ),
        ],

        if (!hasResults)
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

