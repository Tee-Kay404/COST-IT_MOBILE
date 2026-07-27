import 'package:flutter/material.dart';

import '../enums/billing_enums.dart';
import '../models/billing_models.dart';

class BillingConstants {
  BillingConstants._();

  static const List<SubscriptionPlan> plans = [_basicPlan, _superPlan];

  static const _basicPlan = SubscriptionPlan(
    type: SubscriptionType.basic,
    name: 'Basic',
    tagline: 'Everything you need to start selling',
    pricing: PlanPricing(monthlyPrice: 2999, yearlyPrice: 24999),
    trialDays: 7,
    features: _basicFeatures,
  );

  static const _basicFeatures = <PlanFeature>[
    PlanFeature(
      id: 'b_listings',
      title: 'Up to 20 active product listings',
      icon: Icons.inventory_2_rounded,
    ),
    PlanFeature(
      id: 'b_search',
      title: 'Standard search visibility',
      icon: Icons.search_rounded,
    ),
    PlanFeature(
      id: 'b_messaging',
      title: 'Unlimited buyer messaging',
      icon: Icons.chat_bubble_outline_rounded,
    ),
    PlanFeature(
      id: 'b_analytics',
      title: 'Basic analytics — views & clicks',
      icon: Icons.bar_chart_rounded,
    ),
    PlanFeature(
      id: 'b_location',
      title: 'One store location',
      icon: Icons.location_on_outlined,
    ),
    PlanFeature(
      id: 'b_support',
      title: 'Standard email support',
      icon: Icons.support_agent_rounded,
    ),
  ];

  static const _superPlan = SubscriptionPlan(
    type: SubscriptionType.super_,
    name: 'Super',
    tagline: 'Maximum reach for serious sellers',
    pricing: PlanPricing(monthlyPrice: 6999, yearlyPrice: 59999),
    isPopular: true,
    trialDays: 7,
    features: _superFeatures,
  );

  static const _superFeatures = <PlanFeature>[
    PlanFeature(
      id: 's_listings',
      title: 'Unlimited active listings',
      icon: Icons.inventory_2_rounded,
      isHighlighted: true,
    ),
    PlanFeature(
      id: 's_priority',
      title: 'Priority search placement',
      icon: Icons.rocket_launch_rounded,
      isHighlighted: true,
    ),
    PlanFeature(
      id: 's_verified',
      title: 'Verified Seller badge',
      icon: Icons.verified_rounded,
      isHighlighted: true,
    ),
    PlanFeature(
      id: 's_analytics',
      title: 'Advanced analytics & sales insights',
      icon: Icons.insights_rounded,
      isHighlighted: true,
    ),
    PlanFeature(
      id: 's_locations',
      title: 'Up to 5 store locations',
      icon: Icons.store_rounded,
    ),
    PlanFeature(
      id: 's_bulk',
      title: 'Bulk product upload via CSV',
      icon: Icons.upload_file_rounded,
    ),
    PlanFeature(
      id: 's_boosts',
      title: '5 promotional boosts per month',
      icon: Icons.local_fire_department_rounded,
      isHighlighted: true,
    ),
    PlanFeature(
      id: 's_support',
      title: 'Priority customer support',
      icon: Icons.support_agent_rounded,
    ),
    PlanFeature(
      id: 's_invoice',
      title: 'Invoice & receipt generation',
      icon: Icons.receipt_long_rounded,
    ),
    PlanFeature(
      id: 's_featured',
      title: 'Featured on homepage',
      icon: Icons.star_rounded,
      isHighlighted: true,
    ),
  ];
}