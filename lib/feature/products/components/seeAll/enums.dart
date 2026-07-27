enum SeeAllSection {
  specialOffers,
  categories,
  trending,
  popularServices,
  recentlyViewed,
  topVendors,
  forYou,
}

extension SeeAllSectionX on SeeAllSection {
  String get title => switch (this) {
    SeeAllSection.specialOffers => '#Special Offers',
    SeeAllSection.categories => 'Category',
    SeeAllSection.trending => 'Trending',
    SeeAllSection.popularServices => 'Popular Services',
    SeeAllSection.recentlyViewed => 'Recently Viewed',
    SeeAllSection.topVendors => 'Top Vendors',
    SeeAllSection.forYou => 'For You',
  };
}
