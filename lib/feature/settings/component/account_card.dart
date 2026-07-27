import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AccountSummaryCard extends StatelessWidget {
  final String displayName;
  final String email;
  final String? photoUrl;

  const AccountSummaryCard({
    super.key,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final initials = displayName.isNotEmpty
        ? displayName.trim().split(' ').map((w) => w[0]).take(2).join()
        : 'G';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23.w,
            backgroundColor: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white 
                : context.color.primary,
            backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
                ? NetworkImage(photoUrl!)
                : null,
            child: (photoUrl == null || photoUrl!.isEmpty)
                ? Text(
                    initials.toUpperCase(),
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? context.color.primary 
                          : CostItColors.white,
                    ),
                  )
                : null,
          ),
          Gap(12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (email.isNotEmpty) ...[
                  Gap(2.h),
                  Text(
                    email,
                    style: context.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
