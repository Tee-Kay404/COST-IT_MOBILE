import 'package:cost_it_mobile/feature/products/models/category.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/services/product_service.dart';
import 'package:cost_it_mobile/app/storage/saved_products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => '');

final carouselIndexProvider = StateProvider<int>((ref) => 0);

final categoriesProvider =
    AsyncNotifierProvider<CategoriesNotifier, List<ProductCategory>>(
  CategoriesNotifier.new,
);

class CategoriesNotifier extends AsyncNotifier<List<ProductCategory>> {
  @override
  Future<List<ProductCategory>> build() {
    return ref.read(productServiceProvider).getCategories();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(productServiceProvider).getCategories(),
    );
  }
}

final specialOffersProvider =
    AsyncNotifierProvider<SpecialOffersNotifier, List<Product>>(
  SpecialOffersNotifier.new,
);

class SpecialOffersNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() {
    return ref.read(productServiceProvider).getSpecialOffers();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(productServiceProvider).getSpecialOffers(),
    );
  }
}

final trendingProductsProvider =
    AsyncNotifierProvider<TrendingProductsNotifier, List<Product>>(
  TrendingProductsNotifier.new,
);

class TrendingProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() {
    final categoryId = ref.watch(selectedCategoryProvider);
    return ref.read(productServiceProvider).getTrendingProducts(
          categoryId: categoryId.isEmpty ? null : categoryId,
        );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final productDetailProvider = FutureProvider.autoDispose
    .family<Product, String>((ref, productId) {
  return ref.read(productServiceProvider).getProductById(productId);
});

final searchProductsProvider = FutureProvider.autoDispose
    .family<List<Product>, Map<String, dynamic>>((ref, params) {
  return ref.read(productServiceProvider).searchProducts(
        query: params['query'] as String,
        categoryId: params['category_id'] as String?,
        maxPrice: params['max_price'] as double?,
        minPrice: params['min_price'] as double?,
        pricingType: params['pricing_type'] as PricingType?,
        page: params['page'] as int? ?? 1,
        limit: params['limit'] as int? ?? 20,
      );
});


final saveProductProvider = FutureProvider.autoDispose
    .family<bool, Map<String, dynamic>>((ref, payload) {
  final productId = payload['product_id'] as String;
  return ref.read(productServiceProvider).saveProduct(productId);
});

final removeSavedProductProvider = FutureProvider.autoDispose
    .family<bool, Map<String, dynamic>>((ref, payload) {
  final productId = payload['product_id'] as String;
  return ref.read(productServiceProvider).removeSavedProduct(productId);
});

final savedProductsProvider =
    AsyncNotifierProvider<SavedProductsNotifier, List<Product>>(
  SavedProductsNotifier.new,
);

class SavedProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final products = await ref.read(productServiceProvider).getSavedProducts();
    
    // Sync local storage with backend automatically
    Future.microtask(() {
      ref.read(savedProductsLocalProvider.notifier).syncWithBackend(
        products.map((p) => p.id).toList()
      );
    });

    return products;
  }

  
  void removeLocally(String productId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.where((p) => p.id != productId).toList());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final products = await ref.read(productServiceProvider).getSavedProducts();
      
      ref.read(savedProductsLocalProvider.notifier).syncWithBackend(
        products.map((p) => p.id).toList()
      );
      
      return products;
    });
  }
}


final postProductProvider = FutureProvider.autoDispose
    .family<Product, Map<String, dynamic>>((ref, payload) {
  return ref.read(productServiceProvider).postProduct(payload);
});


final editProductProvider = FutureProvider.autoDispose
    .family<Product, Map<String, dynamic>>((ref, payload) {
  final productId = payload['product_id'] as String;
  final data = Map<String, dynamic>.from(payload)..remove('product_id');
  return ref.read(productServiceProvider).editProduct(productId, data);
});


final deleteProductProvider = FutureProvider.autoDispose
    .family<bool, Map<String, dynamic>>((ref, payload) {
  final productId = payload['product_id'] as String;
  return ref.read(productServiceProvider).deleteProduct(productId);
});

final myListingsProvider =
    AsyncNotifierProvider<MyListingsNotifier, List<Product>>(
  MyListingsNotifier.new,
);

class MyListingsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() {
    return ref.read(productServiceProvider).getMyListings();
  }

  void removeLocally(String productId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.where((p) => p.id != productId).toList());
  }

  void addLocally(Product product) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([product, ...current]);
  }

  void updateLocally(Product updated) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.map((p) => p.id == updated.id ? updated : p).toList(),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(productServiceProvider).getMyListings(),
    );
  }

  /// Updates the status of a single product in local state without a network call.
  void updateStatusLocally(String productId, ListingStatus newStatus) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.map((p) {
        if (p.id != productId) return p;
        return Product(
          id: p.id,
          title: p.title,
          description: p.description,
          categoryId: p.categoryId,
          categoryLabel: p.categoryLabel,
          price: p.price,
          unit: p.unit,
          pricingType: p.pricingType,
          status: newStatus,
          images: p.images,
          thumbnailUrl: p.thumbnailUrl,
          vendor: p.vendor,
          createdAt: p.createdAt,
          updatedAt: p.updatedAt,
          specialOffer: p.specialOffer,
          location: p.location,
          condition: p.condition,
          bulkSize: p.bulkSize,
          bulkPrice: p.bulkPrice,
          views: p.views,
          inquiries: p.inquiries,
          quantityAvailable: p.quantityAvailable,
          vendorSKU: p.vendorSKU,
        );
      }).toList(),
    );
  }
}

// Popular Services — simple async, no pagination needed
final popularServicesProvider =
    AsyncNotifierProvider<PopularServicesNotifier, List<Product>>(
  PopularServicesNotifier.new,
);

class PopularServicesNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() {
    return ref.read(productServiceProvider).getPopularServices();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(productServiceProvider).getPopularServices(),
    );
  }
}

// For You — cursor-based infinite feed state
class ForYouState {
  final List<Product> products;
  final String? nextCursor;
  final bool isLoadingMore;
  final bool hasError;

  const ForYouState({
    this.products = const [],
    this.nextCursor,
    this.isLoadingMore = false,
    this.hasError = false,
  });

  bool get hasMore => nextCursor != null;

  ForYouState copyWith({
    List<Product>? products,
    String? nextCursor,
    bool clearCursor = false,
    bool? isLoadingMore,
    bool? hasError,
  }) {
    return ForYouState(
      products: products ?? this.products,
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
    );
  }
}

final forYouProvider =
    AsyncNotifierProvider<ForYouNotifier, ForYouState>(
  ForYouNotifier.new,
);

class ForYouNotifier extends AsyncNotifier<ForYouState> {
  @override
  Future<ForYouState> build() async {
    final page = await ref.read(productServiceProvider).getForYou();
    return ForYouState(
      products: page.data,
      nextCursor: page.nextCursor,
    );
  }

  // Called when user scrolls to the bottom
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    // Show loading indicator at bottom without replacing the list
    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final page = await ref
          .read(productServiceProvider)
          .getForYou(afterId: current.nextCursor);

      state = AsyncData(current.copyWith(
        products: [...current.products, ...page.data],
        nextCursor: page.nextCursor,
        isLoadingMore: false,
      ));
    } catch (_) {
      state = AsyncData(current.copyWith(
        isLoadingMore: false,
        hasError: true,
      ));
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}