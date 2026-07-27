import 'package:flutter/material.dart';

import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';

import '../models/billing_models.dart';

/// All payment logic is triggered via [onSubscribe] — the button itself
/// is completely payment-agnostic. Wire it to [BillingNotifier.subscribe].
class SubscriptionButton extends StatelessWidget {
  final SubscriptionType selectedPlan;
  final UserSubscription? activeSubscription;
  final bool isLoading;
  final bool isCurrentPlan;

  /// TODO: calls [BillingNotifier.subscribe] → eventually opens Stripe checkout.
  final VoidCallback? onSubscribe;

  const SubscriptionButton({
    super.key,
    required this.selectedPlan,
    required this.isLoading,
    required this.isCurrentPlan,
    this.activeSubscription,
    this.onSubscribe,
  });

  String get _label {
    if (isLoading) return 'Processing...';
    if (isCurrentPlan) return 'Current Plan';
    if (activeSubscription != null) {
      return 'Switch to ${selectedPlan.label}';
    }
    return 'Start 7-Day Free Trial';
  }

  @override
  Widget build(BuildContext context) {
    return SharedButton(
      text: _label,
      onPressed: (isCurrentPlan || isLoading) ? null : onSubscribe,
      color: isCurrentPlan ? context.color.surface : context.color.primary,
      textColor: isCurrentPlan ? context.color.primary : Colors.white,
      disabled: isCurrentPlan
          ? context.color.surface
          : context.color.primary.withValues(alpha: 0.55),
      disabledForeground: isCurrentPlan
          ? context.color.primary.withValues(alpha: 0.5)
          : Colors.white.withValues(alpha: 0.6),
    );
  }
}