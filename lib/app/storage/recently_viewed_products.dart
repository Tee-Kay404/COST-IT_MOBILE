import 'dart:convert';
import 'dart:developer';
import 'package:cost_it_mobile/app/storage/app_storage.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewedProduct {
  final Product product;
  final DateTime viewedAt;

  ViewedProduct({required this.product, required this.viewedAt});

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'viewedAt': viewedAt.toIso8601String(),
      };

  factory ViewedProduct.fromJson(Map<String, dynamic> json) {
    return ViewedProduct(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      viewedAt: DateTime.parse(json['viewedAt'] as String),
    );
  }
}

class _RecentlyViewedStore {
  final _store = HiveStorageService<String, String>(boxName: 'recentlyViewed');
  static const _key = 'recently_viewed_items';

  Future<List<ViewedProduct>> loadAll() async {
    try {
      final raw = await _store.getItem(_key);
      if (raw == null || raw.isEmpty) return [];
      
      final List<dynamic> decoded = jsonDecode(raw);
      final List<ViewedProduct> items = decoded
          .map((e) => ViewedProduct.fromJson(e as Map<String, dynamic>))
          .toList();
          
      // Filter out items older than 30 days
      final now = DateTime.now();
      final validItems = items.where((item) {
        return now.difference(item.viewedAt).inDays <= 30;
      }).toList();
      
      return validItems;
    } catch (e) {
      log('_RecentlyViewedStore.loadAll error: $e');
      return [];
    }
  }

  Future<void> persist(List<ViewedProduct> items) async {
    try {
      final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
      await _store.addItem(_key, encoded);
    } catch (e) {
      log('_RecentlyViewedStore.persist error: $e');
    }
  }
}

class RecentlyViewedNotifier extends AsyncNotifier<List<ViewedProduct>> {
  final _store = _RecentlyViewedStore();
  static const int _maxItems = 30;

  @override
  Future<List<ViewedProduct>> build() async {
    final items = await _store.loadAll();
    // Re-persist immediately if we filtered out expired items during load
    await _store.persist(items);
    return items;
  }

  Future<void> addProduct(Product product) async {
    // Wait for the initial load to complete to avoid race condition overriding state
    final previousItems = await future;
    final current = List<ViewedProduct>.from(previousItems);
    
    // Remove if exists to move it to the top
    current.removeWhere((item) => item.product.id == product.id);
    
    // Add to top
    current.insert(0, ViewedProduct(product: product, viewedAt: DateTime.now()));
    
    // Trim to max limit
    if (current.length > _maxItems) {
      current.removeLast();
    }
    
    state = AsyncData(current);
    await _store.persist(current);
  }

  Future<void> clearAll() async {
    state = const AsyncData([]);
    await _store.persist([]);
  }

  Future<void> removeProducts(Set<String> productIds) async {
    final previousItems = await future;
    final current = List<ViewedProduct>.from(previousItems);
    
    current.removeWhere((item) => productIds.contains(item.product.id));
    
    state = AsyncData(current);
    await _store.persist(current);
  }
}

final recentlyViewedProvider =
    AsyncNotifierProvider<RecentlyViewedNotifier, List<ViewedProduct>>(
  RecentlyViewedNotifier.new,
);
