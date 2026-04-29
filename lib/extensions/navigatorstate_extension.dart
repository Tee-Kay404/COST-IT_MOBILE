import 'package:flutter/widgets.dart';

extension NavigatorStateExtension on NavigatorState {
  popUntilOrPushReplacementNamed(String namedRoute, {Object? arguments}) {
    bool exists = false;
    Navigator.of(context).popUntil((route) {
      bool pathExists = route.settings.name == namedRoute;
      if (pathExists) {
        exists = true;
        return true;
      }
      return false;
    });
    if (!exists) {
      Navigator.of(context).pushNamed(namedRoute, arguments: arguments);
    }
  }
}
