import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/widgets/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardImage extends StatelessWidget {
  final Product product;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onRemove;

  const CardImage({super.key, 
    required this.product,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'product-hero-${product.id}',
            child: product.displayImage != null
                ? Image.network(
                    product.displayImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _ImagePlaceholder(),
                  )
                : _ImagePlaceholder(),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.35),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ),

          Positioned(
            top: 8.h,
            right: 8.w,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelectionMode
                  ? const SizedBox.shrink(key: ValueKey('empty'))
                  : _RemoveButton(onRemove: onRemove),
            ),
          ),

          if (!product.isAvailable)
            Positioned(
              top: 8.h,
              left: 8.w,
              child: _StockBadge(status: product.status),
            ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.color.onSurface.withValues(alpha: 0.06),
      child: Icon(
        Icons.image_outlined,
        size: 32.r,
        color: context.color.onSurface.withValues(alpha: 0.25),
      ),
    );
  }
}

class _SelectionRadioButton extends StatelessWidget {
  final bool isSelected;

  const _SelectionRadioButton({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final activeColor = context.color.onPrimary;

    return AnimatedContainer(
      key: const ValueKey('radio'),
      duration: const Duration(milliseconds: 150),
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? activeColor : context.color.onSurface.withValues(alpha: 0.3),
          width: isSelected ? 6.r : 1.5,
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final VoidCallback onRemove;

  const _RemoveButton({required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const ValueKey('remove'),
      onTap: onRemove,
      child: Container(
        width: 28.r,
        height: 28.r,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.bookmark_remove_outlined,
          size: 16.r,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final ListingStatus status;

  const _StockBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: status == ListingStatus.outOfStock
            ? const Color(0xFFE53935)
            : const Color(0xFFFF6F00),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        status == ListingStatus.outOfStock ? 'Out of Stock' : 'Unavailable',
        style: TextStyle(
          color: Colors.white,
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}


class CardDetails extends StatelessWidget {
  final Product product;
  final bool isSelectionMode;
  final bool isSelected;

  const CardDetails({
    super.key, 
    required this.product,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.categoryLabel.toUpperCase(),
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: context.color.primary.withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 3.h),

          Text(
            product.title,
            style: context.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₦${formatPrice(product.price)}',
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: context.color.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Text(
                  '/${product.unit}',
                  style: context.bodySmall?.copyWith(
                    color: context.color.onSurface.withValues(alpha: 0.45),
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),

            SizedBox(height: 5.h),
            Row(
              children: [
                Icon(
                  Icons.storefront_outlined,
                  size: 11.r,
                  color: context.color.onSurface.withValues(alpha: 0.4),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    product.vendor.name,
                    style: context.bodySmall?.copyWith(
                      color: context.color.onSurface.withValues(alpha: 0.5),
                      fontSize: 10.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelectionMode)
                  _SelectionRadioButton(isSelected: isSelected),
              ],
            ),
        ],
      ),
    );
  }

  
}
