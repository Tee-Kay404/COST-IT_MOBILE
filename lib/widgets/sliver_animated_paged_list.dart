// import 'package:flutter/widgets.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:sliver_tools/sliver_tools.dart';

// class SliverAnimatedPagedList<T> extends StatelessWidget {
//   final PagingController<int, T> pagingController;
//   final PagedChildBuilderDelegate<T> builderDelegate;
//   final GlobalKey<SliverAnimatedListState> animatedListKey;

//   const SliverAnimatedPagedList({
//     super.key,
//     required this.animatedListKey,
//     required this.pagingController,
//     required this.builderDelegate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return PagedLayoutBuilder<int, T>(
//       state: pagingController.value,
//       fetchNextPage: pagingController.fetchNextPage,
//       builderDelegate: builderDelegate,
//       completedListingBuilder: (
//         BuildContext context,
//         Widget Function(BuildContext, int) itemWidgetBuilder,
//         int itemCount,
//         Widget Function(BuildContext)? noMoreItemsIndicatorBuilder,
//       ) {
//         return MultiSliver(
//           children: [
//             SliverAnimatedList(
//               key: animatedListKey,
//               initialItemCount: itemCount,
//               itemBuilder: (
//                 BuildContext context,
//                 int index,
//                 Animation<double> animation,
//               ) =>
//                   itemWidgetBuilder(
//                 context,
//                 index,
//               ),
//             ),
//             if (noMoreItemsIndicatorBuilder != null)
//               SliverToBoxAdapter(
//                 child: noMoreItemsIndicatorBuilder(context),
//               )
//           ],
//         );
//       },
//       loadingListingBuilder: (
//         BuildContext context,
//         Widget Function(BuildContext, int) itemWidgetBuilder,
//         int itemCount,
//         Widget Function(BuildContext) newPageProgressIndicatorBuilder,
//       ) {
//         return MultiSliver(
//           children: [
//             SliverAnimatedList(
//               key: animatedListKey,
//               initialItemCount: itemCount,
//               itemBuilder: (
//                 BuildContext context,
//                 int index,
//                 Animation<double> animation,
//               ) =>
//                   itemWidgetBuilder(
//                 context,
//                 index,
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: newPageProgressIndicatorBuilder(context),
//             ),
//           ],
//         );
//       },
//       errorListingBuilder: (
//         BuildContext context,
//         Widget Function(BuildContext, int) itemWidgetBuilder,
//         int itemCount,
//         Widget Function(BuildContext) newPageErrorIndicatorBuilder,
//       ) {
//         return MultiSliver(
//           children: [
//             SliverAnimatedList(
//               key: animatedListKey,
//               initialItemCount: itemCount,
//               itemBuilder: (
//                 BuildContext context,
//                 int index,
//                 Animation<double> animation,
//               ) =>
//                   itemWidgetBuilder(
//                 context,
//                 index,
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: newPageErrorIndicatorBuilder(context),
//             ),
//           ],
//         );
//       },
//       layoutProtocol: PagedLayoutProtocol.sliver,
//     );
//   }
// }
