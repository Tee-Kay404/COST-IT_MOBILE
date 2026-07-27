import 'dart:ui';

import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/product_details/components/image_viewer_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'shared_widgets.dart';
import 'special_offer_pill.dart';

/// Swipeable hero image gallery with page indicator, image counter
/// pill, and special-offer pill. No standalone hues — gradients used
/// here are pure black-alpha for legibility, not color accents.
class HeroGallery extends StatelessWidget {
  final List<String> images;
  final bool hasImages;
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final Product product;

  const HeroGallery({
    super.key,
    required this.images,
    required this.hasImages,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (hasImages)
          PageView.builder(
            controller: pageController,
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () {
                ImageViewerOverlay.show(context, images: images, initialIndex: i);
              },
              child: Image.network(
                images[i],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const NoImagePlaceholder(),
              ),
            ),
          )
        else
          const NoImagePlaceholder(),

        // Bottom gradient for text/pill legibility over the image.
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.45, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Top gradient so app-bar icons stay legible.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 100.h,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.45),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Image counter pill (bottom-right).
        if (hasImages && images.length > 1)
          Positioned(
            bottom: 16.h,
            right: 16.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                      Gap(4.w),
                      Text(
                        '${currentIndex + 1} / ${images.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // Dot indicator (bottom centre).
        if (hasImages && images.length > 1)
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: i == currentIndex ? 18.w : 6.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: i == currentIndex
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
          ),

        // Special offer "drop" pill (bottom-left) — secondary color.
        if (product.specialOffer?.isActive == true)
          Positioned(
            bottom: 16.h,
            left: 16.w,
            child: SpecialOfferPill(
              discountLabel: product.specialOffer!.discountLabel,
            ),
          ),
      ],
    );
  }
}