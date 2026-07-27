import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:cost_it_mobile/app/global/models/app_model.dart';
import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global navigator key — allows navigation from outside the widget tree
/// (e.g. a Dio interceptor redirecting to login on 401, or a notification
/// tap handler pushing a route before any BuildContext is available).
final appNavigatorKey = GlobalKey<NavigatorState>();

/// The actual application shell.
///
/// Only ever built once [appState] has successfully resolved (see
/// [CostItApp]), so it can decide the initial route synchronously with no
/// loading branch of its own. This is also where app-wide concerns that need
/// a single, stable lifetime live: the [ErrorWidget] override, and — once
/// they're implemented — push notification and deep-link wiring.
class RootAppWidget extends ConsumerStatefulWidget {
  final AppStateModel appState;

  const RootAppWidget({super.key, required this.appState});

  @override
  ConsumerState<RootAppWidget> createState() => _RootAppWidgetState();
}

class _RootAppWidgetState extends ConsumerState<RootAppWidget> {
  @override
  void initState() {
    super.initState();

    // Track any unexpected widget-build crash instead of showing Flutter's
    // default red error screen in production. No crash-reporting service is
    // wired in yet, so this just logs locally — swap the body of this
    // callback for Sentry/Crashlytics/etc. when one is added.
    final defaultBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (FlutterErrorDetails details) {
      log('Unhandled widget error: ${details.exceptionAsString()}');
      return defaultBuilder(details);
    };

    if (widget.appState.isLoggedIn) {
      _initPushNotifications();
    }

    _initDeepLinks();
  }

  /// Stub: wire up FCM / local notifications here once the project needs
  /// them. Kept as an explicit no-op rather than omitted so the seam is
  /// obvious next time push notifications come up.
  Future<void> _initPushNotifications() async {
    // TODO: initialise FirebaseMessaging / flutter_local_notifications here.
  }

  /// Stub: wire up app_links / uni_links here once deep-linking is needed.
  /// See [_parseIncomingUri] for where a resolved link should be handled.
  Future<void> _initDeepLinks() async {
    // TODO: listen for incoming links (e.g. via app_links) and call
    // _parseIncomingUri with the result.
  }

  /// Stub: given an incoming deep link, decide which route to push and with
  /// what arguments, then push it via [appNavigatorKey]. Not called yet —
  /// this exists so the shape is already here when deep-linking is added.
  // void _parseIncomingUri(Uri? uri) {
  //   if (uri == null) return;

  //   log('Received deep link: ${uri.path}');
  //   // TODO: map uri.path to a PageRoutes value and push it, e.g.
  //   // appNavigatorKey.currentState?.pushNamed(route, arguments: args);
  // }

  String get _initialRoute {
    if (!widget.appState.hasOnboarded) {
      return PageRoutes.onBoarding.name;
    } else if (widget.appState.isLoggedIn) {
      return PageRoutes.dashBoard.name;
    } else {
      return PageRoutes.login.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch from Riverpod so any theme change triggers an instant rebuild
    final themeMode = ref.watch(appStateProvider).settings.themeMode;

    return MaterialApp(
      navigatorKey: appNavigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightMode,
      darkTheme: AppTheme.darkMode,
      themeMode: themeMode,
      builder: BotToastInit(),
      initialRoute: _initialRoute,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
