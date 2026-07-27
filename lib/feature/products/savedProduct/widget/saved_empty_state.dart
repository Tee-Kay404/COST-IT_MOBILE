import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedEmptyState extends StatelessWidget {
  final bool isFiltered;
  final VoidCallback onBrowse;

  const SavedEmptyState({
    super.key,
    this.isFiltered = false,
    required this.onBrowse,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmptyIllustration(isFiltered: isFiltered),
            SizedBox(height: 28.h),
            Text(
              isFiltered ? 'No Results Found' : 'Nothing Saved Yet',
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              isFiltered
                  ? 'Try a different search term or clear your filter.'
                  : 'Tap the bookmark icon on any product to save it here for quick access.',
              style: context.bodyMedium?.copyWith(
                color: context.color.onSurface.withValues(alpha: 0.55),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (!isFiltered) ...[
              SizedBox(height: 32.h),
              FilledButton.icon(
                onPressed: onBrowse,
                icon: Icon(Icons.storefront_outlined, size: 18.r),
                label: const Text('Browse Products'),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
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

class _EmptyIllustration extends StatelessWidget {
  final bool isFiltered;

  const _EmptyIllustration({required this.isFiltered});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.r,
      height: 120.r,
      decoration: BoxDecoration(
        color: context.color.primary.withValues(alpha: 0.07),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            isFiltered
                ? Icons.search_off_rounded
                : Icons.bookmark_border_rounded,
            size: 56.r,
            color: context.color.primary.withValues(alpha: 0.35),
          ),
          if (!isFiltered)
            Positioned(
              bottom: 22.r,
              right: 22.r,
              child: Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  color: context.color.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_rounded,
                  size: 18.r,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
