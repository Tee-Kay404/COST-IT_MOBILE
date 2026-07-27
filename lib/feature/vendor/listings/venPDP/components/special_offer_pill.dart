import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Compact "drop" pill shown at the bottom-left of the hero gallery
/// when a special offer is active. Inherits the theme secondary
/// color rather than a standalone red/orange gradient.
class SpecialOfferPill extends StatelessWidget {
  final String discountLabel;
  const SpecialOfferPill({super.key, required this.discountLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: context.color.secondary,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: context.color.onSecondary,
            size: 12.sp,
          ),
          Gap(4.w),
          Text(
            discountLabel,
            style: TextStyle(
              color: context.color.onSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width "Special Offer Active" banner shown in the body,
/// below the price card. Same secondary-color treatment as the
/// pill, just a larger surface.
class SpecialOfferBanner extends StatelessWidget {
  final dynamic offer; // SpecialOffer
  const SpecialOfferBanner({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: context.color.secondary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: context.color.onSecondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.local_fire_department_rounded,
                color: context.color.onSecondary,
                size: 20.sp,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Special Offer Active',
                    style: TextStyle(
                      color: context.color.onSecondary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.sp,
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    offer.discountLabel,
                    style: TextStyle(
                      color: context.color.onSecondary.withValues(alpha: 0.85),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (offer.expiresAt != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Ends in',
                    style: TextStyle(
                      color: context.color.onSecondary.withValues(alpha: 0.75),
                      fontSize: 10.sp,
                    ),
                  ),
                  Text(
                    _formatTimeLeft(offer.expiresAt!),
                    style: TextStyle(
                      color: context.color.onSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatTimeLeft(DateTime expiresAt) {
    final diff = expiresAt.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    if (diff.inDays > 0) return '${diff.inDays}d ${diff.inHours % 24}h';
    if (diff.inHours > 0) return '${diff.inHours}h ${diff.inMinutes % 60}m';
    return '${diff.inMinutes}m';
  }
}