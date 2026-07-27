import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/utils/location_provider.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseLocationSheet extends ConsumerWidget {
  final String? currentLocation;
  final ValueChanged<String> onLocationSelected;
  final VoidCallback onChooseOther;

  const ChooseLocationSheet({
    super.key,
    required this.currentLocation,
    required this.onLocationSelected,
    required this.onChooseOther,
  });

  static Future<void> show(
    BuildContext context, {
    required String? currentLocation,
    required ValueChanged<String> onLocationSelected,
    required VoidCallback onChooseOther,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChooseLocationSheet(
        currentLocation: currentLocation,
        onLocationSelected: onLocationSelected,
        onChooseOther: onChooseOther,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationsProvider);

    return Container(
      padding: EdgeInsets.only(
        top: 24.h,
        bottom: MediaQuery.paddingOf(context).bottom + 20.h,
        left: 24.w,
        right: 24.w,
      ),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Choose Location',
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          if (locations.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                children: [
                  Icon(
                    Icons.location_off_outlined,
                    size: 48.sp,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'No saved addresses yet',
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Save a home or work address to quickly pick\nyour delivery or pickup location.',
                    style: context.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          PageRoutes.locationEdit.name,
                        );
                      },
                      icon: const Icon(Icons.add_location_alt_outlined),
                      label: const Text('Add & Save an Address'),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            )
          else
            ...locations.asMap().entries.map((entry) {
              final index = entry.key;
              final loc = entry.value;
              final isSelected = currentLocation == loc.address;

              String displayLabel;
              if (index == 0) {
                displayLabel = 'Home';
              } else if (index == 1) {
                displayLabel = 'Work/Office/Store';
              } else {
                displayLabel = 'Address ${index + 1}';
              }

              return InkWell(
                onTap: () {
                  onLocationSelected(loc.address);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 3.w,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        color: isSelected
                            ? context.color.onPrimary
                            : Colors.grey.shade400,
                        size: 22.sp,
                      ),
                      SizedBox(width: 18.w),
                      Expanded(
                        child: Text(
                          displayLabel,
                          style: context.bodyMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? context.color.onPrimary
                                : Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

          SizedBox(height: 24.h),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onChooseOther();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Choose Other Location.......',
                style: context.bodyMedium?.copyWith(
                  color: context.color.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
