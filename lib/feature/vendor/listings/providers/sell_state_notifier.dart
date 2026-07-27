import 'dart:io';

import 'package:cost_it_mobile/app/global/utils/exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cost_it_mobile/widgets/toasts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cost_it_mobile/feature/products/services/product_service.dart';

import 'package:cost_it_mobile/feature/products/models/products.dart';
import '../models/sell_form_state.dart';
import '../models/photo_item.dart';
import '../services/image_upload_service.dart';

class SellFormNotifier extends StateNotifier<SellFormState> {
  final ProductService _productService;
  final ImageUploadService _uploadService;

  SellFormNotifier(this._productService, this._uploadService)
    : super(const SellFormState());

  static const int _maxPhotos = 5;
  static const int _minPhotos = 2;

  void setTitle(String v) => state = state.copyWith(title: v);
  void setCategory(String v) =>
      state = state.copyWith(category: v, clearSubcategory: true);
  void setSubcategory(String v) => state = state.copyWith(subcategory: v);
  void setDescription(String v) => state = state.copyWith(description: v);
  void setLocation(String v) => state = state.copyWith(location: v);
  void setPrice(String v) => state = state.copyWith(price: v);
  void setNegotiation(NegotiationStance v) =>
      state = state.copyWith(negotiation: v);
  void setVisibility(VisibilityTier v) => state = state.copyWith(visibility: v);
  void setContactName(String v) => state = state.copyWith(contactName: v);
  void setContactPhone(String v) => state = state.copyWith(contactPhone: v);
  void setBrand(String v) => state = state.copyWith(brand: v);
  void setCondition(String v) => state = state.copyWith(condition: v);
  void setBulkSize(String v) => state = state.copyWith(bulkSize: v);
  void setBulkPrice(String v) => state = state.copyWith(bulkPrice: v);

  void toggleSpecialOffer(bool v) {
    state = state.copyWith(
      hasSpecialOffer: v,
      offerLabel: v ? state.offerLabel : '',
      offerBadge: v ? state.offerBadge : '',
      clearOfferExpiry: !v,
    );
  }

  void setOfferLabel(String v) => state = state.copyWith(offerLabel: v);
  void setOfferBadge(String v) => state = state.copyWith(offerBadge: v);
  void setOfferExpiry(DateTime? v) =>
      v != null ? state = state.copyWith(offerExpiresAt: v) : null;
  void clearOfferExpiry() => state = state.copyWith(clearOfferExpiry: true);

  /// Loads an existing [Product] into the form for editing. All fields are
  /// pre-populated. Each existing image URL becomes a pre-success PhotoItem
  /// that won't be re-uploaded unless the user removes and re-adds it.
  void initializeWithProduct(Product p) {
    final photos = p.images.map(PhotoItem.fromUrl).toList();

    // Map pricingType → NegotiationStance (best-effort)
    NegotiationStance negotiation;
    switch (p.pricingType) {
      case PricingType.firm:
        negotiation = NegotiationStance.firm;
        break;
      case PricingType.flexible:
        negotiation = NegotiationStance.flexible;
        break;
      default:
        negotiation = NegotiationStance.open;
    }

    state = SellFormState(
      editingProductId: p.id,
      originalProduct: p,
      title: p.title,
      description: p.description ?? '',
      price: p.price.toStringAsFixed(
        p.price.truncateToDouble() == p.price ? 0 : 2,
      ),
      category: p.categoryId,
      subcategory: null, // subcategory is not stored on Product yet
      location: p.location,
      condition: p.condition,
      brand: null, // brand not on Product model yet
      bulkSize: p.bulkSize,
      bulkPrice: p.bulkPrice?.toString(),
      negotiation: negotiation,
      photos: photos,
      // Keep contact info from current state so user doesn't have to re-enter
      contactName: state.contactName,
      contactPhone: state.contactPhone,
      hasSpecialOffer: p.specialOffer?.isActive == true,
      offerLabel: p.specialOffer?.discountLabel ?? '',
      offerBadge: p.specialOffer?.badgeText ?? '',
      offerExpiresAt: p.specialOffer?.expiresAt,
    );
  }

