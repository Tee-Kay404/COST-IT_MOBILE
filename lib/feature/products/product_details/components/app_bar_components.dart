import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/widget/saved_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isCollapsed;

  const AppBarCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCollapsed) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38.r,
          height: 38.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20.sp),
        ),
      );
    }

    // When collapsed (solid AppBar): subtle translucent circle
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.20),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: CostItColors.white, size: 22.sp),
      ),
    );
  }
}

class AppBarSaveButton extends ConsumerWidget {
  final String productId;
  final bool isCollapsed;

  const AppBarSaveButton({
    super.key,
    required this.productId,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Match AppBarCircleButton dimensions exactly
    final size = isCollapsed ? 36.w : 38.r;
    final bgColor = isCollapsed
        ? Colors.white.withValues(alpha: 0.20)
        : Colors.black.withValues(alpha: 0.45);
    return SaveIconButton(
      productId: productId,
      size: size,
      backgroundColor: bgColor,
      iconColor: CostItColors.white,
    );
  }
}

class MoreOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;
  final Color? iconColor;

  const MoreOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white : Colors.grey.shade700;
    final defaultLabelColor = isDark
        ? Colors.white
        : CostItColors.brightGrey.shade700;
    final trailingColor = isDark ? Colors.white : Colors.grey.shade400;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: iconColor ?? defaultColor),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: context.bodyMedium?.copyWith(
                  color: labelColor ?? defaultLabelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18.sp,
              color: trailingColor,
            ),
          ],
        ),
      ),
    );
  }
}
