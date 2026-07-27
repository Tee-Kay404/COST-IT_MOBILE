enum SavedSortOption {
  newest,
  oldest,
  nameAZ,
  nameZA,
  priceLow,
  priceHigh;

  String get label {
    switch (this) {
      case SavedSortOption.newest:
        return 'Newest First';
      case SavedSortOption.oldest:
        return 'Oldest First';
      case SavedSortOption.nameAZ:
        return 'Name (A–Z)';
      case SavedSortOption.nameZA:
        return 'Name (Z–A)';
      case SavedSortOption.priceLow:
        return 'Price: Low to High';
      case SavedSortOption.priceHigh:
        return 'Price: High to Low';
    }
  }
}
