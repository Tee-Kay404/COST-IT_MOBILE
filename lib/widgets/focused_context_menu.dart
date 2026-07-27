// import 'dart:async';
// import 'dart:ui';
// import 'package:cost_it_mobile/widgets/animated_visibility.dart';
// import 'package:flutter/material.dart';

// class FocusedMenuHolder extends StatefulWidget {
//   final Widget child;
//   final Widget Function(BuildContext, Widget)? liftBuilder;
//   final Widget Function(BuildContext, Widget)? previewBuilder;
//   final double? menuItemExtent;
//   final double? menuWidth;
//   final double? maxMenuHeight;
//   final List<FocusedMenuItem> menuItems;
//   final bool? animateMenuItems;
//   final BoxDecoration? menuBoxDecoration;
//   final Widget Function(BuildContext, Widget)? menuBoxWidgetBuilder;
//   final Function onPressed;
//   final Duration? duration;
//   final double? blurSize;
//   final Color? blurBackgroundColor;
//   final double? bottomOffsetHeight;
//   final double? menuOffset;
//   final EdgeInsets padding;

//   /// Open with tap insted of long press.
//   final bool openWithTap;

//   const FocusedMenuHolder({
//     super.key,
//     required this.child,
//     required this.onPressed,
//     required this.menuItems,
//     this.duration,
//     this.menuBoxDecoration,
//     this.menuItemExtent = 50,
//     this.animateMenuItems,
//     this.blurSize,
//     this.blurBackgroundColor,
//     this.menuWidth,
//     this.padding = EdgeInsets.zero,
//     this.maxMenuHeight,
//     this.bottomOffsetHeight,
//     this.menuOffset,
//     this.openWithTap = false,
//     this.liftBuilder,
//     this.previewBuilder,
//     this.menuBoxWidgetBuilder,
//   });

//   @override
//   State<FocusedMenuHolder> createState() => _FocusedMenuHolderState();
// }

// class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
//   GlobalKey previewKey = GlobalKey();
//   GlobalKey containerKey = GlobalKey();
//   Offset childOffset = Offset(0, 0);
//   Size? childSize;
//   late Widget previewChild;

//   Future<void> getOffset() async {
//     RenderBox containerRenderBox =
//         containerKey.currentContext!.findRenderObject() as RenderBox;
//     Size containerSize = containerRenderBox.size;
//     // Use the previewBuilder if provided, otherwise fallback to the child
//     previewChild = SizedBox(
//       key: previewKey,
//       child: AnimatedVisibility(
//         visible: true,
//         animationType: AnimationType.scaleAndFade,
//         child:
//             widget.previewBuilder?.call(context, widget.child) ?? widget.child,
//       ),
//     );

//     // Create a Completer to wait for the widget to render
//     Completer<void> completer = Completer<void>();

//     // Create an OverlayEntry to render the preview widget off-screen
//     OverlayEntry overlayEntry = OverlayEntry(
//       builder: (context) {
//         return Positioned(
//           top: -1000, // Render off-screen
//           left: -1000,
//           child: previewChild,
//         );
//       },
//     );

//     // Insert the overlay entry
//     Overlay.of(context).insert(overlayEntry);

//     // Wait for the widget to render
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       RenderBox renderBox =
//           previewKey.currentContext!.findRenderObject() as RenderBox;

//       final screenSize = MediaQuery.of(context).size;
//       Size size = renderBox.size;
//       size = Size(size.width - widget.padding.horizontal, size.height);

//       Offset offset = containerRenderBox.localToGlobal(Offset(0, -64));
//       // log("Screen Size: $screenSize");
//       // log("Container Size: $containerSize");
//       // log("Render Box Size: $size");
//       // log("Offset: $offset");

//       // Update the state with the size and offset of the preview widget
//       setState(() {
//         childOffset = offset;
//         childSize = size;
//       });
//       // log("Child Offset: $childOffset");
//       // log("Child Size: $childSize");

//       // Complete the completer
//       completer.complete();
//     });

//     // Wait for the completer to finish
//     await completer.future;

//     // Remove the overlay entry
//     overlayEntry.remove();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       key: containerKey,
//       onTap: () async {
//         widget.onPressed();
//         if (widget.openWithTap) {
//           await openMenu(context);
//         }
//       },
//       onLongPress: () async {
//         if (!widget.openWithTap) {
//           await openMenu(context);
//         }
//       },
//       child: widget.child,
//     );
//   }

//   Future openMenu(BuildContext context) async {
//     await getOffset();

//     // // Show the liftBuilder if provided
//     // if (widget.liftBuilder != null) {
//     //   await showDialog(
//     //     context: context,
//     //     barrierColor: Colors.transparent,
//     //     builder: (context) {
//     //       return Center(
//     //         child: widget.liftBuilder!(context, widget.child),
//     //       );
//     //     },
//     //   );
//     // }

