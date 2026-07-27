import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';
import 'package:cost_it_mobile/feature/products/components/seeAll/enums.dart';
import 'package:cost_it_mobile/feature/products/components/seeAll/provider/see_all_provider.dart';
import 'package:cost_it_mobile/app/storage/recently_viewed_products.dart';

enum RefreshType { home, savedProducts, seeAll, categoryTab, myListings }

class CostItRefreshIndicator extends ConsumerWidget {
  final Widget child;
  final RefreshType type;
  final SeeAllSection? seeAllSection;

  const CostItRefreshIndicator({
    super.key,
    required this.child,
    required this.type,
    this.seeAllSection,
  });

  Future<void> _handleRefresh(WidgetRef ref) async {
    switch (type) {
      case RefreshType.home:
        ref.invalidate(specialOffersProvider);
        ref.invalidate(categoriesProvider);
        ref.invalidate(trendingProductsProvider);
        try {
          await Future.wait([
            ref.read(specialOffersProvider.future),
            ref.read(categoriesProvider.future),
            ref.read(trendingProductsProvider.future),
          ]);
        } catch (_) {}
        break;
      case RefreshType.savedProducts:
        try {
          await ref.read(savedProductsProvider.notifier).refresh();
        } catch (_) {}
        break;
      case RefreshType.seeAll:
        if (seeAllSection != null &&
            seeAllSection != SeeAllSection.recentlyViewed) {
          ref.invalidate(seeAllProvider(seeAllSection!));
          try {
            await ref.read(seeAllProvider(seeAllSection!).future);
          } catch (_) {}
        } else if (seeAllSection == SeeAllSection.recentlyViewed) {
          ref.invalidate(recentlyViewedProvider);
          try {
            await ref.read(recentlyViewedProvider.future);
          } catch (_) {}
        }
        break;
      case RefreshType.myListings:
        try {
          await ref.read(myListingsProvider.notifier).refresh();
        } catch (_) {}
        break;
      case RefreshType.categoryTab:
        ref.invalidate(seeAllProvider(SeeAllSection.categories));
        try {
          await ref.read(seeAllProvider(SeeAllSection.categories).future);
        } catch (_) {}
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => _handleRefresh(ref),
      color: context.color.onPrimary,
      backgroundColor: context.color.surface,
      child: child,
    );
  }
}
