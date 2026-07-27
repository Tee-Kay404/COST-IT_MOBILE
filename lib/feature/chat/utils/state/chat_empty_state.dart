import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';

class ChatEmptyState extends StatelessWidget {
  final VoidCallback onFindVendor;
  final VoidCallback onInviteContact;

  const ChatEmptyState({
    super.key,
    required this.onFindVendor,
    required this.onInviteContact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.chat, height: 160.h, fit: BoxFit.contain),
            SizedBox(height: 32.h),

            Text(
              'No conversations yet',
              style: context.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),

            Text(
              'Chat with vendors about materials, negotiate prices, '
              'or invite contacts to join Cost-It.',
              style: context.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? CostItColors.brightGrey.shade500
                    : color.onSurface.withOpacity(0.55),
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 36.h),

            FilledButton.icon(
              onPressed: onFindVendor,
              icon: Icon(Icons.storefront_outlined, size: 18.sp),
              label: Text(
                'Browse Vendors & Products',
                style: context.bodyMedium?.copyWith(color: CostItColors.white),
              ),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
