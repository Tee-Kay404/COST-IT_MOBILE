import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/product_details/components/image_viewer_overlay.dart';
import 'package:cost_it_mobile/feature/products/widgets/product_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HeroImageSection extends StatefulWidget {
  final Product product;
  const HeroImageSection({super.key, required this.product});

  @override
  State<HeroImageSection> createState() => _HeroImageSectionState();
}

class _HeroImageSectionState extends State<HeroImageSection> {
  final PageController _pageController = PageController();

  List<String?> get _images {
    if (widget.product.images.isNotEmpty) {
      return widget.product.images;
    }
    if (widget.product.displayImage != null) {
      return [widget.product.displayImage];
    }
    return [null];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onImageTap() {
    final currentIndex = _pageController.page?.round() ?? 0;
    ImageViewerOverlay.show(
      context,
      images: _images,
      initialIndex: currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _onImageTap,
          child: SizedBox(
            height: 300.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              itemBuilder: (_, i) {
                final img = _images[i];
                if (img == null) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 48.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  );
                }
                return CachedNetworkImage(
                  imageUrl: img,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const ProductImageShimmer(),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 48.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        Positioned(
          bottom: 20.h,
          left: 12.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                color: Colors.black.withValues(alpha: 0.35),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.photo_camera_outlined,
                      size: 14.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${_images.length} photos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 12.h,
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: _images.length,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.white,
                dotColor: Colors.white.withValues(alpha: 0.45),
                dotHeight: 6.h,
                dotWidth: 6.w,
                expansionFactor: 3,
                spacing: 5.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