  bool hasChanges() {
    if (state.originalProduct == null) return true;
    final orig = state.originalProduct!;
    
    if (state.title != orig.title) return true;
    if (state.description != (orig.description ?? '')) return true;
    if (state.category != orig.categoryId) return true;
    
    final origPrice = orig.price.toStringAsFixed(orig.price.truncateToDouble() == orig.price ? 0 : 2);
    if (state.price != origPrice) return true;
    
    if (state.location != orig.location) return true;
    if (state.condition != orig.condition) return true;
    if (state.bulkSize != orig.bulkSize) return true;
    if (state.bulkPrice != (orig.bulkPrice?.toString() ?? '')) return true;
    
    final origPhotos = orig.images;
    final currentPhotos = state.photos.where((p) => p.isSuccess).map((p) => p.url!).toList();
    if (origPhotos.length != currentPhotos.length) return true;
    for (var i = 0; i < origPhotos.length; i++) {
      if (origPhotos[i] != currentPhotos[i]) return true;
    }
    
    final hasOffer = orig.specialOffer?.isActive == true;
    if (state.hasSpecialOffer != hasOffer) return true;
    if (state.hasSpecialOffer) {
      if (state.offerLabel != (orig.specialOffer?.discountLabel ?? '')) return true;
      if (state.offerBadge != (orig.specialOffer?.badgeText ?? '')) return true;
      if (state.offerExpiresAt != orig.specialOffer?.expiresAt) return true;
    }
    
    return false;
  }

  /// Adds a picked file to local state only. No network call — upload is
  /// deferred until Post/Save draft is tapped, or a specific failed
  /// photo is retried.
  void addPhoto(File file) {
    if (state.photos.length >= _maxPhotos) return;
    state = state.copyWith(photos: [...state.photos, PhotoItem(file: file)]);
  }

  void removePhoto(int index) {
    if (index < 0 || index >= state.photos.length) return;
    final updated = [...state.photos]..removeAt(index);
    state = state.copyWith(photos: updated);
  }

  void reorderPhotos(int oldIndex, int newIndex) {
    final updated = [...state.photos];
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    state = state.copyWith(photos: updated);
  }

  Future<void> pickPhotos() async {
    final picker = ImagePicker();
    final remaining = _maxPhotos - state.photos.length;

    if (remaining <= 0) {
      debugPrint('[SellFormNotifier] Max photo limit ($_maxPhotos) reached.');
      return;
    }

    debugPrint('[SellFormNotifier] Opening gallery. Can pick up to $remaining more photo(s).');

    final picked = await picker.pickMultiImage(imageQuality: 85);

    if (picked.isEmpty) {
      debugPrint('[SellFormNotifier] User cancelled gallery pick.');
      return;
    }

    final toAdd = picked
        .take(remaining)
        .map((xf) => PhotoItem(file: File(xf.path)))
        .toList();
    debugPrint('[SellFormNotifier] Adding ${toAdd.length} photo(s) to form.');

    state = state.copyWith(
      photos: [...state.photos, ...toAdd],
      clearError: true,
    );
  }

  void _setPhotoAt(int index, PhotoItem Function(PhotoItem) update) {
    if (index < 0 || index >= state.photos.length) return;
    final updated = [...state.photos];
    updated[index] = update(updated[index]);
    state = state.copyWith(photos: updated);
  }

