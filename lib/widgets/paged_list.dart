// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// enum ListingType {
//   list,
//   grid,
//   masonry,
//   sliverList,
// }

// class PagedList<T> extends StatefulWidget {
//   final Axis orientation;
//   final ListingType listingType;
//   final bool refreshable;
//   final bool shrinkWrap;
//   final ScrollPhysics? scrollPhysics;
//   final PagingController<int, T>? pagingController;
//   final ScrollController? scrollController;
//   final Widget Function(BuildContext, T)? itemBuilder;
//   final Widget Function(BuildContext, int)? separatorBuilder;
//   final WidgetBuilder? loadingBuilder;
//   final Widget Function(BuildContext, String)? errorBuilder;
//   final WidgetBuilder? noItemsFoundBuilder;
//   final WidgetBuilder? newPageErrorIndicatorBuilder;

//   final Future<PaginatedDataModel<T>> Function(int page) fetchItems;
//   final SliverGridDelegate? gridDelegate;
//   final EdgeInsets padding;
//   final bool manuallyDispose;
//   final bool reverse;

//   const PagedList({
//     super.key,
//     this.orientation = Axis.vertical,
//     this.listingType = ListingType.list,
//     this.refreshable = true,
//     this.shrinkWrap = false,
//     this.scrollPhysics,
//     this.pagingController,
//     this.scrollController,
//     this.itemBuilder,
//     this.separatorBuilder,
//     this.loadingBuilder,
//     this.errorBuilder,
//     this.newPageErrorIndicatorBuilder,
//     this.noItemsFoundBuilder,
//     this.padding = EdgeInsets.zero,
//     required this.fetchItems,
//     this.gridDelegate,
//     this.reverse = false,
//     this.manuallyDispose = false,
//   });

//   @override
//   State<PagedList<T>> createState() => _PagedListState<T>();
// }

// class _PagedListState<T> extends State<PagedList<T>> {
//   late PagingController<int, T> _pagingController;

//   @override
//   void initState() {
//     super.initState();
//     _pagingController = widget.pagingController ??
//         PagingController<int, T>(
//           getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
//           fetchPage: _fetchPage,
//         );
//   }

//   @override
//   void dispose() {
//     try {
//       if (!widget.manuallyDispose) {
//         _pagingController.dispose();
//       }
//     } catch (err) {
//       rethrow;
//     }

//     super.dispose();
//   }

//   Future<List<T>> _fetchPage(int page) async {
//     // ProductFilters filters = (widget.filters)?.copyWith(page: () => page);
//     PaginatedDataModel<T> result = await widget.fetchItems.call(page);
//     if (result.next == null) {
//       _pagingController.value =
//           _pagingController.value.copyWith(hasNextPage: false);
//     }
//     return result.items;
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget child = PagingListener(
//       controller: _pagingController,
//       builder: (context, state, fetchNextPage) {
//         switch (widget.listingType) {
//           case ListingType.list:
//             return buildList(fetchNextPage);
//           case ListingType.grid:
//             return buildGrid(fetchNextPage);
//           case ListingType.sliverList:
//             return buildSliverList(fetchNextPage);
//           case ListingType.masonry:
//             return buildMasonry(fetchNextPage);
//         }
//       },
//     );
//     if (widget.refreshable) {
//       return RefreshIndicator(
//         onRefresh: () async => _pagingController.refresh(),
//         child: child,
//       );
//     }
//     return child;
//   }

//   Widget buildEmptyWidget(BuildContext context) {
//     return widget.noItemsFoundBuilder?.call(context) ??
//         Center(
//           child: EmptyStateWidget(
//             iconSize: 120.sp,
//             mini: true,
//             iconBackground: Colors.transparent,
//             title: "No Items found",
//             actionText: "Refresh",
//             actionCallback: () => _pagingController.refresh(),
//           ),
//         );
//   }

//   Widget buildErrorsWidget(BuildContext context) {
//     return widget.errorBuilder
//             ?.call(context, _pagingController.error.toString()) ??
//         Center(
//           child: ErrorsWidget(
//             title: "Failed to get Items",
//             mini: true,
//             subtitle: _pagingController.error.toString(),
//             actionCallback: () {
//               _pagingController.refresh();
//             },
//           ),
//         );
//   }

//   Widget buildList(VoidCallback fetchNextPage) {
//     return PagedListView.separated(
//       state: _pagingController.value,
//       fetchNextPage: fetchNextPage,
//       scrollController: widget.scrollController,
//       scrollDirection: widget.orientation,
//       shrinkWrap: widget.shrinkWrap,
//       physics: widget.scrollPhysics,
//       padding: widget.padding,
//       reverse: widget.reverse,
//       separatorBuilder: (context, index) {
//         return widget.separatorBuilder?.call(context, index) ??
//             const SizedBox.shrink();
//       },
//       builderDelegate: PagedChildBuilderDelegate<T>(
//         newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder,
//         itemBuilder: (context, item, index) {
//           return widget.itemBuilder?.call(context, item) ??
//               ListTile(
//                 title: Text(item.toString()),
//               );
//         },
//         noItemsFoundIndicatorBuilder: buildEmptyWidget,
//         firstPageErrorIndicatorBuilder: buildErrorsWidget,
//         newPageProgressIndicatorBuilder: (context) {
//           return const Padding(
//             padding: EdgeInsets.symmetric(vertical: 12),
//             child: Center(child: CircularProgressLoader()),
//           );
//         },
//         firstPageProgressIndicatorBuilder: (context) {
//           return widget.loadingBuilder?.call(context) ??
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 12),
//                 child: Center(child: CircularProgressLoader()),
//               );
//         },
//       ),
//     );
//   }

