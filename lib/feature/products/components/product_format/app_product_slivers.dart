import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A standard sliver grid for displaying products consistently across the app.
/// Uses a MasonryGrid to support items with variable heights gracefully.
class AppProductSliverGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;

  const AppProductSliverGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final crossAxisCount = screenWidth >= 900 ? 5 : screenWidth >= 700 ? 4 : 2;

    return SliverPadding(
      padding: padding ?? EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 80.h),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}

/// A standard sliver list for displaying products consistently across the app.
class AppProductSliverList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;

  const AppProductSliverList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 80.h),
      sliver: SliverList.separated(
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: itemBuilder,
      ),
    );
  }
}

/// A standard grid for displaying products consistently across the app.
/// This is the non-sliver version of AppProductSliverGrid.
class AppProductGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const AppProductGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final crossAxisCount = screenWidth >= 900 ? 5 : screenWidth >= 700 ? 4 : 2;

    return MasonryGridView.count(
      padding: padding ?? EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 80.h),
      shrinkWrap: shrinkWrap,
      physics: physics,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}

/// A standard list for displaying products consistently across the app.
/// This is the non-sliver version of AppProductSliverList.
class AppProductList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const AppProductList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 80.h),
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: itemBuilder,
    );
  }
}