  /// Uploads the photos at [indices] as one batch. Each file's result
  /// maps back to its own tile — one failure never resets the others.
  ///
  /// [trackGlobalProgress] controls whether this touches
  /// state.isUploading/uploadProgress (which drives the full-screen
  /// overlay). Pass false for single-photo retries — those should only
  /// ever show up as that tile's own spinner, never block the screen.
  Future<bool> _uploadBatch(
    List<int> indices, {
    required bool trackGlobalProgress,
  }) async {
    if (indices.isEmpty) return true;

    // Remote photos (fromUrl) have no local file — filter them out.
    final localIndices = indices.where((i) => !state.photos[i].isRemote).toList();
    if (localIndices.isEmpty) return true;

    final files = localIndices.map((i) => state.photos[i].file!).toList();

    for (final i in indices) {
      _setPhotoAt(
        i,
        (p) => p.copyWith(status: PhotoUploadStatus.uploading, clearError: true, progress: 0.0),
      );
    }
    if (trackGlobalProgress) {
      state = state.copyWith(isUploading: true, uploadProgress: 0.0);
    }

    try {
      final result = await _uploadService.uploadImages(
        files,
        onProgress: (p) {
          for (final i in indices) {
            _setPhotoAt(i, (item) => item.copyWith(progress: p));
          }
          if (trackGlobalProgress) {
            state = state.copyWith(uploadProgress: p);
          }
        },
      );

      for (final s in result.succeeded) {
        final originalIndex = indices[s.index];
        _setPhotoAt(
          originalIndex,
          (p) => p.copyWith(status: PhotoUploadStatus.success, url: s.url),
        );
      }
      for (final f in result.failed) {
        final originalIndex = indices[f.index];
        debugPrint('[SellFormNotifier] Photo failed: ${f.filename} — ${f.reason}');
        _setPhotoAt(
          originalIndex,
          (p) => p.copyWith(status: PhotoUploadStatus.failed, errorReason: f.reason),
        );
      }

      if (trackGlobalProgress) {
        state = state.copyWith(isUploading: false, uploadProgress: 1.0);
      }
      return result.failed.isEmpty;
    } on GlobalException catch (e) {
      debugPrint('[SellFormNotifier] Batch upload failed: ${e.message}');
      for (final i in indices) {
        _setPhotoAt(
          i,
          (p) => p.copyWith(
            status: PhotoUploadStatus.failed,
            errorReason: e.message ?? 'Upload failed. Please try again.',
          ),
        );
      }
      if (trackGlobalProgress) state = state.copyWith(isUploading: false);
      return false;
    } catch (e, stack) {
      debugPrint('[SellFormNotifier] Unexpected batch upload error: $e');
      debugPrint('$stack');
      for (final i in indices) {
        _setPhotoAt(
          i,
          (p) => p.copyWith(
            status: PhotoUploadStatus.failed,
            errorReason: 'Upload failed. Please try again.',
          ),
        );
      }
      if (trackGlobalProgress) state = state.copyWith(isUploading: false);
      return false;
    }
  }

  /// Retry one failed photo. Deliberately does NOT touch the global
  /// isUploading flag — the full-screen overlay never appears for this,
  /// only that tile's own spinner (handled inside PhotoPickerGrid).
  void retryPhoto(int index) {
    if (state.isSubmitting || state.isSavingDraft) return;
    if (index < 0 || index >= state.photos.length) return;
    if (state.photos[index].isUploading) return;
    _uploadBatch([index], trackGlobalProgress: false);
  }  void clearAll() => state = const SellFormState();

  List<int> get _pendingPhotoIndices => [
        for (var i = 0; i < state.photos.length; i++)
          // Skip remote photos (already on CDN) and already-uploaded local ones
          if (!state.photos[i].isSuccess && !state.photos[i].isRemote) i,
      ];

