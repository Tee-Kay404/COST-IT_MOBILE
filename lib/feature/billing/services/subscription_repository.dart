import '../enums/billing_enums.dart';
import '../models/billing_models.dart';

/// Repository interface. Providers only ever talk to this contract —
/// never to [IBillingService] or [IStripeService] directly.
abstract class ISubscriptionRepository {
  Future<List<SubscriptionPlan>> getPlans();
  Future<UserSubscription?> getActiveSubscription();

  Future<UserSubscription> subscribe({
    required SubscriptionType planType,
    required BillingCycle cycle,
  });

  Future<void> cancel();
  Future<UserSubscription?> restore();

  // ── Local persistence (Hive) ────────────────────────────────────────
  /// TODO: store subscription.toMap() via HiveStorageService key 'active_subscription'
  Future<void> persistSubscription(UserSubscription subscription);

  /// TODO: remove 'active_subscription' from Hive
  Future<void> clearSubscription();
}