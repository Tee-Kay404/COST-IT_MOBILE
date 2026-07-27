import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/location/utils/providers.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationFieldWidget extends ConsumerWidget {
  const LocationFieldWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(selectedLocationProvider);

    final double fieldWidth = (MediaQuery.of(context).size.width * 0.35).clamp(
      120.0,
      180.0,
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(PageRoutes.location.name);
      },
      child: SizedBox(
        height: 36.h,
        width: fieldWidth,
        child: Container(
          decoration: BoxDecoration(
            color: CostItColors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.white.withAlpha(60), width: 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedLocation ?? 'Nigeria',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodyMedium?.copyWith(
                    color: selectedLocation != null
                        ? Colors.black87
                        : CostItColors.brightGrey.shade500,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: CostItColors.brightGrey.shade500,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