  Future<void> submit() async {
    if (state.photos.length < _minPhotos) {
      state = state.copyWith(
        submitError: 'Please add at least $_minPhotos photos before posting.',
      );
      return;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

// in submit():
final allUploaded = await _uploadBatch(_pendingPhotoIndices, trackGlobalProgress: true);

    if (!allUploaded) {
      debugPrint('[SellFormNotifier] Submit blocked — one or more photos failed to upload.');
      state = state.copyWith(
        isSubmitting: false,
        submitError: 'One or more photos failed to upload. Tap the failed photo to retry, then post again.',
      );
      return;
    }

    final imageUrls = state.photos.map((p) => p.url!).toList();
    debugPrint('[SellFormNotifier] Submitting product with ${imageUrls.length} image(s)');

    final payload = {
      'title': state.title,
      if (state.description.isNotEmpty) 'description': state.description,
      'categoryId': state.category,
      'price': double.tryParse(state.price) ?? 0,
      'unit': 'item',
      'images': imageUrls,
      'location': state.location,
      'contactName': state.contactName,
      'contactPhone': state.contactPhone,
      if (state.brand != null && state.brand!.isNotEmpty) 'brand': state.brand,
      if (state.condition != null && state.condition!.isNotEmpty)
        'condition': state.condition,
      if (state.bulkSize != null && state.bulkSize!.isNotEmpty)
        'bulkSize': state.bulkSize,
      if (state.bulkPrice != null && state.bulkPrice!.isNotEmpty)
        'bulkPrice': double.tryParse(state.bulkPrice!),
      'visibilityTier': state.visibility.name,
      'pricingType': state.negotiation.name,
      if (state.subcategory != null) 'subcategoryId': state.subcategory,
      if (state.hasSpecialOffer)
        'specialOffer': {
          'discountLabel': state.offerLabel,
          if (state.offerBadge.isNotEmpty) 'badgeText': state.offerBadge,
          if (state.offerExpiresAt != null)
            'expiresAt': state.offerExpiresAt!.toIso8601String(),
          'isActive': true,
        },
    };

    try {
      if (state.editingProductId != null) {
        // ── UPDATE existing product ──────────────────────────────────────
        debugPrint('[SellFormNotifier] Updating product ${state.editingProductId}');
        await _productService.editProduct(state.editingProductId!, payload);
      } else {
        // ── CREATE new product ───────────────────────────────────────────
        await _productService.postProduct(payload);
      }
    } on GlobalException catch (e) {
      debugPrint('[SellFormNotifier] Submit failed: ${e.message}');
      state = state.copyWith(
        isSubmitting: false,
        submitError: e.message ?? 'Failed to create listing. Please try again.',
      );
      return;
    } catch (e, stack) {
      debugPrint('[SellFormNotifier] Unexpected submit error: $e');
      debugPrint('$stack');
      state = state.copyWith(
        isSubmitting: false,
        submitError: 'Something went wrong. Please try again.',
      );
      return;
    }

    state = state.copyWith(isSubmitting: false);
  }

  Future<void> saveAsDraft(BuildContext context) async {
    if (!hasChanges()) {
      showInfoToast(context, 'No changes made');
      return;
    }

    state = state.copyWith(isSavingDraft: true, clearError: true);

    final allUploaded = await _uploadBatch(_pendingPhotoIndices, trackGlobalProgress: true);

    if (!allUploaded) {
      debugPrint('[SellFormNotifier] Draft save blocked — one or more photos failed to upload.');
      state = state.copyWith(
        isSavingDraft: false,
        submitError: 'One or more photos failed to upload. Tap the failed photo to retry, then save again.',
      );
      return;
    }

    final imageUrls = state.photos
        .where((p) => p.isSuccess)
        .map((p) => p.url!)
        .toList();

    final payload = {
      'title': state.title,
      if (state.description.isNotEmpty) 'description': state.description,
      'categoryId': state.category,
      'price': double.tryParse(state.price) ?? 0,
      'unit': 'item',
      'images': imageUrls,
      'location': state.location,
      'contactName': state.contactName,
      'contactPhone': state.contactPhone,
      if (state.brand != null && state.brand!.isNotEmpty) 'brand': state.brand,
      if (state.condition != null && state.condition!.isNotEmpty)
        'condition': state.condition,
      if (state.bulkSize != null && state.bulkSize!.isNotEmpty)
        'bulkSize': state.bulkSize,
      if (state.bulkPrice != null && state.bulkPrice!.isNotEmpty)
        'bulkPrice': double.tryParse(state.bulkPrice!),
      'visibilityTier': state.visibility.name,
      'pricingType': state.negotiation.name,
      if (state.subcategory != null) 'subcategoryId': state.subcategory,
      'status': 'draft',
      if (state.hasSpecialOffer)
        'specialOffer': {
          'discountLabel': state.offerLabel,
          if (state.offerBadge.isNotEmpty) 'badgeText': state.offerBadge,
          if (state.offerExpiresAt != null)
            'expiresAt': state.offerExpiresAt!.toIso8601String(),
          'isActive': true,
        },
    };

    try {
      if (state.editingProductId != null) {
        await _productService.editProduct(state.editingProductId!, payload);
      } else {
        await _productService.postProduct(payload);
      }
    } on GlobalException catch (e) {
      debugPrint('[SellFormNotifier] Draft save failed: ${e.message}');
      state = state.copyWith(
        isSavingDraft: false,
        submitError: e.message ?? 'Failed to save draft. Please try again.',
      );
      return;
    } catch (e, stack) {
      debugPrint('[SellFormNotifier] Unexpected draft save error: $e');
      debugPrint('$stack');
      state = state.copyWith(
        isSavingDraft: false,
        submitError: 'Something went wrong. Please try again.',
      );
      return;
    }

    state = state.copyWith(isSavingDraft: false);
  }
}