import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/utils/guest_gate.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/app/storage/saved_products.dart';
import 'package:cost_it_mobile/widgets/toasts.dart';
import 'package:cost_it_mobile/feature/products/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SaveIconStyle { floatingOnImage, bare }

class SaveIconButton extends ConsumerWidget {
  final String productId;
  final SaveIconStyle style;

  final double? size;
  final Color? backgroundColor;
  final Color? iconColor;

  const SaveIconButton({
    super.key,
    required this.productId,
    this.style = SaveIconStyle.floatingOnImage,
    this.size,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(isSavedProvider(productId));

    void handleTap() {
      guardAuth(context, ref, () async {
        // Toggle local state optimistically
        ref.read(savedProductsLocalProvider.notifier).toggle(productId);

      final newSavedState = !isSaved;

      try {
        if (newSavedState) {
          await ref.read(productServiceProvider).saveProduct(productId);
        } else {
          await ref.read(productServiceProvider).removeSavedProduct(productId);
        }

        if (context.mounted) {
          showSavedToast(
            context,
            newSavedState
                ? "Product Saved Successfully!!!"
                : "Removed from saved products",
            icon: newSavedState ? Icons.check_circle_outline : Icons.close_outlined,
          );
        }
      } catch (e) {
        // Revert local state on failure
        ref.read(savedProductsLocalProvider.notifier).toggle(productId);
        if (context.mounted) {
          showSavedToast(
            context,
            "Failed to update saved status",
            icon: Icons.error_outline,
          );
        }
      }
      });
    }

    final iconSize = (size ?? 32.w) * 0.55;

    if (style == SaveIconStyle.bare) {
      return GestureDetector(
        onTap: handleTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            key: ValueKey(isSaved),
            size: iconSize,
            color:
                iconColor ??
                (isSaved ? context.color.primary : Colors.grey.shade500),
          ),
        ),
      );
    }

    return Material(
      color: backgroundColor ?? Colors.white.withValues(alpha: 0.20),
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        onTap: handleTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size ?? 32.w,
          height: size ?? 32.w,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              key: ValueKey(isSaved),
              size: iconSize,
              color:
                  iconColor ??
                  (isSaved
                      ? context.color.secondary
                      : CostItColors.brightGrey.shade400),
            ),
          ),
        ),
      ),
    );
  }
}
