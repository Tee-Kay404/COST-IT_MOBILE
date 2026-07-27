import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';

class SyncedShimmerGrid extends StatefulWidget {
  final int itemCount;
  final int? crossAxisCount;
  final EdgeInsets? padding;

  const SyncedShimmerGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount,
    this.padding,
  });

  @override
  State<SyncedShimmerGrid> createState() => _SyncedShimmerGridState();
}

class _SyncedShimmerGridState extends State<SyncedShimmerGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animation = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: MasonryGridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              widget.crossAxisCount ??
              (MediaQuery.sizeOf(context).width >= 900
                  ? 5
                  : MediaQuery.sizeOf(context).width >= 700
                  ? 4
                  : 2),
        ),
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        itemCount: widget.itemCount,
        itemBuilder: (_, __) => _ShimmerCard(animation: _animation),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final Animation<double> animation;

  const _ShimmerCard({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: context.color.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: _shimmerBox(context),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _shimmerLine(context, 50.w, 10.h),
                        SizedBox(height: 6.h),
                        _shimmerLine(context, double.infinity, 10.h),
                        SizedBox(height: 4.h),
                        _shimmerLine(context, 100.w, 10.h),
                        SizedBox(height: 6.h),
                        _shimmerLine(context, 75.w, 9.h),
                      ],
                    ),
                    SizedBox(height: 15.sp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _shimmerLine(context, 60.w, 13.h),
                        SizedBox(height: 3.h),
                        _shimmerLine(context, 40.w, 8.h),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerBox(BuildContext context) {
    final baseColor = context.color.surface;
    final highlightColor = context.theme.scaffoldBackgroundColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [baseColor, highlightColor, baseColor],
            stops: [
              (animation.value - 0.3).clamp(0.0, 1.0),
              (animation.value).clamp(0.0, 1.0),
              (animation.value + 0.3).clamp(0.0, 1.0),
            ],
          ).createShader(bounds),
          child: Container(color: baseColor),
        );
      },
    );
  }

  Widget _shimmerLine(BuildContext context, double width, double height) {
    final baseColor = context.color.surface;
    final highlightColor = context.theme.scaffoldBackgroundColor;

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [baseColor, highlightColor, baseColor],
        stops: [
          (animation.value - 0.3).clamp(0.0, 1.0),
          (animation.value).clamp(0.0, 1.0),
          (animation.value + 0.3).clamp(0.0, 1.0),
        ],
      ).createShader(bounds),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }
}

class ProductImageShimmer extends StatelessWidget {
  const ProductImageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: const Color(0xFFEBEBF4));
  }
}
