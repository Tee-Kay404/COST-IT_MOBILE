import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Status chip + views/inquiries metrics strip shown just under the
/// hero gallery. Status color is semantic (success/error) or theme
/// primary — never an arbitrary hue.
class MetricsStrip extends StatelessWidget {
  final Product product;
  final bool isDraft;

  const MetricsStrip({super.key, required this.product, required this.isDraft});

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor) = _statusConfig(context, product.status);

    return Container(
      color: context.color.primary.withValues(alpha: 0.05),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Row(
        children: [
          _StatusChip(label: statusLabel, color: statusColor),
          const Spacer(),
          if (!isDraft) ...[
            _MetricPill(
              icon: Icons.visibility_outlined,
              value: _compact(product.views),
              label: 'views',
            ),
            Gap(12.w),
            _MetricPill(
              icon: Icons.chat_bubble_outline_rounded,
              value: _compact(product.inquiries),
              label: 'inquiries',
            ),
          ],
        ],
      ),
    );
  }

  static String _compact(int v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toString();
  }

  static (String, Color) _statusConfig(BuildContext ctx, ListingStatus s) {
    switch (s) {
      case ListingStatus.available:
        return ('Published', CostItColors.success);
      case ListingStatus.unavailable:
      case ListingStatus.suspended:
        return ('Draft', ctx.color.secondary);
      case ListingStatus.outOfStock:
        return ('Out of Stock', CostItColors.error);
      case ListingStatus.pendingReview:
        return ('Pending Review', ctx.color.primary);
      case ListingStatus.rejected:
        return ('Rejected', CostItColors.error);
      case ListingStatus.archived:
        return ('Archived', CostItColors.brightGrey.shade500);
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.r,
            height: 7.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Gap(6.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _MetricPill({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.sp, color: context.color.onPrimary),
            Gap(4.w),
            Text(
              value,
              style: context.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 13.sp,
                color: context.color.inverseSurface,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9.sp,
            color: CostItColors.brightGrey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}