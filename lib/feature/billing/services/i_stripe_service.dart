/// Stripe-specific operations, fully isolated from the rest of the app.
///
/// Every method maps to one backend endpoint. The UI never imports this.
/// TODO: Implement [StripeServiceImpl] backed by your NestJS COST-IT_API.
abstract class IStripeService {
  /// TODO: POST /stripe/customers
  Future<String> createCustomer({required String email, String? name});

  /// Returns a Stripe Checkout Session ID for client-side redirect.
  /// TODO: POST /stripe/checkout-sessions  { customerId, priceId }
  Future<String> createCheckoutSession({
    required String customerId,
    required String priceId,
  });

  /// TODO: GET /stripe/customers/:id/payment-methods
  Future<Map<String, dynamic>?> getPaymentMethod({required String customerId});

  /// Cancels at period end to avoid immediate loss of access.
  /// TODO: PATCH /stripe/subscriptions/:id  { cancel_at_period_end: true }
  Future<void> cancelSubscription({required String subscriptionId});

  /// Un-schedules a pending cancellation.
  /// TODO: PATCH /stripe/subscriptions/:id  { cancel_at_period_end: false }
  Future<void> resumeSubscription({required String subscriptionId});

  /// TODO: POST /stripe/subscriptions/:id/discounts  { coupon }
  Future<void> applyPromoCode({
    required String subscriptionId,
    required String promoCode,
  });
}