//     await Navigator.push(
//       context,
//       PageRouteBuilder(
//         transitionDuration: widget.duration ?? Duration(milliseconds: 100),
//         pageBuilder: (context, animation, secondaryAnimation) {
//           animation = Tween(begin: 0.0, end: 1.0).animate(animation);
//           return FadeTransition(
//             opacity: animation,
//             child: FocusedMenuDetails(
//               itemExtent: widget.menuItemExtent,
//               menuBoxDecoration: widget.menuBoxDecoration,
//               childOffset: childOffset,
//               childSize: childSize,
//               menuItems: widget.menuItems,
//               blurSize: widget.blurSize,
//               menuWidth: widget.menuWidth,
//               blurBackgroundColor: widget.blurBackgroundColor,
//               animateMenu: widget.animateMenuItems ?? true,
//               bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
//               menuOffset: widget.menuOffset ?? 0,
//               padding: widget.padding,
//               child: previewChild,
//             ),
//           );
//         },
//         fullscreenDialog: true,
//         opaque: false,
//       ),
//     );
//   }
// }

// class FocusedMenuDetails extends StatelessWidget {
//   final List<FocusedMenuItem> menuItems;
//   final BoxDecoration? menuBoxDecoration;
//   final Offset childOffset;
//   final double? itemExtent;
//   final Size? childSize;
//   final Widget child;
//   final bool animateMenu;
//   final double? blurSize;
//   final double? menuWidth;
//   final double? maxMenuHeight;
//   final Color? blurBackgroundColor;
//   final double bottomOffsetHeight;
//   final double menuOffset;
//   final EdgeInsets padding;

//   const FocusedMenuDetails({
//     super.key,
//     required this.menuItems,
//     required this.child,
//     required this.childOffset,
//     required this.childSize,
//     required this.menuBoxDecoration,
//     this.itemExtent,
//     required this.animateMenu,
//     required this.blurSize,
//     required this.blurBackgroundColor,
//     required this.menuWidth,
//     required this.padding,
//     this.maxMenuHeight,
//     this.bottomOffsetHeight = 0,
//     this.menuOffset = 0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     Offset _childOffset = childOffset;
//     Size _childSize = childSize ?? Size.zero;
//     final _child = SizedBox(
//       width: _childSize.width,
//       child: Builder(
//         builder: (context2) {
//           final renderBox = context2.findRenderObject() as RenderBox?;
//           _childSize = Size(
//             _childSize.width,
//             renderBox?.size.height ?? _childSize.height,
//           );
//           // log("Render Box: $renderBox");
//           return child;
//         },
//       ),
//     );

//     // log("Screen Size: $size");
//     // log("Padding: $padding");
//     // log("Child Offset: $_childOffset");
//     if ((_childOffset.dx + _childSize.width + padding.horizontal) >
//         size.width) {
//       // log("Items going beyond the screen width");
//       _childOffset = Offset(
//         size.width - (_childSize.width + padding.right),
//         _childOffset.dy,
//       );
//     }
//     if (_childOffset.dx <= 0) {
//       _childOffset = Offset(padding.left, _childOffset.dy);
//     }

//     // log("Child Offset: $_childOffset");
//     if ((_childOffset.dy + _childSize.height + padding.bottom) > size.height) {
//       // log("Items going beyond the screen height");
//       _childOffset = Offset(
//         _childOffset.dx,
//         size.height - (_childSize.height + padding.vertical),
//       );
//     }
//     if (_childOffset.dy <= 0) {
//       _childOffset = Offset(_childOffset.dx, padding.top);
//     }
//     // log("Child Offset: $_childOffset");

//     final dmaxMenuHeight = maxMenuHeight ?? size.height * 0.45;
//     final listHeight = menuItems.length * (itemExtent ?? 50.0);
//     final maxMenuWidth = menuWidth ?? (size.width * 0.80);
//     // log("Max Menu Width: $maxMenuWidth");
//     final menuHeight = listHeight < dmaxMenuHeight
//         ? listHeight
//         : dmaxMenuHeight;

//     // Menu Left Offset
//     final availableWidth = size.width - padding.horizontal;
//     double leftOffset = _childOffset.dx + maxMenuWidth;
//     if (leftOffset < availableWidth) {
//       if ((_childOffset.dx + _childSize.width + padding.right) < size.width) {
//         leftOffset = _childOffset.dx;
//       } else {
//         leftOffset = _childOffset.dx + _childSize.width - maxMenuWidth;
//       }
//     } else {
//       leftOffset =
//           _childOffset.dx - maxMenuWidth + _childSize.width - padding.right;
//     }

