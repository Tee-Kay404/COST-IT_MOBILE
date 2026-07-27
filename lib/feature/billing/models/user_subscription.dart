import '../enums/billing_enums.dart';

class UserSubscription {
  final String id;
  final SubscriptionType type;
  final BillingCycle cycle;
  final SubscriptionStatus status;
  final DateTime? startDate;
  final DateTime? expiryDate;

  // ── Future Stripe fields ─────────────────────────────────────────────
  // TODO: Populate these from the backend after Stripe integration.
  final String? stripeCustomerId;
  final String? stripeSubscriptionId;
  final String? stripePaymentMethodId;

  const UserSubscription({
    required this.id,
    required this.type,
    required this.cycle,
    required this.status,
    this.startDate,
    this.expiryDate,
    this.stripeCustomerId,
    this.stripeSubscriptionId,
    this.stripePaymentMethodId,
  });

  bool get isActive => status.isUsable;
  bool get isTrial => status == SubscriptionStatus.trial;

  int? get daysLeft {
    if (expiryDate == null) return null;
    final remaining = expiryDate!.difference(DateTime.now()).inDays;
    return remaining < 0 ? 0 : remaining;
  }
  UserSubscription copyWith({
    String? id,
    SubscriptionType? type,
    BillingCycle? cycle,
    SubscriptionStatus? status,
    DateTime? startDate,
    DateTime? expiryDate,
    String? stripeCustomerId,
    String? stripeSubscriptionId,
    String? stripePaymentMethodId,
  }) =>
      UserSubscription(
        id: id ?? this.id,
        type: type ?? this.type,
        cycle: cycle ?? this.cycle,
        status: status ?? this.status,
        startDate: startDate ?? this.startDate,
        expiryDate: expiryDate ?? this.expiryDate,
        stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
        stripeSubscriptionId: stripeSubscriptionId ?? this.stripeSubscriptionId,
        stripePaymentMethodId:
            stripePaymentMethodId ?? this.stripePaymentMethodId,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type.name,
        'cycle': cycle.name,
        'status': status.name,
        'startDate': startDate?.toIso8601String(),
        'expiryDate': expiryDate?.toIso8601String(),
        'stripeCustomerId': stripeCustomerId,
        'stripeSubscriptionId': stripeSubscriptionId,
        'stripePaymentMethodId': stripePaymentMethodId,
      };

  factory UserSubscription.fromMap(Map<String, dynamic> map) =>
      UserSubscription(
        id: map['id'] as String,
        type: SubscriptionType.values.firstWhere(
          (e) => e.name == map['type'],
          orElse: () => SubscriptionType.basic,
        ),
        cycle: BillingCycle.values.firstWhere(
          (e) => e.name == map['cycle'],
          orElse: () => BillingCycle.monthly,
        ),
        status: SubscriptionStatus.values.firstWhere(
          (e) => e.name == map['status'],
          orElse: () => SubscriptionStatus.active,
        ),
        startDate: map['startDate'] != null
            ? DateTime.tryParse(map['startDate'] as String)
            : null,
        expiryDate: map['expiryDate'] != null
            ? DateTime.tryParse(map['expiryDate'] as String)
            : null,
        stripeCustomerId: map['stripeCustomerId'] as String?,
        stripeSubscriptionId: map['stripeSubscriptionId'] as String?,
        stripePaymentMethodId: map['stripePaymentMethodId'] as String?,
      );
}