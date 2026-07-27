import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';
import 'package:cost_it_mobile/feature/products/components/product_format/list_card.dart';
import 'package:cost_it_mobile/feature/products/widgets/product_list_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForYouSection extends ConsumerStatefulWidget {
  const ForYouSection({super.key});

  @override
  ConsumerState<ForYouSection> createState() => _ForYouSectionState();
}

class _ForYouSectionState extends ConsumerState<ForYouSection> {
  @override
  void initState() {
    super.initState();
  }

  ScrollController? _scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // In a NestedScrollView/CustomScrollView, we listen to the primary controller
    _scrollController?.removeListener(_onScroll);
    _scrollController = PrimaryScrollController.maybeOf(context);
    _scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController == null || !_scrollController!.hasClients) return;
    final maxScroll = _scrollController!.position.maxScrollExtent;
    final currentScroll = _scrollController!.position.pixels;
    
    if (currentScroll >= maxScroll - 200) {
      ref.read(forYouProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final forYouAsync = ref.watch(forYouProvider);

    return forYouAsync.when(
      loading: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 12.h),
            child: const ProductListShimmer(),
          ),
          childCount: 6,
        ),
      ),
      error: (e, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      data: (forYouState) {
        return SliverMainAxisGroup(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = forYouState.products[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: ProductListCard(product: product),
                    );
                  },
                  childCount: forYouState.products.length,
                ),
              ),
            ),

            // Loading more indicator at the bottom
            if (forYouState.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),

            // No more data indicator
            if (!forYouState.hasMore && forYouState.products.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: Text(
                      'You\'ve seen it all 🎉',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
