import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cost_it_mobile/feature/products/services/product_service.dart';
import 'package:cost_it_mobile/feature/vendor/listings/services/image_upload_service.dart';

import 'sell_state_notifier.dart';
import '../models/sell_form_state.dart';

final sellFormProvider = StateNotifierProvider<SellFormNotifier, SellFormState>(
  (ref) => SellFormNotifier(
    ref.read(productServiceProvider),
    ref.read(imageUploadServiceProvider),
  ),
);

final titleCharCountProvider = Provider<int>((ref) {
  return ref.watch(sellFormProvider.select((s) => s.title.length));
});

final photoCountProvider = Provider<int>((ref) {
  return ref.watch(sellFormProvider.select((s) => s.photos.length));
});

final canSubmitProvider = Provider<bool>((ref) {
  final s = ref.watch(sellFormProvider);
  bool baseValid = s.title.length >= 4 &&
      s.category != null &&
      s.photos.length >= 2 &&
      s.description.trim().length >= 20 &&
      s.location != null &&
      s.price.isNotEmpty &&
      s.contactName.isNotEmpty &&
      s.contactPhone.length == 11 &&
      !s.isSubmitting &&
      !s.isUploading; // don't allow Post while a retry is uploading

  if (s.hasSpecialOffer) {
    baseValid = baseValid && s.offerExpiresAt != null;
  }

  return baseValid;
});