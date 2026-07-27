import 'package:flutter/material.dart';

import '../enums/billing_enums.dart';

extension SubscriptionTypeX on SubscriptionType {
  Color badgeColor(ColorScheme scheme) => switch (this) {
        SubscriptionType.basic => scheme.primary,
        SubscriptionType.super_ => const Color(0xFFFFD700),
      };

  String get badgeLabel => switch (this) {
        SubscriptionType.basic => 'Basic',
        SubscriptionType.super_ => 'Super ✦',
      };
}

extension SubscriptionStatusX on SubscriptionStatus {
  Color get indicatorColor => switch (this) {
        SubscriptionStatus.active => const Color(0xFF22C55E),
        SubscriptionStatus.trial => const Color(0xFF3B82F6),
        SubscriptionStatus.expired => const Color(0xFFEF4444),
        SubscriptionStatus.cancelled => const Color(0xFFF97316),
        SubscriptionStatus.pending => const Color(0xFFF59E0B),
        SubscriptionStatus.failed => const Color(0xFFEF4444),
      };

  String get displayLabel => switch (this) {
        SubscriptionStatus.active => 'Active',
        SubscriptionStatus.trial => 'Trial',
        SubscriptionStatus.expired => 'Expired',
        SubscriptionStatus.cancelled => 'Cancelled',
        SubscriptionStatus.pending => 'Pending',
        SubscriptionStatus.failed => 'Payment Failed',
      };
}