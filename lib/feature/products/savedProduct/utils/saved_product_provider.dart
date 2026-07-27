import 'package:cost_it_mobile/feature/products/models/display_mode.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/models/saved_products_export.dart';
import 'package:cost_it_mobile/app/storage/saved_products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedSortProvider = StateProvider<SavedSortOption>(
  (_) => SavedSortOption.newest,
);

final savedSearchProvider = StateProvider<String>((_) => '');

final savedDisplayModeProvider = StateProvider<DisplayMode>(
  (_) => DisplayMode.grid,
);

final _allKnownProductsProvider = Provider<List<Product>>((ref) {
  final saved = ref.watch(savedProductsProvider).valueOrNull ?? [];
  final trending = ref.watch(trendingProductsProvider).valueOrNull ?? [];
  final special = ref.watch(specialOffersProvider).valueOrNull ?? [];
  final popular = ref.watch(popularServicesProvider).valueOrNull ?? [];
  final forYouState = ref.watch(forYouProvider).valueOrNull;
  final forYou = forYouState?.products ?? [];

  final allProducts = [
    ...saved,
    ...trending,
    ...special,
    ...popular,
    ...forYou,
  ];

  final uniqueProducts = <String, Product>{};
  for (final p in allProducts) {
    uniqueProducts[p.id] = p;
  }
  return uniqueProducts.values.toList();
});

final unfilteredSavedProductsProvider = Provider<List<Product>>((ref) {
  final savedIds = ref.watch(savedProductsLocalProvider).valueOrNull ?? {};
  final allProducts = ref.watch(_allKnownProductsProvider);
  return allProducts.where((p) => savedIds.contains(p.id)).toList();
});

final filteredSavedProductsProvider = Provider<List<Product>>((ref) {
  final productsList = ref.watch(unfilteredSavedProductsProvider);
  final sort = ref.watch(savedSortProvider);
  final query = ref.watch(savedSearchProvider).toLowerCase().trim();

  List<Product> products = List.from(productsList);

  if (query.isNotEmpty) {
    products = products
        .where(
          (p) =>
              p.title.toLowerCase().contains(query) ||
              p.categoryLabel.toLowerCase().contains(query) ||
              p.vendor.name.toLowerCase().contains(query),
        )
        .toList();
  }

  switch (sort) {
    case SavedSortOption.newest:
      products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case SavedSortOption.oldest:
      products.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
    case SavedSortOption.nameAZ:
      products.sort((a, b) => a.title.compareTo(b.title));
      break;
    case SavedSortOption.nameZA:
      products.sort((a, b) => b.title.compareTo(a.title));
      break;
    case SavedSortOption.priceLow:
      products.sort((a, b) => a.price.compareTo(b.price));
      break;
    case SavedSortOption.priceHigh:
      products.sort((a, b) => b.price.compareTo(a.price));
      break;
  }

  return products;
});
