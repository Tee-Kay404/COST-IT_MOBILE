import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/vendor/listings/models/sell_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OfferPreviewChip extends StatelessWidget {
  final SellFormState state;
  const OfferPreviewChip({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.only(bottom: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.color.primary,
              context.color.primary.withOpacity(0.75),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: context.color.primary.withOpacity(0.28),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_offer_rounded, size: 13.sp, color: Colors.white),
            Gap(6.w),
            Text(
              state.offerLabel,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
            if (state.offerBadge.isNotEmpty) ...[
              Gap(6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  state.offerBadge,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
