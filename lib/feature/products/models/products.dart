import 'package:cost_it_mobile/widgets/tools.dart';
import 'package:cost_it_mobile/feature/products/models/special_offers.dart';
import 'package:cost_it_mobile/feature/vendor/models/vendor.dart';

enum PricingType {
  open,
  firm,
  flexible;

  static PricingType fromString(String value) {
    return PricingType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PricingType.open,
    );
  }
}

enum ListingStatus {
  available,
  unavailable,
  outOfStock,
  suspended,
  pendingReview,
  rejected,
  archived;

  static ListingStatus fromString(String value) {
    return ListingStatus.values.firstWhere(
      (e) => e.name == _toCamel(value),
      orElse: () => ListingStatus.unavailable,
    );
  }

  bool get isAvailable => this == ListingStatus.available;

  static String _toCamel(String s) {
    final parts = s.split('_');
    return parts.first +
        parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
  }
}



class Product {
  final String id;
  final String title;
  final String? description;
  final String categoryId;
  final String categoryLabel;
  final double price;
  final String unit;
  final PricingType pricingType;
  final ListingStatus status;
  final List<String> images;
  final String? thumbnailUrl;
  final ProductVendor vendor;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SpecialOffer? specialOffer;
  final String? location;
  final String? condition;
  final String? bulkSize;
  final double? bulkPrice;
  final int views;
  final int inquiries;
  final int quantityAvailable;
  final String? vendorSKU;

  const Product({
    required this.id,
    required this.title,
    this.description,
    required this.categoryId,
    required this.categoryLabel,
    required this.price,
    required this.unit,
    required this.pricingType,
    required this.status,
    required this.images,
    this.thumbnailUrl,
    required this.vendor,
    required this.createdAt,
    required this.updatedAt,
    this.specialOffer,
    this.location,
    this.condition,
    this.bulkSize,
    this.bulkPrice,
    this.views = 0,
    this.inquiries = 0,
    this.quantityAvailable = 0,
    this.vendorSKU,
  });

  bool get isAvailable => status.isAvailable;
  String? get displayImage => thumbnailUrl ?? images.firstOrNull;

  factory Product.fromJson(Map<String, dynamic> json) {
    // backend returns nested category object
    final category = json['category'] as Map<String, dynamic>? ?? {};

    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      categoryId: category['id'] as String? ?? '',
      categoryLabel: category['label'] as String? ?? '',
      price: parseDouble(json['price']),
      unit: json['unit'] as String,
      pricingType: PricingType.fromString(
        json['pricingType'] as String? ?? 'fixed',
      ),
      status: ListingStatus.fromString(
        json['status'] as String? ?? 'available',
      ),
      images: List<String>.from(json['images'] as List? ?? []),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      vendor: ProductVendor.fromJson(json['vendor'] as Map<String, dynamic>),
      location: json['location'] as String?,
      condition: json['condition'] as String?,
      bulkSize: json['bulkSize'] as String?,
      bulkPrice: json['bulkPrice'] != null ? parseDouble(json['bulkPrice']) : null,
      views: json['views'] as int? ?? 0,
      inquiries: json['inquiries'] as int? ?? 0,
      quantityAvailable: json['quantityAvailable'] as int? ?? 0,
      vendorSKU: json['vendorSKU'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      specialOffer: json['specialOffer'] != null
          ? SpecialOffer.fromJson(json['specialOffer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': {'id': categoryId, 'label': categoryLabel},
    'price': price,
    'unit': unit,
    'pricingType': pricingType.name,
    'status': status.name,
    'images': images,
    'thumbnailUrl': thumbnailUrl,
    'vendor': vendor.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'specialOffer': specialOffer?.toJson(),
    'location': location,
    'condition': condition,
    'bulkSize': bulkSize,
    'bulkPrice': bulkPrice,
    'views': views,
    'inquiries': inquiries,
    'quantityAvailable': quantityAvailable,
    'vendorSKU': vendorSKU,
  };

  Product copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    String? categoryLabel,
    double? price,
    String? unit,
    PricingType? pricingType,
    ListingStatus? status,
    List<String>? images,
    String? thumbnailUrl,
    ProductVendor? vendor,
    DateTime? createdAt,
    DateTime? updatedAt,
    SpecialOffer? specialOffer,
    String? location,
    String? condition,
    String? bulkSize,
    double? bulkPrice,
    int? views,
    int? inquiries,
    int? quantityAvailable,
    String? vendorSKU,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      pricingType: pricingType ?? this.pricingType,
      status: status ?? this.status,
      images: images ?? this.images,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      vendor: vendor ?? this.vendor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      specialOffer: specialOffer ?? this.specialOffer,
      location: location ?? this.location,
      condition: condition ?? this.condition,
      bulkSize: bulkSize ?? this.bulkSize,
      bulkPrice: bulkPrice ?? this.bulkPrice,
      views: views ?? this.views,
      inquiries: inquiries ?? this.inquiries,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      vendorSKU: vendorSKU ?? this.vendorSKU,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Product(id: $id, title: $title, price: $price, status: ${status.name})';
}
