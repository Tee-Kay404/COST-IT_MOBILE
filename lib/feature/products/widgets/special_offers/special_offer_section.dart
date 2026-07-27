import 'dart:async';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/widgets/special_offers/special_offers_card.dart';
import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';
import 'package:cost_it_mobile/feature/products/widgets/special_offers/shimmer.dart';
import 'package:cost_it_mobile/widgets/carousel_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialOffersSection extends ConsumerStatefulWidget {
  const SpecialOffersSection({super.key});

  @override
  ConsumerState<SpecialOffersSection> createState() =>
      _SpecialOffersSectionState();
}

class _SpecialOffersSectionState extends ConsumerState<SpecialOffersSection> {
  late final PageController _pageController;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      final offers = ref.read(specialOffersProvider).valueOrNull;
      if (offers == null || offers.isEmpty) return;
      final offersList = offers.take(5).toList();

      final current = ref.read(carouselIndexProvider);
      final next = (current + 1) % offersList.length;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offersAsync = ref.watch(specialOffersProvider);
    final currentIndex = ref.watch(carouselIndexProvider);

    return offersAsync.when(
      loading: () => const SpecialOffersShimmer(),
      error: (e, stack) {
        debugPrint(' SpecialOffers error: $e');
        debugPrint(' SpecialOffers stack: $stack');
        return Center(
          child: Text(
            'Could not load special offers!!!',
            style: context.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
        );
      },
      data: (offers) {
        final offersList = offers.take(5).toList();
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: (220.h).clamp(200.0.h, 260.0.h),
              child: PageView.builder(
                controller: _pageController,
                itemCount: offersList.length,
                onPageChanged: (index) {
                  ref.read(carouselIndexProvider.notifier).state = index;
                },
                itemBuilder: (_, index) {
                  return SpecialOfferCard(product: offersList[index], index: index);
                },
              ),
            ),
            SizedBox(height: 20.h),
            CarouselIndicator(
              count: offersList.length,
              current: currentIndex,
              activeColor: OfferTheme.indicatorColor(currentIndex),
            ),
          ],
        );
      },
    );
  }
}

class OfferTheme {
  static const gradients = [
    [Color(0xFF1B6B2F), Color(0xFF2E8B47)],
    [Color(0xFF1A3A8F), Color(0xFF2B5CE6)],
    [Color(0xFF8F1A1A), Color(0xFFE62B2B)],
  ];

  static List<Color> gradientFor(int index) {
    return gradients[index % gradients.length];
  }

  static Color indicatorColor(int index) {
    return gradientFor(index).first;
  }
}
