// lib/feature/products/product_details/components/bottom_bar_section.dart

import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:cost_it_mobile/app/global/utils/guest_gate.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomBarSection extends ConsumerWidget {
  final VoidCallback onMakeOffer;

  const BottomBarSection({super.key, required this.onMakeOffer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        16.w,
        10.h,
        16.w,
        10.h + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => guardAuth(context, ref, onMakeOffer),
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 16.sp,
                color: context.color.primary,
              ),
              label: Text(
                'Submit an Offer',
                style: context.bodySmall?.copyWith(
                  color: context.color.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: outlinedButtonStyle(
                outlineColor: context.color.primary,
                padding: EdgeInsets.symmetric(vertical: 13.h),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => guardAuth(context, ref, () {
                Navigator.pushNamed(context, PageRoutes.sell.name);
              }),
              icon: Icon(
                Icons.add_business_outlined,
                size: 16.sp,
                color: Colors.white,
              ),
              label: Text(
                'List a Similar Item',
                style: context.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: flatButtonStyle(
                color: context.color.primary,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                borderRadius: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
