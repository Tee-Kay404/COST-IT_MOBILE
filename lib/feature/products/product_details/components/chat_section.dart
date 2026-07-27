import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:cost_it_mobile/app/global/utils/guest_gate.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/components/textfields/costit_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatSection extends ConsumerWidget {
  final TextEditingController messageController;

  const ChatSection({super.key, required this.messageController});

  static const List<String> _quickReplies = [
    'Is this available?',
    'What\'s your best price?',
    'Do you offer bulk discount?',
    'Can you deliver to site?',
    'Send me more photos',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: context.color.surface,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Message the vendor',
            style: context.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.color.onPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Ask anything — availability, delivery, bulk pricing.',
            style: context.bodySmall?.copyWith(
              color: Colors.grey.shade500,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 12.h),

          SizedBox(
            height: 36.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _quickReplies.length,
              physics: BouncingScrollPhysics(),
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (_, i) => OutlinedButton(
                onPressed: () => guardAuth(context, ref, () {
                  messageController.text = _quickReplies[i];
                }),
                style: outlinedButtonStyle(
                  borderRadius: (30.r),
                  outlineColor: context.color.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                ),
                child: Text(
                  _quickReplies[i],
                  style: context.bodySmall?.copyWith(
                    color: context.color.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          CostItTextfield(
            maxLines: 2,
            hintText: 'Type your message here...',
            controller: messageController,
            fillColor: context.color.inversePrimary,
            filled: true,
            enabledBorderColor: CostItColors.brightGrey.shade500,
          ),

          SizedBox(height: 10.h),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => guardAuth(context, ref, () {}),
              style: flatButtonStyle(
                color: context.color.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                borderRadius: 10,
              ),
              child: Text(
                'Send Message',
                style: context.bodyMedium?.copyWith(
                  color: CostItColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
