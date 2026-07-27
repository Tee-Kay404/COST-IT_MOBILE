import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Fullscreen image viewer with dark backdrop, pinch-to-zoom, swipe through
/// images, and a close button. Opened via [ImageViewerOverlay.show].
class ImageViewerOverlay extends StatefulWidget {
  final List<String?> images;
  final int initialIndex;

  const ImageViewerOverlay({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  /// Convenience helper to push the overlay as a full-screen route.
  static void show(
    BuildContext context, {
    required List<String?> images,
    int initialIndex = 0,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        barrierColor: Colors.black,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) => ImageViewerOverlay(
          images: images,
          initialIndex: initialIndex,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  State<ImageViewerOverlay> createState() => _ImageViewerOverlayState();
}

class _ImageViewerOverlayState extends State<ImageViewerOverlay> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    // Force dark status bar while overlay is open
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Tap backdrop to close ──
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.transparent),
          ),

          // ── Swipeable image gallery ──
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (_, i) {
              final img = widget.images[i];
              if (img == null) {
                return Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 64.sp,
                    color: Colors.grey.shade600,
                  ),
                );
              }
              return Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: img,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white70,
                      ),
                    ),
                    errorWidget: (_, __, ___) => Icon(
                      Icons.broken_image_outlined,
                      size: 64.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Close button (top-left) ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 12.h,
            left: 16.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ),

          // ── Counter badge (top-right) ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 12.h,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${_currentIndex + 1} / ${widget.images.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // ── Dot indicator (bottom) ──
          if (widget.images.length > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 28.h,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.images.length,
                  onDotClicked: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.white.withValues(alpha: 0.35),
                    dotHeight: 8.h,
                    dotWidth: 8.w,
                    expansionFactor: 3,
                    spacing: 6.w,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
