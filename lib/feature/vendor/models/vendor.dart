import 'package:cost_it_mobile/widgets/tools.dart';

class ProductVendor {
  final String id;
  final String name;
  final String? logoUrl;
  final double rating;
  final String? location;
  final bool isVerified;
  final String? phoneNumber;

  const ProductVendor({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.rating,
    this.isVerified = false,
    this.location,
    this.phoneNumber,
  });

  factory ProductVendor.fromJson(Map<String, dynamic> json) {
    return ProductVendor(
      id: json['id'] as String,
      name: json['name'] as String? ?? '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
      logoUrl: json['logoUrl'] as String?,
      rating: parseDouble(json['rating']),
      isVerified: json['isVerified'] as bool? ?? json['verifiedAt'] != null,
      location: json['location'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'logoUrl': logoUrl,
    'rating': rating,
    'isVerified': isVerified,
    'location': location,
    'phoneNumber': phoneNumber,
  };
}