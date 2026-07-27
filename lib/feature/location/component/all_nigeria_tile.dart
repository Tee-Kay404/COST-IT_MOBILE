import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/location/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllNigeriaTile extends ConsumerWidget {
  const AllNigeriaTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(selectedLocationProvider) == 'All Nigeria';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark
        ? CostItColors.secondaryDark
        : context.color.primary;

    return Column(
      children: [
        InkWell(
          onTap: () {
            ref.read(selectedLocationProvider.notifier).state = 'All Nigeria';
            ref.read(selectedStateProvider.notifier).state = null;
            ref.read(selectedLgaProvider.notifier).state = null;
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'All Nigeria',
                    style: context.bodyMedium?.copyWith(
                      color: isActive ? activeColor : null,
                      fontWeight: isActive ? FontWeight.w600 : null,
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
  }
}
