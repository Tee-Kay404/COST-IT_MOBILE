import '../enums/billing_enums.dart';
import '../models/billing_models.dart';

/// Immutable state snapshot for the entire billing feature.
class BillingState {
  final SubscriptionType selectedPlan;
  final BillingCycle selectedCycle;
  final List<SubscriptionPlan> availablePlans;
  final UserSubscription? activeSubscription;
  final PurchaseState purchaseState;
  final bool isLoadingPlans;
  final String? error;

  const BillingState({
    this.selectedPlan = SubscriptionType.basic,
    this.selectedCycle = BillingCycle.yearly,
    this.availablePlans = const [],
    this.activeSubscription,
    this.purchaseState = PurchaseState.idle,
    this.isLoadingPlans = false,
    this.error,
  });


  /// The full plan object for [selectedPlan], or null while loading.
  SubscriptionPlan? get selectedPlanData {
    for (final p in availablePlans) {
      if (p.type == selectedPlan) return p;
    }
    return null;
  }

  /// True when the user already has [selectedPlan] active.
  bool get isCurrentPlan =>
      activeSubscription != null &&
      activeSubscription!.type == selectedPlan &&
      activeSubscription!.isActive;

  BillingState copyWith({
    SubscriptionType? selectedPlan,
    BillingCycle? selectedCycle,
    List<SubscriptionPlan>? availablePlans,
    UserSubscription? activeSubscription,
    bool clearSubscription = false,
    PurchaseState? purchaseState,
    bool? isLoadingPlans,
    String? error,
    bool clearError = false,
  }) =>
      BillingState(
        selectedPlan: selectedPlan ?? this.selectedPlan,
        selectedCycle: selectedCycle ?? this.selectedCycle,
        availablePlans: availablePlans ?? this.availablePlans,
        activeSubscription: clearSubscription
            ? null
            : (activeSubscription ?? this.activeSubscription),
        purchaseState: purchaseState ?? this.purchaseState,
        isLoadingPlans: isLoadingPlans ?? this.isLoadingPlans,
        error: clearError ? null : (error ?? this.error),
      );
}