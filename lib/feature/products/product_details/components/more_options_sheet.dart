import 'package:flutter/material.dart';

class MoreOptionsSheetHelper {
  static List<Map<String, dynamic>> buildMoreOptions(BuildContext context) => [
    {
      'icon': Icons.share_outlined,
      'label': 'Share this listing',
      'onTap': () {
        Navigator.pop(context);
      },
    },
    {
      'icon': Icons.person_add_outlined,
      'label': 'Follow this vendor',
      'onTap': () {
        Navigator.pop(context);
      },
    },
    {
      'icon': Icons.visibility_off_outlined,
      'label': 'Hide this listing',
      'onTap': () {
        Navigator.pop(context);
      },
    },
    {
      'icon': Icons.person_off_outlined,
      'label': 'Hide listings from this vendor',
      'onTap': () {
        Navigator.pop(context);
      },
    },
  ];
}
