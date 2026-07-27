import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/services/product_service.dart';
import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';
import 'package:cost_it_mobile/feature/vendor/listings/my_listings/widgets/seller_product_overflow_menu.dart';
import 'package:cost_it_mobile/feature/vendor/listings/providers/sell_provider.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/vpdp.dart';



/// Vendor-facing product detail page. Pure orchestration — all
/// visual sections live in components/, all colors route through
/// context.color.primary / context.color.secondary / theme text
/// styles (no standalone hex hues except semantic success/error).
class VendorProductDetailPage extends ConsumerStatefulWidget {
  final Product product;
  const VendorProductDetailPage({super.key, required this.product});

  @override
  ConsumerState<VendorProductDetailPage> createState() =>
      _VendorProductDetailPageState();
}

class _VendorProductDetailPageState
    extends ConsumerState<VendorProductDetailPage>
    with SingleTickerProviderStateMixin {
  late Product _product;
  int _currentImageIndex = 0;
  late final PageController _pageController;
  late final AnimationController _fabAnim;
  late final Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _pageController = PageController();

    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.elasticOut);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _fabAnim.forward();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnim.dispose();
    super.dispose();
  }

  bool get _isDraft =>
      _product.status == ListingStatus.unavailable ||
      _product.status == ListingStatus.suspended;

  List<String> get _images {
    final all = <String>[
      if (_product.thumbnailUrl != null) _product.thumbnailUrl!,
      ..._product.images,
    ];
    return all.toSet().toList();
  }

  Future<void> _handleAction(ProductAction action) async {
    switch (action) {
      case ProductAction.edit:
        ref.read(sellFormProvider.notifier).clearAll();
        if (mounted) {
          Navigator.pushNamed(context, PageRoutes.sell.name, arguments: _product);
        }
        break;

      case ProductAction.delete:
        final ok = await _confirmDialog(
          title: 'Delete Listing?',
          body: 'This will permanently remove "${_product.title}" from your listings.',
          confirmLabel: 'Delete',
          destructive: true,
        );
        if (ok && mounted) {
          try {
            await ref.read(productServiceProvider).deleteProduct(_product.id);
            ref.read(myListingsProvider.notifier).removeLocally(_product.id);
            if (mounted) Navigator.pop(context);
          } catch (_) {}
        }
        break;

      case ProductAction.unpublish:
        final ok = await _confirmDialog(
          title: 'Unpublish Listing?',
          body: '"${_product.title}" will be hidden from buyers and moved to Drafts.',
          confirmLabel: 'Move to Drafts',
        );
        if (ok && mounted) {
          try {
            await ref.read(productServiceProvider).editProduct(_product.id, {
              'status': 'unavailable',
            });
            ref
                .read(myListingsProvider.notifier)
                .updateStatusLocally(_product.id, ListingStatus.unavailable);
            setState(
              () => _product = _product.copyWith(status: ListingStatus.unavailable),
            );
          } catch (_) {}
        }
        break;

      case ProductAction.publish:
        try {
          await ref.read(productServiceProvider).editProduct(_product.id, {
            'status': 'available',
          });
          ref
              .read(myListingsProvider.notifier)
              .updateStatusLocally(_product.id, ListingStatus.available);
          setState(() => _product = _product.copyWith(status: ListingStatus.available));
        } catch (_) {}
        break;

      case ProductAction.archive:
        final ok = await _confirmDialog(
          title: 'Archive Listing?',
          body: '"${_product.title}" will be moved to Archived. Buyers won\'t see it.',
          confirmLabel: 'Archive',
        );
        if (ok && mounted) {
          try {
            await ref.read(productServiceProvider).editProduct(_product.id, {
              'status': 'archived',
            });
            ref
                .read(myListingsProvider.notifier)
                .updateStatusLocally(_product.id, ListingStatus.archived);
            setState(() => _product = _product.copyWith(status: ListingStatus.archived));
          } catch (_) {}
        }
        break;

      default:
        break;
    }
  }

  Future<bool> _confirmDialog({
    required String title,
    required String body,
    required String confirmLabel,
    bool destructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.color.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          title,
          style: ctx.bodyLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 17.sp),
        ),
        content: Text(body, style: ctx.bodySmall),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: destructive ? ctx.color.error : ctx.color.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              confirmLabel,
              style: ctx.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showMoreActions() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MoreActionsSheet(
        product: _product,
        isDraft: _isDraft,
        onAction: (action) {
          Navigator.pop(context);
          _handleAction(action);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = _images;
    final hasImages = images.isNotEmpty;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Theme.of(context).colorScheme.primary,
      ),
      child: Scaffold(
        backgroundColor: context.color.surface,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 320.h,
                  pinned: true,
                  backgroundColor: context.color.primary,
                  leading: const DetailBackButton(),
                  actions: [
                    DetailMoreButton(onTap: _showMoreActions),
                    SizedBox(width: 8.w),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: HeroGallery(
                      images: images,
                      hasImages: hasImages,
                      currentIndex: _currentImageIndex,
                      pageController: _pageController,
                      onPageChanged: (i) => setState(() => _currentImageIndex = i),
                      product: _product,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MetricsStrip(product: _product, isDraft: _isDraft),
                      TitlePriceCard(product: _product),
                      if (_product.specialOffer?.isActive == true)
                        SpecialOfferBanner(offer: _product.specialOffer!),
                      DetailsGrid(product: _product),
                      if (_product.description != null &&
                          _product.description!.trim().isNotEmpty)
                        DescriptionCard(description: _product.description!),
                      SizedBox(height: 140.h),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomActionBar(
                product: _product,
                isDraft: _isDraft,
                fabAnim: _fabScale,
                onEdit: () => _handleAction(ProductAction.edit),
                onMore: _showMoreActions,
                onPublishToggle: () => _handleAction(
                  _isDraft ? ProductAction.publish : ProductAction.unpublish,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}