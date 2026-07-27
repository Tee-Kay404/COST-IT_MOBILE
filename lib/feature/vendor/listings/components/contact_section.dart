import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/shared/validators.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:cost_it_mobile/feature/vendor/listings/models/sell_form_state.dart';
import 'package:cost_it_mobile/feature/vendor/listings/providers/sell_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../models/sell.dart';

class ContactSection extends StatelessWidget {
  final SellFormState state;
  final SellFormNotifier notifier;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;

  const ContactSection({
    super.key,
    required this.state,
    required this.notifier,
    required this.nameCtrl,
    required this.phoneCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormSectionHeader(
            title: 'Contact info',
            subtitle: 'Buyers will reach you here',
            icon: Icons.person_outline_rounded,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: Column(
              children: [
                CostItFormfield(
                  controller: nameCtrl,
                  labelText: 'Your name *',
                  hintText: 'Full name or business name',
                  keyboardType: TextInputType.name,
                  onChanged: notifier.setContactName,
                  enabled: false,
                  suffixIcon: Tooltip(
                    message: 'Pulled from your account profile',
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: 16.sp,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                Gap(6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'To change your name, update your profile.',
                    style: context.bodySmall?.copyWith(
                      fontSize: 11.sp,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Gap(14.h),

                CostItFormfield(
                  controller: phoneCtrl,
                  labelText: 'Phone number *',
                  hintText: '08012345678',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇳🇬', style: TextStyle(fontSize: 16.sp)),
                        Gap(4.w),
                        Text(
                          '+234',
                          style: context.bodySmall?.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onChanged: notifier.setContactPhone,
                  validator: Validators.validatePhone,
                ),
                Gap(4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

               