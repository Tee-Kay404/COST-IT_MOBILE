import 'package:cost_it_mobile/constants/constants.dart';

const _slugIconMap = <String, String>{
  'cat_materials':  AppImages.materials,
  'cat_tools':      AppImages.tools,
  'cat_machinery':  AppImages.machinery,
  'cat_electrical': AppImages.electrical,
  'cat_plumbing':   AppImages.plumbing,
  'cat_safety':     AppImages.safety,
  'cat_finishing':  AppImages.finishing,
  'cat_logistics':  AppImages.logistics,
  'cat_services':   AppImages.services,
};

const _fallbackImage = AppImages.materials;

class ProductCategory {
  final String id;
  final String label;

  const ProductCategory({
    required this.id,
    required this.label,
  });

  String get image => _slugIconMap[id] ?? _fallbackImage;

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as String,
      label: json['label'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
      };

  ProductCategory copyWith({
    String? id,
    String? label,
  }) {
    return ProductCategory(
      id: id ?? this.id,
      label: label ?? this.label,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProductCategory(id: $id, label: $label)';
}