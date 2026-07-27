import 'package:cost_it_mobile/app/global/utils/text_links.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/components/buttons/outlined_button.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:cost_it_mobile/feature/vendor/listings/models/sell_form_state.dart';
import 'package:cost_it_mobile/widgets/text_span.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ListingSubmitArea extends StatelessWidget {
  final SellFormState state;
  final bool canPost;
  final bool isExpanded;
  final VoidCallback onSubmit;
  final VoidCallback onSaveDraft;

  const ListingSubmitArea({
    super.key,
    required this.state,
    required this.canPost,
    required this.isExpanded,
    required this.onSubmit,
    required this.onSaveDraft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.color.surface,
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SharedButton(
            onPressed: (state.isSubmitting || !canPost) ? null : onSubmit,
            text: state.isSubmitting ? 'Posting…' : 'Post listing',
            color: canPost ? context.color.primary : Colors.grey.shade300,
            disabledForeground: canPost ? null : Colors.grey.shade500,
            height: 60.h,
          ),
          if (isExpanded) ...[
            Gap(12.h),
            SharedOutlinedButton(
              onPressed: state.isSavingDraft ? null : onSaveDraft,
              text: state.isSavingDraft
                  ? 'Saving Draft...'
                  : (state.editingProductId != null
                      ? 'Update Draft'
                      : 'Save Listing and Post Later'),
              height: 55.h,
            ),
            Gap(16.h),
            TextSpanWithLink(
              textAlign: TextAlign.center,
              style: context.bodySmall?.copyWith(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
              linkColor: context.color.onPrimary,
              autoUnderlined: true,
              textSpanList: [
                const TextWithLinkModel(text: "By posting you agree to CostIt's "),
                TextLink.termsOfService.model,
                const TextWithLinkModel(
                  text:
                      " and confirm this listing doesn't include prohibited items.",
                ),
              ],
            ),
          ],
          Gap(12.h),
        ],
      ),
    );
  }
}

