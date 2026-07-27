import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> accountSections = [
  {
    'sectionTitle': 'Account',
    'tiles': [
      {
        'title': 'Manage Profile',
        'icon': Icons.person_outline_rounded,
        'route': PageRoutes.editProfile.name,
      },
      {
        'title': 'My Addresses',
        'icon': Icons.location_on_outlined,
        'route': PageRoutes.locationEdit.name,
      },
    ],
  },
  {
    'sectionTitle': 'My Activities',
    'tiles': [

      {
        'title': 'Saved Products',
        'icon': Icons.bookmark_border_rounded,
        'route': PageRoutes.saved.name,
      },
      {
        'title': 'Recently Viewed',
        'icon': Icons.history_rounded,
        'route': PageRoutes.recentlyViewed.name,
      },
    ],
  },
  {
    'sectionTitle': 'Selling',
    'tiles': [
      {'title': 'Vendor Dashboard', 'icon': Icons.storefront_outlined},
      {
        'title': 'My Listings',
        'icon': Icons.inventory_2_outlined,
        'route': 'myListings',
      },
      {
        'title': 'Payouts & Earnings',
        'icon': Icons.account_balance_wallet_outlined,
      },
    ],
  },
  {
    'sectionTitle': 'Billing & Subscriptions',
    'tiles': [
      {
        'title': 'My Subscription',
        'icon': Icons.workspace_premium_outlined,
        'route': PageRoutes.billing.name,
      },
      {'title': 'Payment Methods', 'icon': Icons.credit_card_outlined},
      {'title': 'Transaction History', 'icon': Icons.receipt_outlined},
    ],
  },
  {
    'sectionTitle': 'Support',
    'tiles': [
      {'title': 'Help Center', 'icon': Icons.help_outline_rounded},
      {'title': 'Contact Us', 'icon': Icons.headset_mic_outlined},
      {'title': 'Rate the App', 'icon': Icons.star_outline_rounded},
    ],
  },
];
