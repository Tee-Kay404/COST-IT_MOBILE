class SpecialOffer {
  final String id;
  final String discountLabel;
  final String? badgeText;
  final DateTime? expiresAt;
  final bool isActive;

  const SpecialOffer({
    required this.id,
    required this.discountLabel,
    this.badgeText,
    this.expiresAt,
    this.isActive = true,
  });

  factory SpecialOffer.fromJson(Map<String, dynamic> json) {
    return SpecialOffer(
      id: json['id'] as String,
      discountLabel: json['discountLabel'] as String,
      badgeText: json['badgeText'] as String?,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'discountLabel': discountLabel,
        'badgeText': badgeText,
        'expiresAt': expiresAt?.toIso8601String(),
        'isActive': isActive,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialOffer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SpecialOffer(id: $id, discountLabel: $discountLabel)';
}