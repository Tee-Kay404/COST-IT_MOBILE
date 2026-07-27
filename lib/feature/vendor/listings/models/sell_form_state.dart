import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/vendor/listings/models/photo_item.dart';

enum NegotiationStance { open, firm, flexible }

enum VisibilityTier { standard, featured, premium }

class SellFormState {
  final String title;
  final String? category;
  final String? subcategory;
  final String description;
  final String? location;
  final String price;
  final NegotiationStance negotiation;
  final VisibilityTier visibility;
  final List<PhotoItem> photos;
  final String contactName;
  final String contactPhone;
  final String? brand;
  final String? condition;
  final String? bulkSize;
  final String? bulkPrice;
  final bool hasSpecialOffer;
  final String offerLabel;
  final String offerBadge;
  final DateTime? offerExpiresAt;
  final bool isSubmitting;
  final bool isSavingDraft;
  final String? submitError;
  final bool isUploading;
  final double uploadProgress;
  /// Set when editing an existing product. Null means this is a new listing.
  final String? editingProductId;
  final Product? originalProduct;

  const SellFormState({
    this.title = '',
    this.category,
    this.subcategory,
    this.description = '',
    this.location,
    this.price = '',
    this.negotiation = NegotiationStance.open,
    this.visibility = VisibilityTier.standard,
    this.photos = const [],
    this.contactName = '',
    this.contactPhone = '',
    this.brand,
    this.condition,
    this.bulkSize,
    this.bulkPrice,
    this.hasSpecialOffer = false,
    this.offerLabel = '',
    this.offerBadge = '',
    this.offerExpiresAt,
    this.isSubmitting = false,
    this.isSavingDraft = false,
    this.submitError,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.editingProductId,
    this.originalProduct,
  });

  SellFormState copyWith({
    String? title,
    String? category,
    String? subcategory,
    String? description,
    String? location,
    String? price,
    NegotiationStance? negotiation,
    VisibilityTier? visibility,
    List<PhotoItem>? photos,
    String? contactName,
    String? contactPhone,
    String? brand,
    String? condition,
    String? bulkSize,
    String? bulkPrice,
    bool? hasSpecialOffer,
    String? offerLabel,
    String? offerBadge,
    DateTime? offerExpiresAt,
    bool clearOfferExpiry = false,
    bool? isSubmitting,
    bool? isSavingDraft,
    String? submitError,
    bool clearError = false,
    bool clearCategory = false,
    bool clearSubcategory = false,
    bool clearLocation = false,
    bool? isUploading,
    double? uploadProgress,
    String? editingProductId,
    bool clearEditingId = false,
    Product? originalProduct,
  }) {
    return SellFormState(
      title: title ?? this.title,
      category: clearCategory ? null : (category ?? this.category),
      subcategory: clearSubcategory ? null : (subcategory ?? this.subcategory),
      description: description ?? this.description,
      location: clearLocation ? null : (location ?? this.location),
      price: price ?? this.price,
      negotiation: negotiation ?? this.negotiation,
      visibility: visibility ?? this.visibility,
      photos: photos ?? this.photos,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      brand: brand ?? this.brand,
      condition: condition ?? this.condition,
      bulkSize: bulkSize ?? this.bulkSize,
      bulkPrice: bulkPrice ?? this.bulkPrice,
      hasSpecialOffer: hasSpecialOffer ?? this.hasSpecialOffer,
      offerLabel: offerLabel ?? this.offerLabel,
      offerBadge: offerBadge ?? this.offerBadge,
      offerExpiresAt: clearOfferExpiry ? null : (offerExpiresAt ?? this.offerExpiresAt),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSavingDraft: isSavingDraft ?? this.isSavingDraft,
      submitError: clearError ? null : (submitError ?? this.submitError),
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      editingProductId: clearEditingId ? null : (editingProductId ?? this.editingProductId),
      originalProduct: originalProduct ?? this.originalProduct,
    );
  }

  bool get hasAnyInput =>
      title.isNotEmpty ||
      category != null ||
      description.isNotEmpty ||
      price.isNotEmpty ||
      photos.isNotEmpty;
}