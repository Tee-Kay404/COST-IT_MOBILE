import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/product_details/components/components.dart';
import 'package:cost_it_mobile/feature/products/product_details/components/modals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/app/storage/recently_viewed_products.dart';

class ProdDetailsView extends ConsumerStatefulWidget {
  final Product product;

  const ProdDetailsView({super.key, required this.product});

  @override
  ConsumerState<ProdDetailsView> createState() => _ProdDetailsViewState();
}

class _ProdDetailsViewState extends ConsumerState<ProdDetailsView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  bool _isAppBarCollapsed = false;
  bool _isDescriptionExpanded = false;
  RelatedDisplayMode _relatedMode = RelatedDisplayMode.grid;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentlyViewedProvider.notifier).addProduct(widget.product);
    });
  }

  void _onScroll() {
    final collapsed = _scrollController.offset > 220.h;
    if (collapsed != _isAppBarCollapsed) {
      setState(() => _isAppBarCollapsed = collapsed);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Theme.of(context).colorScheme.primary,
      ),
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: ProductDetailsAppBar(
          product: product,
          isCollapsed: _isAppBarCollapsed,
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Hero(
                tag: 'product-hero-${product.id}',
                child: HeroImageSection(product: product),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PriceMetaSection(product: product),
                  if (product.specialOffer?.isActive == true) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF4040), Color(0xFFFF7A00)],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 20.sp),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.specialOffer!.discountLabel,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  if (product.specialOffer!.badgeText != null)
                                    Text(
                                      product.specialOffer!.badgeText!,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (product.specialOffer!.expiresAt != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Ends in',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  Text(
                                    _formatTimeLeft(product.specialOffer!.expiresAt!),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  _buildDivider(),
                  ActionButtonsSection(product: product),
                  _buildDivider(),
                  DescriptionSection(
                    product: product,
                    isExpanded: _isDescriptionExpanded,
                    onToggle: () => setState(
                      () => _isDescriptionExpanded = !_isDescriptionExpanded,
                    ),
                  ),
                  _buildDivider(),
                  ChatSection(messageController: _messageController),
                  _buildDivider(),
                  SpecsGridSection(product: product),
                  _buildDivider(),
                  VendorCardSection(product: product),
                  _buildDivider(),
                  RelatedProductsSection(
                    product: product,
                    mode: _relatedMode,
                    onToggleMode: () => setState(
                      () =>
                          _relatedMode = _relatedMode == RelatedDisplayMode.grid
                          ? RelatedDisplayMode.list
                          : RelatedDisplayMode.grid,
                    ),
                  ),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomBarSection(
          onMakeOffer: () => showMakeOfferSheet(context, product),
        ),
      ),
    );
  }


  Widget _buildDivider() => Container(
        height: 8.h,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : CostItColors.brightGrey.shade100,
      );

  String _formatTimeLeft(DateTime expiresAt) {
    final diff = expiresAt.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    if (diff.inDays > 0) return '${diff.inDays}d ${diff.inHours % 24}h';
    if (diff.inHours > 0) return '${diff.inHours}h ${diff.inMinutes % 60}m';
    return '${diff.inMinutes}m';
  }
}
