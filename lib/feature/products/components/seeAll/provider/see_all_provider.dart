import 'package:cost_it_mobile/app/storage/recently_viewed_products.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/services/product_service.dart';
import 'package:cost_it_mobile/feature/products/components/seeAll/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PaginatedState {
  final List<Product> items;
  final int currentPage;
  final bool hasMore;
  final bool isFetchingMore;
  final String? error;

  const PaginatedState({
    this.items = const [],
    this.currentPage = 0,
    this.hasMore = true,
    this.isFetchingMore = false,
    this.error,
  });

  PaginatedState copyWith({
    List<Product>? items,
    int? currentPage,
    bool? hasMore,
    bool? isFetchingMore,
    String? error,
  }) {
    return PaginatedState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      error: error,
    );
  }
}


class SeeAllNotifier
    extends FamilyAsyncNotifier<PaginatedState, SeeAllSection> {
  static const int _pageSize = 20;

  @override
  Future<PaginatedState> build(SeeAllSection arg) async {
    return _fetchPage(1, existing: []);
  }

  Future<PaginatedState> _fetchPage(
    int page, {
    required List<Product> existing,
  }) async {
    final newItems = await _fetchForSection(page);
    return PaginatedState(
      items: [...existing, ...newItems],
      currentPage: page,
      hasMore: newItems.length == _pageSize,
      isFetchingMore: false,
    );
  }

  Future<void> fetchNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isFetchingMore) return;

    state = AsyncData(current.copyWith(isFetchingMore: true));

    try {
      final updated = await _fetchPage(
        current.currentPage + 1,
        existing: current.items,
      );
      state = AsyncData(updated);
    } catch (e) {
      state = AsyncData(
        current.copyWith(isFetchingMore: false, error: e.toString()),
      );
    }
  }

  Future<List<Product>> _fetchForSection(int page) async {
    final service = ref.read(productServiceProvider);

    switch (arg) {
      case SeeAllSection.specialOffers:
        return service.getSpecialOffers();

      case SeeAllSection.trending:
        return service.getTrendingProducts(page: page, limit: _pageSize);

      case SeeAllSection.popularServices:
        return service.getPopularServices();

      case SeeAllSection.recentlyViewed:
        final items = await ref.read(recentlyViewedProvider.future);
        return items.map((e) => e.product).toList();

      case SeeAllSection.categories:
        return service.searchProducts(query: '', page: page, limit: _pageSize);

      case SeeAllSection.topVendors:
        return Future.value([]);

      case SeeAllSection.forYou:
        final response = await service.getForYou(limit: _pageSize);
        return response.data;
    }
  }
}

final seeAllProvider =
    AsyncNotifierProviderFamily<SeeAllNotifier, PaginatedState, SeeAllSection>(
  SeeAllNotifier.new,
);