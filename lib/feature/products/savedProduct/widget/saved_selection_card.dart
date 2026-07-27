import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedSelectionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  const SavedSelectionBar({
    super.key,
    required this.selectedCount,
    required this.onDelete,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: selectedCount > 0 ? Offset.zero : const Offset(0, 1),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: selectedCount > 0 ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: context.color.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                '$selectedCount item${selectedCount == 1 ? '' : 's'} selected',
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.color.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              _ActionButton(
                icon: Icons.ios_share_rounded,
                label: 'Share',
                color: context.color.primary,
                onTap: onShare,
              ),
              SizedBox(width: 12.w),
              _ActionButton(
                icon: Icons.delete_outline_rounded,
                label: 'Remove',
                color: const Color(0xFFE53935),
                onTap: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17.r, color: color),
            SizedBox(width: 5.w),
            Text(
              label,
              style: context.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
