// import 'package:flutter/widgets.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// class AnimatedPagedList<T> extends StatelessWidget {
//   final PagingController<int, T> pagingController;
//   final PagedChildBuilderDelegate<T> builderDelegate;
//   final GlobalKey<AnimatedListState> animatedListKey;
//   final EdgeInsets? padding;

//   const AnimatedPagedList({
//     super.key,
//     required this.animatedListKey,
//     required this.pagingController,
//     required this.builderDelegate,
//     this.padding,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return PagedLayoutBuilder<int, T>(
//       state: pagingController.value,
//       fetchNextPage: pagingController.fetchNextPage,
//       builderDelegate: builderDelegate,
//       layoutProtocol: PagedLayoutProtocol.box,
//       completedListingBuilder: (
//         BuildContext context,
//         Widget Function(BuildContext, int) itemWidgetBuilder,
//         int itemCount,
//         Widget Function(BuildContext)? noMoreItemsIndicatorBuilder,
//       ) {
//         return Column(
//           children: [
//             Expanded(
//               child: AnimatedList(
//                 key: animatedListKey,
//                 padding: padding,
//                 initialItemCount: itemCount,
//                 itemBuilder: (
//                   BuildContext context,
//                   int index,
//                   Animation<double> animation,
//                 ) =>
//                     itemWidgetBuilder(
//                   context,
//                   index,
//                 ),
//               ),
//             ),
//             if (noMoreItemsIndicatorBuilder != null)
//               noMoreItemsIndicatorBuilder(context),
//           ],
//         );
//       },
//       loadingListingBuilder: (
//         BuildContext context,
//         Widget Function(BuildContext, int) itemWidgetBuilder,
//         int itemCount,
//         Widget Function(BuildContext) newPageProgressIndicatorBuilder,
//       ) {
//         return Column(
//           children: [
//             Expanded(
//               child: AnimatedList(
//                 key: animatedListKey,
//                 padding: padding,
//                 initialItemCount: itemCount,
//                 itemBuilder: (
//                   BuildContext context,
//                   int index,
//                   Animation<double> animation,
//                 ) =>
//                     itemWidgetBuilder(
//                   context,
//                   index,
//                 ),
//               ),
//             ),
//             newPageProgressIndicatorBuilder(context),
//           ],
//         );
//       },
//       errorListingBuilder: (
//         BuildContext context,
//         Widget Function(BuildContext, int) itemWidgetBuilder,
//         int itemCount,
//         Widget Function(BuildContext) newPageErrorIndicatorBuilder,
//       ) {
//         return Column(
//           children: [
//             Expanded(
//               child: AnimatedList(
//                 key: animatedListKey,
//                 initialItemCount: itemCount,
//                 padding: padding,
//                 itemBuilder: (
//                   BuildContext context,
//                   int index,
//                   Animation<double> animation,
//                 ) =>
//                     itemWidgetBuilder(
//                   context,
//                   index,
//                 ),
//               ),
//             ),
//             newPageErrorIndicatorBuilder(context),
//           ],
//         );
//       },
//     );
//   }
// }
