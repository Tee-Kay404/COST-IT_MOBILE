import '../enums/billing_enums.dart';
import '../models/billing_models.dart';

/// Abstract contract for all billing operations.
///
/// The concrete implementation will call your backend, which in turn
/// talks to Stripe. No Stripe SDK touches this interface or its callers.
abstract class IBillingService {
  /// TODO: GET /api/billing/plans
  Future<List<SubscriptionPlan>> fetchAvailablePlans();

  /// TODO: GET /api/billing/subscription  (authenticated)
  Future<UserSubscription?> fetchCurrentSubscription();

  /// Initiates checkout. Returns a Stripe checkout session ID / redirect URL.
  /// TODO: POST /api/billing/checkout  { planType, cycle }
  Future<String> createCheckoutSession({
    required SubscriptionType planType,
    required BillingCycle cycle,
  });

  /// Confirms payment and activates the subscription server-side.
  /// TODO: POST /api/billing/verify  { sessionId }
  Future<UserSubscription> verifyPayment({required String sessionId});

  /// TODO: DELETE /api/billing/subscription
  Future<void> cancelSubscription();

  /// Mobile IAP receipt restore.
  /// TODO: POST /api/billing/restore  { receipt }
  Future<UserSubscription?> restorePurchases();

  /// Called by a webhook handler or polling mechanism.
  /// TODO: PATCH /api/billing/subscription/expire
  Future<void> handleExpiredSubscription();
}