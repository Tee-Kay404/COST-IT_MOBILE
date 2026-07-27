import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/chat/utils/permission/chat_permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatPermissionBanner extends StatelessWidget {
  final List<ChatPermission> missingPermissions;
  final VoidCallback onRequestAll;
  final VoidCallback onOpenSettings;

  const ChatPermissionBanner({
    super.key,
    required this.missingPermissions,
    required this.onRequestAll,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.color;

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Missing permissions',
            style: context.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8.h),
          Text(
            'Some features won\'t work without these permissions:',
            style: context.bodySmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? color.inverseSurface
                  : color.onSurface.withOpacity(0.55),
            ),
          ),
          SizedBox(height: 16.h),
          ...missingPermissions.map(
            (p) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Icon(
                    p.icon,
                    size: 20.r,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? color.onPrimary
                        : color.primary,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    p.label,
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onOpenSettings,
                  child: const Text('Open Settings'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: FilledButton(
                  onPressed: onRequestAll,
                  child: const Text('Allow All'),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
