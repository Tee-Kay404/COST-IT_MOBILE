class PaginationResult<T> {
  final List<T> data;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasNext;
  final bool hasPrev;
  final int pageSize;

  PaginationResult({
    required this.data,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.hasNext,
    required this.hasPrev,
    required this.pageSize,
  });

  int? get next {
    if (!hasNext) {
      return null;
    }
    return currentPage + 1;
  }

  int? get prev {
    if (!hasPrev || currentPage == 0) {
      return null;
    }
    return currentPage - 1;
  }

  @override
  String toString() {
    return 'PaginationResult(data: $data, totalItems: $totalItems, '
        'totalPages: $totalPages, currentPage: $currentPage, '
        'hasNext: $hasNext, hasPrev: $hasPrev, pageSize: $pageSize)';
  }
}

class ListPaginator<T> {
  /// Paginate a list manually based on page size and page number.
  ///
  /// [items] - List to paginate
  /// [pageSize] - Number of items per page
  /// [pageNumber] - Page number (1-based indexing)
  ///
  /// Returns [PaginationResult] containing paginated data and metadata
  static PaginationResult<T> paginate<T>(
    List<T> items,
    int pageSize,
    int pageNumber,
  ) {
    if (pageNumber < 1) {
      throw ArgumentError('Page number must be 1 or greater');
    }

    if (pageSize < 1) {
      throw ArgumentError('Page size must be 1 or greater');
    }

    final totalItems = items.length;
    final totalPages = (totalItems / pageSize).ceil();

    // Calculate start and end indices
    final startIndex = (pageNumber - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalItems);

    // Get the items for this page
    final pageData = items.sublist(startIndex, endIndex);

    return PaginationResult<T>(
      data: pageData,
      totalItems: totalItems,
      totalPages: totalPages,
      currentPage: pageNumber,
      hasNext: pageNumber < totalPages,
      hasPrev: pageNumber > 1,
      pageSize: pageSize,
    );
  }

  /// Simple pagination that only returns the data slice
  static List<T> simplePaginate<T>(
    List<T> items,
    int pageSize,
    int pageNumber,
  ) {
    final startIndex = (pageNumber - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, items.length);
    return items.sublist(startIndex, endIndex);
  }
}
