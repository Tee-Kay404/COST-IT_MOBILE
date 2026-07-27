enum BillingCycle {
  monthly,
  yearly;

  String get label => switch (this) {
    BillingCycle.monthly => 'Monthly',
    BillingCycle.yearly => 'Yearly',
  };
}

enum SubscriptionType {
  basic,
  super_;

  String get label => switch (this) {
    SubscriptionType.basic => 'Basic',
    SubscriptionType.super_ => 'Super',
  };
}

enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  pending,
  trial,
  failed;

  bool get isUsable =>
      this == SubscriptionStatus.active || this == SubscriptionStatus.trial;
}

enum PurchaseState { idle, loading, success, failed }
