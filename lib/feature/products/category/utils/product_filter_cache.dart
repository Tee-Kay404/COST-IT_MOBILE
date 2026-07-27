import 'package:cost_it_mobile/feature/products/models/products.dart';

class ProductFilterCache {
  List<Product>? _cached;
  String? _lastCategoryId;
  String? _lastQuery;
  int? _lastItemCount;

  List<Product> filter({
    required List<Product> items,
    required String categoryId,
    required String searchQuery,
  }) {
    if (_cached != null &&
        _lastCategoryId == categoryId &&
        _lastQuery == searchQuery &&
        _lastItemCount == items.length) {
      return _cached!;
    }

    var result = categoryId == 'all'
        ? items
        : items.where((p) => p.categoryId == categoryId).toList();

    if (searchQuery.isNotEmpty) {
      result = result
          .where(
            (p) =>
                p.title.toLowerCase().contains(searchQuery) ||
                p.categoryLabel.toLowerCase().contains(searchQuery) ||
                p.vendor.name.toLowerCase().contains(searchQuery),
          )
          .toList();
    }

    _lastCategoryId = categoryId;
    _lastQuery = searchQuery;
    _lastItemCount = items.length;
    _cached = result;
    return result;
  }

  void invalidate() {
    _cached = null;
    _lastCategoryId = null;
    _lastQuery = null;
    _lastItemCount = null;
  }
}
