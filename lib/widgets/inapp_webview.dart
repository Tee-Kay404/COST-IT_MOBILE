// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class FacilPayInAppBrowser extends InAppBrowser {
//   @override
//   Future onBrowserCreated() async {
//     print("Browser Created!");
//   }

//   @override
//   Future onLoadStart(url) async {
//     print("Started $url");
//   }

//   @override
//   Future onLoadStop(url) async {
//     print("Stopped $url");
//   }

//   @override
//   void onExit() {
//     print("Browser closed!");
//   }
// }

// class FacilPayBrowserView extends StatefulWidget {
//   const FacilPayBrowserView({super.key});

//   @override
//   State<FacilPayBrowserView> createState() => _FacilPayBrowserViewState();
// }

// class _FacilPayBrowserViewState extends State<FacilPayBrowserView> {
//   final browser = FacilPayInAppBrowser();

//   final settings = InAppBrowserClassSettings(
//       browserSettings: InAppBrowserSettings(
//           hideUrlBar: true,
//           toolbarTopBackgroundColor: Colors.white,
//           presentationStyle: ModalPresentationStyle.POPOVER),
//       webViewSettings: InAppWebViewSettings(isInspectable: kDebugMode));

//   @override
//   void initState() {
//     super.initState();

//     browser.addMenuItem(InAppBrowserMenuItem(
//       id: 0,
//       title: 'Open in',
//       iconColor: Colors.black,
//       order: 0,
//       onClick: () {
//         browser.webViewController?.reload();
//       },
//     ));

//     browser.addMenuItem(InAppBrowserMenuItem(
//       id: 1,
//       title: 'Bookmark',
//       showAsAction: true,
//       order: 2,
//       onClick: () {
//         browser.webViewController?.reload();
//       },
//     ));

//     dynamic icon;
//     if ([TargetPlatform.iOS].contains(defaultTargetPlatform)) {
//       icon = UIImage(systemName: 'ellipsis.circle');
//     } else if (defaultTargetPlatform == TargetPlatform.android) {
//       icon =
//           AndroidResource.drawable(name: 'ic_menu_edit', defPackage: 'android');
//     }
//     browser.addMenuItem(InAppBrowserMenuItem(
//       id: 2,
//       title: 'Menu Item 2',
//       icon: icon,
//       iconColor: Colors.red,
//       showAsAction: true,
//       order: 1,
//       onClick: () {
//         browser.webViewController?.reload();
//       },
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('InAppBrowser Menu Items Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//             onPressed: () {
//               browser.openUrlRequest(
//                   urlRequest: URLRequest(url: WebUri("https://flutter.dev")),
//                   settings: settings);
//             },
//             child: const Text("Open InAppBrowser")),
//       ),
//     );
//   }
// }

// class FacilPayInAppWebView extends StatefulWidget {
//   final WebViewEnvironment? webViewEnvironment;
//   final Uri url;
//   const FacilPayInAppWebView(
//       {super.key, this.webViewEnvironment, required this.url});

//   @override
//   State<FacilPayInAppWebView> createState() => _FacilPayInAppWebViewState();
// }

// class _FacilPayInAppWebViewState extends State<FacilPayInAppWebView> {
//   final GlobalKey webViewKey = GlobalKey();
//   WebViewEnvironment? webViewEnvironment;

//   late InAppWebViewController webViewController;
//   InAppWebViewSettings settings = InAppWebViewSettings(
//     isInspectable: kDebugMode,
//     mediaPlaybackRequiresUserGesture: false,
//     allowsInlineMediaPlayback: true,
//     javaScriptEnabled: true,
//     iframeAllow: "camera; microphone",
//     iframeAllowFullscreen: true,
//   );

//   PullToRefreshController? pullToRefreshController;
//   String url = "";
//   double progress = 0;
//   final urlController = TextEditingController();
//   String? title;

//   @override
//   void initState() {
//     super.initState();

//     urlController.text = widget.url.toString();
//     webViewEnvironment = widget.webViewEnvironment;
//     webViewController = InAppWebViewController.fromPlatform(
//       platform: PlatformInAppWebViewController.static(),
//     );

//     pullToRefreshController = kIsWeb ||
//             ![TargetPlatform.iOS, TargetPlatform.android]
//                 .contains(defaultTargetPlatform)
//         ? null
//         : PullToRefreshController(
//             settings: PullToRefreshSettings(
//               color: Colors.blue,
//             ),
//             onRefresh: () async {
//               if (defaultTargetPlatform == TargetPlatform.android) {
//                 webViewController.reload();
//               } else if (defaultTargetPlatform == TargetPlatform.iOS) {
//                 webViewController.loadUrl(
//                     urlRequest:
//                         URLRequest(url: await webViewController.getUrl()));
//               }
//             },
//           );
//   }

//   @override
//   void dispose() {
//     urlController.dispose();
//     webViewController.dispose();
//     pullToRefreshController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         SliverAppBar(
//           elevation: 1,
//           pinned: true,
//           primary: false,
//           scrolledUnderElevation: 1,
//           forceMaterialTransparency: false,
//           shadowColor: Colors.black54,
//           leading: Builder(
//             builder: (context) {
//               Widget button = CloseButton();
//               webViewController.canGoBack().then((val) {
//                 if (val == true) {
//                   button = BackButton(
//                     onPressed: () {
//                       webViewController.goBackOrForward(steps: -1);
//                     },
//                   );
//                 }
//               });
//               return button;
//             },
//           ),
//           title: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             spacing: 4,
//             children: [
//               AnimatedVisibility(
//                 visible: title != null,
//                 animationType: AnimationType.sizeAndFade,
//                 child: Text(
//                   title ?? "Facil Webview",
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//               ),
//               Text(
//                 urlController.text,
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ],
//           ),
//           // actions: [
//           //   IconButton(
//           //     onPressed: () {},
//           //     icon: Icon(Icons.keyboard_arrow_down),
//           //   ),
//           //   PopupMenuButton(
//           //     icon: Icon(Icons.more_vert),
//           //     constraints: BoxConstraints(minWidth: 160),
//           //     borderRadius: BorderRadius.all(Radius.circular(12)),
//           //     itemBuilder: (context) {
//           //       return [
//           //         PopupMenuItem(child: Text("Open in")),
//           //       ];
//           //     },
//           //   )
//           // ],
//         ),
//         SliverFillRemaining(
//           child: SafeArea(
//             top: false,
//             bottom: false,
//             child: Stack(
//               children: [
//                 InAppWebView(
//                   key: webViewKey,
//                   webViewEnvironment: webViewEnvironment,
//                   initialUrlRequest:
//                       URLRequest(url: WebUri(urlController.text)),
//                   initialSettings: settings,
//                   pullToRefreshController: pullToRefreshController,
//                   gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
//                     ..add(Factory<VerticalDragGestureRecognizer>(
//                         () => VerticalDragGestureRecognizer())),
//                   onWebViewCreated: (controller) {
//                     webViewController = controller;
//                   },
//                   onLoadStart: (controller, url) {
//                     setState(() {
//                       this.url = url.toString();
//                       urlController.text = this.url;
//                     });
//                   },
//                   onPermissionRequest: (controller, request) async {
//                     return PermissionResponse(
//                         resources: request.resources,
//                         action: PermissionResponseAction.GRANT);
//                   },
//                   shouldOverrideUrlLoading:
//                       (controller, navigationAction) async {
//                     var uri = navigationAction.request.url!;

