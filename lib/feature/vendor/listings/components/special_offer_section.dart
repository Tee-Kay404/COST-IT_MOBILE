import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:cost_it_mobile/feature/vendor/listings/models/sell_form_state.dart';
import 'package:cost_it_mobile/feature/vendor/listings/providers/sell_provider.dart';
import 'package:cost_it_mobile/feature/vendor/listings/providers/sell_state_notifier.dart';
import 'package:cost_it_mobile/feature/vendor/listings/widgets/section_card.dart';
import 'package:cost_it_mobile/feature/vendor/listings/widgets/selector_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'special_offer/discount_modal.dart';
import 'special_offer/expiry_date_tile.dart';
import 'special_offer/offer_preview_chip.dart';
import '../my_listings/modals/expiry_date_modal.dart';

class SpecialOfferSection extends ConsumerStatefulWidget {
  final TextEditingController offerLabelCtrl;
  final TextEditingController offerBadgeCtrl;
  final String? expiryError;

  const SpecialOfferSection({
    super.key,
    required this.offerLabelCtrl,
    required this.offerBadgeCtrl,
    this.expiryError,
  });

  @override
  ConsumerState<SpecialOfferSection> createState() =>
      _SpecialOfferSectionState();
}

class _SpecialOfferSectionState extends ConsumerState<SpecialOfferSection> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellFormProvider);
    final notifier = ref.read(sellFormProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => notifier.toggleSpecialOffer(!state.hasSpecialOffer),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: state.hasSpecialOffer
                          ? context.color.primary.withValues(alpha: 0.12)
                          : (isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade100),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_offer_rounded,
                      size: 20.sp,
                      color: state.hasSpecialOffer
                          ? context.color.primary
                          : Colors.grey.shade500,
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Special Offer',
                          style: context.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                            color: context.theme.primaryColorDark,
                          ),
                        ),
                        Gap(2.h),
                        Text(
                          state.hasSpecialOffer
                              ? 'This listing will be tagged with your offer'
                              : 'Optional — attract buyers with a deal',
                          style: context.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.9,
                    child: Switch.adaptive(
                      value: state.hasSpecialOffer,
                      activeTrackColor: context.color.primary,
                      activeColor: CostItColors.brightGrey.shade300,
                      onChanged: notifier.toggleSpecialOffer,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeInOutCubic,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 280),
              opacity: state.hasSpecialOffer ? 1.0 : 0.0,
              child: state.hasSpecialOffer
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.offerLabel.isNotEmpty)
                            OfferPreviewChip(state: state),

                          Gap(16.h),

                          FormField<String>(
                            validator: (_) {
                              if (state.hasSpecialOffer &&
                                  state.offerLabel.isEmpty) {
                                return 'Select a discount';
                              }
                              return null;
                            },
                            builder: (field) {
                              return SelectorTile(
                                label: 'Discount',
                                value: state.offerLabel.isEmpty
                                    ? null
                                    : state.offerLabel,
                                leadingIcon: Icons.percent_rounded,
                                required: true,
                                onTap: () => _showDiscountModal(
                                  context,
                                  state,
                                  notifier,
                                  field,
                                ),
                                errorText: field.errorText,
                              );
                            },
                          ),

                          Gap(14.h),

                          CostItFormfield(
                            controller: widget.offerBadgeCtrl,
                            labelText: 'Badge text (optional)',
                            hintText: 'e.g. Flash Sale, Weekend Deal',
                            keyboardType: TextInputType.text,
                            onChanged: notifier.setOfferBadge,
                          ),
                          Gap(14.h),

                          ExpiryDateTile(
                            value: state.offerExpiresAt,
                            isDark: isDark,
                            errorText: widget.expiryError,
                            onPick: () => _pickExpiry(context, notifier, state),
                            onClear: () => notifier.clearOfferExpiry(),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  void _showDiscountModal(
    BuildContext context,
    SellFormState state,
    SellFormNotifier notifier,
    FormFieldState<String> field,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => DiscountModal(
        initialValue: state.offerLabel,
        onSave: (val) {
          notifier.setOfferLabel(val);
          widget.offerLabelCtrl.text = val;
          field.didChange(val);         },
      ),
    );
  }

  Future<void> _pickExpiry(
    BuildContext context,
    SellFormNotifier notifier,
    SellFormState state,
  ) async {
    final result = await showModalBottomSheet<DateTime>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => ExpiryDateModal(initialDate: state.offerExpiresAt),
    );

    if (result != null) {
      notifier.setOfferExpiry(result);
    }
  }
}
