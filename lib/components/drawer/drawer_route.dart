import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/dialogbox.dart';
import 'package:flutter/material.dart';

enum DrawerRoute {
  home,
  categories,
  saved,
  orders,
  settings,
  contactUs,
  rateApp,
  logout;

  bool get isDestructive => this == DrawerRoute.logout;

  void navigate(BuildContext context, {required VoidCallback onLogout}) {
    switch (this) {
      case DrawerRoute.logout:
        Navigator.of(context).pop();
        onLogout();

      case DrawerRoute.home:
        Navigator.of(context).pop();
        Navigator.of(context).popUntil((route) => route.isFirst);

      case DrawerRoute.categories:
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(PageRoutes.categories.name);

      case DrawerRoute.saved:
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(PageRoutes.saved.name);

      case DrawerRoute.orders:
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(PageRoutes.orders.name);

      case DrawerRoute.settings:
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(PageRoutes.settings.name);

      case DrawerRoute.contactUs:
      case DrawerRoute.rateApp:
        Navigator.of(context).pop();
        showFeatureNotEnabledDialog(context);
    }
  }
}