//                     if (![
//                       "http",
//                       "https",
//                       "file",
//                       "chrome",
//                       "data",
//                       "javascript",
//                       "about"
//                     ].contains(uri.scheme)) {
//                       if (await canLaunchUrl(uri)) {
//                         // Launch the App
//                         await launchUrl(
//                           uri,
//                         );
//                         // and cancel the request
//                         return NavigationActionPolicy.CANCEL;
//                       }
//                     }

//                     return NavigationActionPolicy.ALLOW;
//                   },
//                   onLoadStop: (controller, url) async {
//                     String? dtitle = await controller.getTitle();
//                     final tags = await controller.getMetaTags();
//                     if (dtitle == null || dtitle.isEmpty) {
//                       dtitle = tags
//                           .where((e) => [
//                                 'application-name',
//                                 'title',
//                                 'description'
//                               ].any((t) => t == e.name))
//                           .firstOrNull
//                           ?.content;
//                     }
//                     log("Mesta Tags: $tags");

//                     pullToRefreshController?.endRefreshing();
//                     setState(() {
//                       this.url = url.toString();
//                       urlController.text = this.url;
//                       title = dtitle;
//                     });
//                   },
//                   onReceivedError: (controller, request, error) {
//                     pullToRefreshController?.endRefreshing();
//                   },
//                   onProgressChanged: (controller, progress) {
//                     if (progress == 100) {
//                       pullToRefreshController?.endRefreshing();
//                     }
//                     setState(() {
//                       this.progress = progress / 100;
//                       urlController.text = url;
//                     });
//                   },
//                   onUpdateVisitedHistory: (controller, url, androidIsReload) {
//                     setState(() {
//                       this.url = url.toString();
//                       urlController.text = this.url;
//                     });
//                   },
//                   onConsoleMessage: (controller, consoleMessage) {
//                     if (kDebugMode) {
//                       print(consoleMessage);
//                     }
//                   },
//                 ),
//                 progress < 1.0
//                     ? LinearProgressIndicator(value: progress)
//                     : Container(),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// Future openUrlInApp(BuildContext context, Uri url) async {
//   // final webViewEnv =
//   //     await WebViewEnvironment.create(settings: WebViewEnvironmentSettings());
//   // final browser = FacilPayInAppBrowser();
//   // browser.addMenuItem(
//   //   InAppBrowserMenuItem(
//   //     id: 0,
//   //     title: 'Open ',
//   //     iconColor: Colors.black,
//   //     order: 0,
//   //     onClick: () {
//   //       browser.webViewController?.reload();
//   //     },
//   //   ),
//   // );
//   // return browser.openUrlRequest(
//   //   urlRequest: URLRequest(url: WebUri("https://flutter.dev")),
//   //   settings: InAppBrowserClassSettings(
//   //     browserSettings: InAppBrowserSettings(
//   //       hideCloseButton: false,
//   //       shouldCloseOnBackButtonPressed: true,
//   //     ),
//   //   ),
//   // );

//   return showCupertinoModalBottomSheet<void>(
//     context: context,
//     useRootNavigator: true,
//     builder: (BuildContext context) {
//       return FacilPayInAppWebView(url: url);
//     },
//   );

//   // return showModalBottomSheet(
//   //   context: context,
//   //   useSafeArea: true,
//   //   constraints: BoxConstraints(
//   //     minHeight: MediaQuery.of(context).size.height,
//   //   ),
//   //   isScrollControlled: true,
//   //   builder: (context) {
//   //     return FacilInAppWebView(
//   //       // webViewEnvironment: webViewEnv,
//   //       url: url,
//   //     );
//   //   },
//   // );
// }
