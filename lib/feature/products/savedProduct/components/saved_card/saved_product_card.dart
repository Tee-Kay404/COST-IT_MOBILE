import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/components/saved_card/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedProductCard extends StatelessWidget {
  final Product product;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onRemove;

  const SavedProductCard({
    super.key,
    required this.product,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = context.color.onPrimary;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? activeColor
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardImage(
                product: product,
                isSelectionMode: isSelectionMode,
                isSelected: isSelected,
                onRemove: onRemove,
              ),
              CardDetails(
                product: product,
                isSelectionMode: isSelectionMode,
                isSelected: isSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


