import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MyListingsShimmer extends StatefulWidget {
  final EdgeInsets? padding;

  const MyListingsShimmer({
    super.key,
    this.padding,
  });

  @override
  State<MyListingsShimmer> createState() => _MyListingsShimmerState();
}

class _MyListingsShimmerState extends State<MyListingsShimmer>
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(context),
          _buildTabBar(context),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, index) {
                return _ShimmerListCard(animation: _animation);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(child: _ShimmerSummaryCard(animation: _animation)),
          Gap(8.w),
          Expanded(child: _ShimmerSummaryCard(animation: _animation)),
          Gap(8.w),
          Expanded(child: _ShimmerSummaryCard(animation: _animation)),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      height: 48.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
            child: _shimmerLine(context, 70.w, 20.h),
          );
        },
      ),
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
          (_animation.value - 0.3).clamp(0.0, 1.0),
          (_animation.value).clamp(0.0, 1.0),
          (_animation.value + 0.3).clamp(0.0, 1.0),
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

class _ShimmerSummaryCard extends StatelessWidget {
  final Animation<double> animation;

  const _ShimmerSummaryCard({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: context.color.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _shimmerLine(context, 34.r, 34.r, isCircle: true),
              Gap(8.h),
              _shimmerLine(context, 30.w, 18.h),
              Gap(4.h),
              _shimmerLine(context, 50.w, 11.h),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerLine(BuildContext context, double width, double height,
      {bool isCircle = false}) {
    final baseColor = context.theme.scaffoldBackgroundColor;
    final highlightColor = context.color.surface;

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
          borderRadius: isCircle ? null : BorderRadius.circular(4.r),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}

class _ShimmerListCard extends StatelessWidget {
  final Animation<double> animation;

  const _ShimmerListCard({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          height: 135.h,
          decoration: BoxDecoration(
            color: context.color.surface,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thumbnail
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.38,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.r),
                    bottomLeft: Radius.circular(14.r),
                  ),
                  child: _shimmerBox(context),
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 12.h, 16.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerLine(context, double.infinity, 13.h),
                      Gap(4.h),
                      _shimmerLine(context, 100.w, 13.h),
                      Gap(10.h),
                      _shimmerLine(context, 80.w, 13.h),
                      Gap(8.h),
                      _shimmerLine(context, 60.w, 11.h),
                      Gap(8.h),
                      Row(
                        children: [
                          _shimmerLine(context, 40.w, 10.h),
                          Gap(8.w),
                          _shimmerLine(context, 40.w, 10.h),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerBox(BuildContext context) {
    final baseColor = context.theme.scaffoldBackgroundColor;
    final highlightColor = context.color.surface;

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
    final baseColor = context.theme.scaffoldBackgroundColor;
    final highlightColor = context.color.surface;

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
