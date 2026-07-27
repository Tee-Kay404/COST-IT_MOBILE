import 'dart:developer';
import 'package:cost_it_mobile/app/storage/app_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class _SavedKeys {
  _SavedKeys._();
  static const savedIds = 'saved_product_ids';
}

class _SavedProductsStore {
  final _store = HiveStorageService<String, String>(boxName: 'savedProducts');

  _SavedProductsStore() {
    log('_SavedProductsStore instantiated');
  }

  Future<Set<String>> loadAll() async {
    log('_SavedProductsStore.loadAll called');
    try {
      final raw = await _store.getItem(_SavedKeys.savedIds);
      if (raw == null || raw.isEmpty) return {};
      return raw.split(',').where((s) => s.isNotEmpty).toSet();
    } catch (e) {
      log('_SavedProductsStore.loadAll error: $e');
      return {};
    }
  }

  Future<void> persist(Set<String> ids) async {
    try {
      await _store.addItem(_SavedKeys.savedIds, ids.join(','));
    } catch (e) {
      log('_SavedProductsStore.persist error: $e');
    }
  }
}

class SavedProductsLocalNotifier extends AsyncNotifier<Set<String>> {
  final _store = _SavedProductsStore();

  SavedProductsLocalNotifier() {
    log('SavedProductsLocalNotifier instantiated');
  }

  @override
  Future<Set<String>> build() async {
    log('SavedProductsLocalNotifier.build called');
    final data = await _store.loadAll();
    log('SavedProductsLocalNotifier.build loaded ${data.length} items');
    return data;
  }

  bool isSaved(String productId) => state.valueOrNull?.contains(productId) ?? false;

  Future<void> toggle(String productId) async {
    final current = Set<String>.from(state.valueOrNull ?? {});

    if (current.contains(productId)) {
      current.remove(productId);
    } else {
      current.add(productId);
    }

    state = AsyncData(current);

    await _store.persist(current);
  }

  
  Future<void> syncWithBackend(List<String> remoteIds) async {
    final newSet = remoteIds.toSet();
    state = AsyncData(newSet);
    await _store.persist(newSet);
  }

  
  Future<void> clearAll() async {
    state = const AsyncData({});
    await _store.persist({});
  }
}


final savedProductsLocalProvider =
    AsyncNotifierProvider<SavedProductsLocalNotifier, Set<String>>(
  SavedProductsLocalNotifier.new,
);


final isSavedProvider = Provider.family<bool, String>((ref, productId) {
  final saved = ref.watch(savedProductsLocalProvider).valueOrNull ?? {};
  return saved.contains(productId);
});
