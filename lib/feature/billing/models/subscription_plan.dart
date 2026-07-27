import '../enums/billing_enums.dart';
import 'plan_feature.dart';

class PlanPricing {
  final double monthlyPrice;
  final double yearlyPrice;
  final String currency;
  final String currencySymbol;

  const PlanPricing({
    required this.monthlyPrice,
    required this.yearlyPrice,
    this.currency = 'NGN',
    this.currencySymbol = '₦',
  });

  double priceFor(BillingCycle cycle) =>
      cycle == BillingCycle.monthly ? monthlyPrice : yearlyPrice;

  String formattedPrice(BillingCycle cycle) {
    final value = priceFor(cycle).toStringAsFixed(0);
    final withCommas = value.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$currencySymbol$withCommas';
  }

  int get yearlySavingsPercent {
    final annualised = monthlyPrice * 12;
    if (annualised == 0) return 0;
    return ((annualised - yearlyPrice) / annualised * 100).round();
  }
}

class SubscriptionPlan {
  final SubscriptionType type;
  final String name;
  final String tagline;
  final PlanPricing pricing;
  final List<PlanFeature> features;
  final bool isPopular;

  final int? trialDays;

  const SubscriptionPlan({
    required this.type,
    required this.name,
    required this.tagline,
    required this.pricing,
    required this.features,
    this.isPopular = false,
    this.trialDays,
  });
}