//   Widget buildMasonry(VoidCallback fetchNextPage) {
//     return PagedMasonryGridView.count(
//       state: _pagingController.value,
//       padding: widget.padding,
//       crossAxisCount: 3,
//       mainAxisSpacing: 2,
//       crossAxisSpacing: 2,
//       fetchNextPage: fetchNextPage,
//       builderDelegate: PagedChildBuilderDelegate<T>(
//         newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder,
//         itemBuilder: (context, item, index) {
//           return widget.itemBuilder?.call(context, item) ??
//               ListTile(
//                 title: Text(item.toString()),
//               );
//         },
//         noItemsFoundIndicatorBuilder: (context) {
//           return buildEmptyWidget(context);
//         },
//         firstPageErrorIndicatorBuilder: (context) {
//           return buildErrorsWidget(context);
//         },
//         newPageProgressIndicatorBuilder: (context) {
//           return const Padding(
//             padding: EdgeInsets.all(8),
//             child: CircularProgressLoader(),
//           );
//         },
//         firstPageProgressIndicatorBuilder: (context) {
//           return widget.loadingBuilder?.call(context) ??
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 12),
//                 child: CircularProgressLoader(),
//               );
//         },
//       ),
//     );
//   }

//   Widget buildGrid(VoidCallback fetchNextPage) {
//     return PagedGridView(
//       state: _pagingController.value,
//       fetchNextPage: fetchNextPage,
//       scrollController: widget.scrollController,
//       scrollDirection: widget.orientation,
//       shrinkWrap: widget.shrinkWrap,
//       physics: widget.scrollPhysics,
//       reverse: widget.reverse,
//       padding: widget.padding,
//       builderDelegate: PagedChildBuilderDelegate<T>(
//         newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder,
//         itemBuilder: (context, item, index) {
//           return widget.itemBuilder?.call(context, item) ??
//               ListTile(
//                 title: Text(item.toString()),
//               );
//         },
//         noItemsFoundIndicatorBuilder: (context) {
//           return buildEmptyWidget(context);
//         },
//         firstPageErrorIndicatorBuilder: (context) {
//           return buildErrorsWidget(context);
//         },
//         newPageProgressIndicatorBuilder: (context) {
//           return const Padding(
//             padding: EdgeInsets.all(8),
//             child: CircularProgressLoader(),
//           );
//         },
//         firstPageProgressIndicatorBuilder: (context) {
//           return widget.loadingBuilder?.call(context) ??
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 12),
//                 child: CircularProgressLoader(),
//               );
//         },
//       ),
//       gridDelegate: widget.gridDelegate ??
//           const SliverGridDelegateWithMaxCrossAxisExtent(
//             crossAxisSpacing: 8,
//             mainAxisSpacing: 8,
//             maxCrossAxisExtent: 240,
//             mainAxisExtent: 320,
//           ),
//     );
//   }

//   buildSliverList(VoidCallback fetchNextPage) {
//     return SliverPadding(
//       padding: widget.padding,
//       sliver: PagedSliverList.separated(
//         state: _pagingController.value,
//         fetchNextPage: fetchNextPage,
//         shrinkWrapFirstPageIndicators: widget.shrinkWrap,
//         builderDelegate: PagedChildBuilderDelegate<T>(
//           itemBuilder: (context, item, index) {
//             return widget.itemBuilder?.call(context, item) ??
//                 ListTile(
//                   title: Text(item.toString()),
//                 );
//           },
//           newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder,
//           noItemsFoundIndicatorBuilder: buildEmptyWidget,
//           firstPageErrorIndicatorBuilder: buildErrorsWidget,
//           newPageProgressIndicatorBuilder: (context) {
//             return const Padding(
//               padding: EdgeInsets.symmetric(vertical: 12),
//               child: Center(child: CircularProgressLoader()),
//             );
//           },
//           firstPageProgressIndicatorBuilder: (context) {
//             return widget.loadingBuilder?.call(context) ??
//                 const Padding(
//                   padding: EdgeInsets.all(12),
//                   child: Center(child: CircularProgressLoader()),
//                 );
//           },
//         ),
//         separatorBuilder: (BuildContext context, int index) {
//           return widget.separatorBuilder?.call(context, index) ??
//               const SizedBox();
//         },
//       ),
//     );
//   }
// }
