import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/components/textfields/costit_textfield.dart';
import 'package:cost_it_mobile/feature/auth/shared/validators.dart';
import 'package:cost_it_mobile/feature/products/product_details/components/app_bar_components.dart';
import 'package:cost_it_mobile/feature/products/product_details/components/more_options_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';

void showMakeOfferSheet(BuildContext context, Product product) {
  final offerController = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Make an Offer',
              style: context.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.color.onPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Current price: ₦${product.price} per ${product.unit}',
              style: context.bodySmall?.copyWith(
                color: CostItColors.brightGrey.shade500,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 50.h,
              child: CostItTextfield(
                hintText: 'Your offer Price in (Naira)',
                controller: offerController,
                keyboardType: TextInputType.number,
                validator: Validators.isNotEmpty,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: flatButtonStyle(
                  color: context.color.primary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  borderRadius: 10,
                ),
                child: Text(
                  'Send Offer',
                  style: context.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


 void showMoreOptionsSheet(BuildContext context, Product product) {
    final options = MoreOptionsSheetHelper.buildMoreOptions(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.fromLTRB(
          12.w,
          12.h,
          12.w,
          24.h + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (_, i) {
                final opt = options[i];
                return MoreOptionTile(
                  icon: opt['icon'] as IconData,
                  label: opt['label'] as String,
                  onTap: opt['onTap'] as VoidCallback,
                );
              },
            ),
            const Divider(height: 1),
            MoreOptionTile(
              icon: Icons.flag_outlined,
              label: 'Report this vendor',
              labelColor: CostItColors.error,
              iconColor: CostItColors.error,
              onTap: () {
                Navigator.pop(context);
                showReportSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }

   void showReportSheet(BuildContext context) {
    final reasons = [
      'Fraudulent or scam listing',
      'Incorrect product information',
      'Prohibited item',
      'Already sold / no longer available',
      'Duplicate listing',
      'Other',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.fromLTRB(
          16.w,
          20.h,
          16.w,
          32.h + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Report this vendor',
              style: context.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4.h),
            Text(
              'Select the reason that best applies',
              style: context.bodySmall?.copyWith(color: Colors.grey.shade500),
            ),
            SizedBox(height: 14.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reasons.length,
              itemBuilder: (_, i) => InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          reasons[i],
                          style: context.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18.sp,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

