import 'dart:async';
import 'dart:developer';

import '../enums/billing_enums.dart';
import '../models/billing_models.dart';
import '../utils/billing_constant.dart';
import 'subscription_repository.dart';

/// Mock repository used until the COST-IT_API billing endpoints are ready.
///
/// Swap this for [ApiSubscriptionRepository] in [subscriptionRepositoryProvider]
/// without touching a single widget or notifier.
class MockSubscriptionRepository implements ISubscriptionRepository {
  @override
  Future<List<SubscriptionPlan>> getPlans() async {
    // TODO: GET /api/billing/plans
    await Future.delayed(const Duration(milliseconds: 500));
    return BillingConstants.plans;
  }

  @override
  Future<UserSubscription?> getActiveSubscription() async {
    // TODO: GET /api/billing/subscription (authenticated)
    await Future.delayed(const Duration(milliseconds: 300));
    // Return null to simulate a free-tier user.
    return null;
  }

  @override
  Future<UserSubscription> subscribe({
    required SubscriptionType planType,
    required BillingCycle cycle,
  }) async {
    log('[MockRepo] subscribe: ${planType.name} / ${cycle.name}');
    // TODO: Initiate Stripe checkout via POST /api/billing/checkout
    await Future.delayed(const Duration(seconds: 2));

    final now = DateTime.now();
    return UserSubscription(
      id: 'mock_${now.millisecondsSinceEpoch}',
      type: planType,
      cycle: cycle,
      status: SubscriptionStatus.trial,
      startDate: now,
      expiryDate: cycle == BillingCycle.monthly
          ? now.add(const Duration(days: 30))
          : now.add(const Duration(days: 365)),
    );
  }

  @override
  Future<void> cancel() async {
    // TODO: DELETE /api/billing/subscription
    await Future.delayed(const Duration(milliseconds: 800));
    log('[MockRepo] Subscription cancelled');
  }

  @override
  Future<UserSubscription?> restore() async {
    // TODO: POST /api/billing/restore { receipt }
    await Future.delayed(const Duration(seconds: 1));
    log('[MockRepo] No previous purchase found (mock)');
    return null;
  }

  @override
  Future<void> persistSubscription(UserSubscription subscription) async {
    // TODO: HiveStorageService.addItem('active_subscription', subscription.toMap())
    log('[MockRepo] persist → ${subscription.toMap()}');
  }

  @override
  Future<void> clearSubscription() async {
    // TODO: HiveStorageService.removeItem('active_subscription')
    log('[MockRepo] Cleared local subscription');
  }
}