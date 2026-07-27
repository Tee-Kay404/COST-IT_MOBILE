import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Small vertical accent bar + label, used to head each section
/// ("Product Details", "Description", etc). Inherits primary color.
class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: context.color.onPrimary,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        Gap(8.w),
        Text(
          label,
          style: context.titleSmall?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

/// Rounded back-navigation icon button used over the hero image.
class DetailBackButton extends StatelessWidget {
  const DetailBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        margin: EdgeInsets.all(8.r),
        width: 38.r,
        height: 38.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 18.sp,
        ),
      ),
    );
  }
}

/// Rounded "more" icon button used over the hero image.
class DetailMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  const DetailMoreButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.r),
        width: 38.r,
        height: 38.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Icon(Icons.more_vert_rounded, color: Colors.white, size: 18.sp),
      ),
    );
  }
}

/// Placeholder shown when a listing has no images. Uses the primary
/// color only (no arbitrary gradient hues).
class NoImagePlaceholder extends StatelessWidget {
  const NoImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.color.primary.withValues(alpha: 0.15),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white.withValues(alpha: 0.6),
          size: 48.sp,
        ),
      ),
    );
  }
}