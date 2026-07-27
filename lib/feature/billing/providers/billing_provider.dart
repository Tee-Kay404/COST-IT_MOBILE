import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/billing_enums.dart';
import '../models/billing_models.dart';
import '../services/mock_subscription_repo.dart';
import '../services/subscription_repository.dart';
import 'billing_state.dart';

// ── Repository ────────────────────────────────────────────────────────────────
/// Swap [MockSubscriptionRepository] → your real impl here when ready.
final subscriptionRepositoryProvider = Provider<ISubscriptionRepository>(
  (_) => MockSubscriptionRepository(),
);

// ── Notifier ──────────────────────────────────────────────────────────────────
class BillingNotifier extends StateNotifier<BillingState> {
  final ISubscriptionRepository _repo;

  BillingNotifier(this._repo) : super(const BillingState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoadingPlans: true, clearError: true);
    try {
      // Fetch plans and subscription in parallel.
      final plansResult = _repo.getPlans();
      final subResult = _repo.getActiveSubscription();
      final plans = await plansResult;
      final sub = await subResult;

      state = state.copyWith(
        availablePlans: plans,
        activeSubscription: sub,
        isLoadingPlans: false,
        // Pre-select the user's current plan if they're already subscribed.
        selectedPlan:
            (sub != null) ? sub.type : state.selectedPlan,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingPlans: false,
        error: 'Could not load plans. Check your connection and try again.',
      );
    }
  }

  void selectPlan(SubscriptionType plan) {
    if (state.selectedPlan == plan) return;
    state = state.copyWith(selectedPlan: plan, clearError: true);
  }

  void selectCycle(BillingCycle cycle) {
    if (state.selectedCycle == cycle) return;
    state = state.copyWith(selectedCycle: cycle, clearError: true);
  }

  /// Entry point for the purchase flow.
  /// TODO: After Stripe integration, open the checkout WebView/redirect here.
  Future<void> subscribe() async {
    if (state.isCurrentPlan ||
        state.purchaseState == PurchaseState.loading) return;

    state = state.copyWith(
      purchaseState: PurchaseState.loading,
      clearError: true,
    );
    try {
      final subscription = await _repo.subscribe(
        planType: state.selectedPlan,
        cycle: state.selectedCycle,
      );
      await _repo.persistSubscription(subscription);
      state = state.copyWith(
        activeSubscription: subscription,
        purchaseState: PurchaseState.success,
      );
    } catch (_) {
      state = state.copyWith(
        purchaseState: PurchaseState.failed,
        error: 'Purchase failed. Please try again.',
      );
    }
  }

  Future<void> cancelSubscription() async {
    state = state.copyWith(
      purchaseState: PurchaseState.loading,
      clearError: true,
    );
    try {
      await _repo.cancel();
      await _repo.clearSubscription();
      state = state.copyWith(
        clearSubscription: true,
        purchaseState: PurchaseState.idle,
      );
    } catch (_) {
      state = state.copyWith(
        purchaseState: PurchaseState.failed,
        error: 'Could not cancel. Please try again.',
      );
    }
  }

  Future<void> restorePurchases() async {
    state = state.copyWith(
      purchaseState: PurchaseState.loading,
      clearError: true,
    );
    try {
      final restored = await _repo.restore();
      if (restored != null) {
        await _repo.persistSubscription(restored);
        state = state.copyWith(
          activeSubscription: restored,
          purchaseState: PurchaseState.success,
        );
      } else {
        state = state.copyWith(
          purchaseState: PurchaseState.idle,
          error: 'No previous subscription found.',
        );
      }
    } catch (_) {
      state = state.copyWith(
        purchaseState: PurchaseState.failed,
        error: 'Restore failed. Please try again.',
      );
    }
  }

  void clearError() => state = state.copyWith(clearError: true);

  void resetPurchaseState() =>
      state = state.copyWith(purchaseState: PurchaseState.idle);
}

// ── Provider ──────────────────────────────────────────────────────────────────
final billingProvider = StateNotifierProvider<BillingNotifier, BillingState>(
  (ref) => BillingNotifier(ref.read(subscriptionRepositoryProvider)),
);

// ── Convenience selectors (avoid rebuilds from unrelated state changes) ────────
final activeSubscriptionProvider = Provider<UserSubscription?>((ref) {
  return ref.watch(billingProvider).activeSubscription;
});

final isSubscribedProvider = Provider<bool>((ref) {
  return ref.watch(activeSubscriptionProvider)?.isActive ?? false;
});

final selectedPlanTypeProvider = Provider<SubscriptionType>((ref) {
  return ref.watch(billingProvider).selectedPlan;
});