//     // Menu Top Offset
//     final availableHeight = size.height - padding.vertical;
//     double topOffset =
//         _childOffset.dy + _childSize.height + menuOffset + menuHeight;
//     if (topOffset < availableHeight) {
//       // log("Top offset is less that height: $topOffset");
//       if (topOffset < padding.top) {
//         // log("Top offset is less than top padding: $topOffset");
//         topOffset = padding.top + 64;
//       } else {
//         topOffset = _childOffset.dy + _childSize.height + menuOffset;
//       }
//     } else {
//       // log("Top offset is greater that height: $topOffset");
//       topOffset = _childOffset.dy - (2 * menuOffset) - menuHeight;
//     }

//     if (topOffset < padding.top) {
//       // log("Top offset is less than top padding: $topOffset");
//       topOffset = padding.top;
//       _childOffset = Offset(
//         _childOffset.dx,
//         topOffset + menuHeight + (2 * menuOffset),
//       );
//     }

//     // log("Top Offset: $topOffset");
//     // log("Left Offset: $leftOffset");
//     // log("Child Offset: $_childOffset");

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: BackdropFilter(
//               filter: ImageFilter.blur(
//                 sigmaX: blurSize ?? 4,
//                 sigmaY: blurSize ?? 4,
//               ),
//               child: Container(
//                 color: (blurBackgroundColor ?? Colors.black).withAlpha(178),
//               ),
//             ),
//           ),
//           Positioned(
//             top: topOffset,
//             left: leftOffset,
//             child: TweenAnimationBuilder(
//               duration: Duration(milliseconds: 200),
//               builder: (BuildContext context, dynamic value, Widget? child) {
//                 return Transform.scale(
//                   scale: value,
//                   alignment: Alignment.center,
//                   child: child,
//                 );
//               },
//               tween: Tween(begin: 0.0, end: 1.0),
//               child: ConstrainedBox(
//                 // decoration: BoxDecoration(
//                 //   border: Border.all(color: Colors.white),
//                 // ),
//                 constraints: BoxConstraints(
//                   minHeight: menuHeight,
//                   maxWidth: maxMenuWidth,
//                   maxHeight: dmaxMenuHeight,
//                 ),
//                 child: ClipRRect(
//                   borderRadius:
//                       menuBoxDecoration?.borderRadius ??
//                       const BorderRadius.all(Radius.circular(5.0)),
//                   clipBehavior: Clip.antiAlias,
//                   child: ColoredBox(
//                     color: Theme.of(context).cardColor.withAlpha(200),
//                     child: Container(
//                       decoration:
//                           menuBoxDecoration ??
//                           BoxDecoration(
//                             color: Colors.grey.shade200,
//                             borderRadius: const BorderRadius.all(
//                               Radius.circular(5.0),
//                             ),
//                             boxShadow: [
//                               const BoxShadow(
//                                 color: Colors.black38,
//                                 blurRadius: 10,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                       clipBehavior: Clip.antiAlias,
//                       child: ListView.separated(
//                         itemCount: menuItems.length,
//                         padding: EdgeInsets.zero,
//                         shrinkWrap: true,
//                         separatorBuilder: (context, index) {
//                           return Divider(
//                             height: 0.3,
//                             color: Colors.grey.shade400,
//                           );
//                         },
//                         itemBuilder: (context, index) {
//                           FocusedMenuItem item = menuItems[index];
//                           Widget listItem = GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                               item.onPressed();
//                             },
//                             child: Container(
//                               alignment: Alignment.center,
//                               margin: const EdgeInsets.only(bottom: 1),
//                               color: item.backgroundColor ?? Colors.white,
//                               height: itemExtent,
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 8.0,
//                                   horizontal: 14,
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: <Widget>[
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.stretch,
//                                         mainAxisSize: MainAxisSize.min,
//                                         spacing: 2,
//                                         children: [
//                                           item.title,
//                                           if (item.subtitle != null) ...[
//                                             item.subtitle!,
//                                           ],
//                                         ],
//                                       ),
//                                     ),
//                                     if (item.trailingIcon != null) ...[
//                                       item.trailingIcon!,
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                           if (animateMenu) {
//                             return TweenAnimationBuilder(
//                               builder: (context, dynamic value, child) {
//                                 return Transform(
//                                   transform: Matrix4.rotationX(1.5708 * value),
//                                   alignment: Alignment.bottomCenter,
//                                   child: child,
//                                 );
//                               },
//                               tween: Tween(begin: 1.0, end: 0.0),
//                               duration: Duration(milliseconds: index * 200),
//                               child: listItem,
//                             );
//                           } else {
//                             return listItem;
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: _childOffset.dy,
//             left: _childOffset.dx,
//             child: SizedBox(
//               width: _childSize.width,
//               // height: _childSize.height,
//               child: child,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FocusedMenuItem {
//   Color? backgroundColor;
//   Widget title;
//   Widget? subtitle;
//   Widget? trailingIcon;
//   Function onPressed;

//   FocusedMenuItem({
//     this.backgroundColor,
//     required this.title,
//     this.subtitle,
//     this.trailingIcon,
//     required this.onPressed,
//   });
// }
