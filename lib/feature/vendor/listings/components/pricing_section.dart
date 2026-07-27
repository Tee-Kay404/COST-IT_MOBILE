import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:cost_it_mobile/feature/vendor/listings/models/sell_form_state.dart';
import 'package:cost_it_mobile/feature/vendor/listings/providers/sell_state_notifier.dart';
import 'package:cost_it_mobile/widgets/tools.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../models/sell.dart';

class PricingSection extends StatelessWidget {
  final SellFormState state;
  final SellFormNotifier notifier;
  final TextEditingController priceCtrl;

  const PricingSection({
    super.key,
    required this.state,
    required this.notifier,
    required this.priceCtrl,
  });

  Future<void> _pickBulkPrice(BuildContext context) async {
    String? size = state.bulkSize;
    String? price = state.bulkPrice;
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: price);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: context.color.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: _BulkPriceSheet(
              formKey: formKey,
              initialSize: size,
              priceController: controller,
              onSizeChanged: (v) => size = v,
              onPriceChanged: (v) => price = v,
              onConfirm: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(ctx, {'size': size!, 'price': controller.text});
                }
              },
              onCancel: () => Navigator.pop(ctx),
            ),
          ),
        ),
      ),
    );

    if (result != null) {
      notifier.setBulkSize(result['size']!);
      notifier.setBulkPrice(result['price']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      child: SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormSectionHeader(
              title: 'Pricing',
              icon: Icons.payments_outlined,
              trailing: state.price.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: context.color.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '₦${formatPrice(parseDouble(state.price.replaceAll(',', '')))}',
                        style: context.bodySmall?.copyWith(
                          color: context.color.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : null,
            ),
            Gap(16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CostItFormfield(
                    controller: priceCtrl,
                    labelText: 'Item price *',
                    hintText: '0.00',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        '₦',
                        style: context.bodyMedium?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: CostItColors.brightGrey.shade500,
                        ),
                      ),
                    ),
                    onChanged: notifier.setPrice,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter a price';
                      }
                      final parsed = double.tryParse(v.replaceAll(',', ''));
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  Gap(18.h),

                  NegotiationToggle(
                    value: state.negotiation,
                    onChanged: notifier.setNegotiation,
                  ),
                  Gap(16.h),

                  SelectorTile(
                    label: 'Bulk / wholesale price',
                    value: state.bulkSize != null && state.bulkPrice != null
                        ? '${state.bulkSize}  ·  ₦${NumberFormat("#,##0.##", "en_US").format(parseDouble(state.bulkPrice!.replaceAll(',', '')))} per piece'
                        : null,
                    leadingIcon: Icons.layers_outlined,
                    required: false,
                    onTap: () => _pickBulkPrice(context),
                  ),
                  Gap(16.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulkPriceSheet extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String? initialSize;
  final TextEditingController priceController;
  final ValueChanged<String?> onSizeChanged;
  final ValueChanged<String> onPriceChanged;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _BulkPriceSheet({
    required this.formKey,
    this.initialSize,
    required this.priceController,
    required this.onSizeChanged,
    required this.onPriceChanged,
    required this.onConfirm,
    required this.onCancel,
  });

  static final _bulkSizes = List.generate(
    10,
    (i) => 'From ${(i + 1) * 5} pieces',
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: context.color.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.layers_outlined,
                    size: 20.sp,
                    color: context.color.onPrimary,
                  ),
                ),
                Gap(12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bulk / wholesale price',
                      style: context.bodyMedium?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: context.color.inverseSurface,
                      ),
                    ),
                    Text(
                      'Offer a better rate for large orders',
                      style: context.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: isDark
                            ? CostItColors.brightGrey.shade300
                            : CostItColors.brightGrey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(24.h),

            Theme(
              data: Theme.of(context).copyWith(focusColor: Colors.transparent),
              child: DropdownButtonFormField2<String>(
                value: initialSize,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Minimum quantity *',
                  labelStyle: TextStyle(
                    fontSize: 13.sp,
                    color: CostItColors.brightGrey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  filled: false,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: context.color.primary,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: CostItColors.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: CostItColors.error,
                      width: 1.5,
                    ),
                  ),
                ),
                style: context.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: context.color.inverseSurface,
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 20.sp,
                    color: CostItColors.brightGrey.shade500,
                  ),
                ),
                buttonStyleData: ButtonStyleData(
                  padding: EdgeInsets.only(right: 4.w),
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: context.color.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  maxHeight: 220.h,
                ),
                menuItemStyleData: MenuItemStyleData(
                  height: 44.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  selectedMenuItemBuilder: (ctx, child) => Container(
                    color: isDark
                        ? Colors.transparent
                        : CostItColors.brightGrey.shade100,
                    child: child,
                  ),
                ),
                selectedItemBuilder: (ctx) {
                  return _bulkSizes.map((e) {
                    return Text(
                      e,
                      style: context.bodySmall?.copyWith(
                        fontSize: 14.sp,
                        color: context.color.inverseSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList();
                },
                items: _bulkSizes
                    .map(
                      (e) {
                        final isSelected = initialSize == e;
                        return DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: context.bodySmall?.copyWith(
                              fontSize: 14.sp,
                              color: isSelected 
                                  ? (isDark ? CostItColors.secondaryDark : context.color.primary)
                                  : context.color.inverseSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                    )
                    .toList(),
                onChanged: onSizeChanged,
                validator: (v) =>
                    v == null ? 'Select a minimum quantity' : null,
              ),
            ),
            Gap(14.h),

            CostItFormfield(
              controller: priceController,
              labelText: 'Price per piece *',
              hintText: '0.00',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  '₦',
                  style: context.bodyMedium?.copyWith(
                    fontSize: 18.sp,
                    color: context.color.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              onChanged: onPriceChanged,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter a price';
                final parsed = double.tryParse(v.replaceAll(',', ''));
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
            Gap(28.h),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                    ),
                    child: Text(
                      'Cancel',
                      style: context.bodySmall?.copyWith(
                        fontSize: 13.sp,
                        color: CostItColors.brightGrey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.color.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                    ),
                    child: Text(
                      'Save',
                      style: context.bodySmall?.copyWith(
                        fontSize: 13.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
