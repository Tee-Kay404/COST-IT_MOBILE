import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/styles/styles.dart';
import 'package:cost_it_mobile/app/global/utils/guest_gate.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionButtonsSection extends ConsumerWidget {
  final Product product;

  const ActionButtonsSection({super.key, required this.product});

  Future<void> _contactVendor(BuildContext context) async {
    final phone = product.vendor.phoneNumber;

    if (phone == null || phone.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vendor has not provided a contact number.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final uri = Uri(scheme: 'tel', path: phone.trim());

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open the phone dialer.'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    String? phone = product.vendor.phoneNumber?.trim();

    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vendor has not provided a WhatsApp number.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    // Normalize Nigerian numbers to international format (no +, no spaces)
    // 08012345678 → 2348012345678  |  +2348012345678 → 2348012345678
    String normalized = phone.replaceAll(RegExp(r'[\s\-()]'), '');
    if (normalized.startsWith('+')) normalized = normalized.substring(1);
    if (normalized.startsWith('0')) {
      normalized = '234${normalized.substring(1)}';
    }

    final productName = product.title;
    final message = Uri.encodeComponent(
      'Hello! I\'m interested in your listing: "$productName". Is it still available?',
    );
    final uri = Uri.parse('https://wa.me/$normalized?text=$message');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Could not open WhatsApp. Please make sure it is installed.',
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: context.color.surface,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => guardAuth(context, ref, () => _openWhatsApp(context)),
              icon: Image.asset(
                AppImages.whatsapp,
                width: 24.sp,
                height: 24.sp,
              ),
              label: Text(
                'WhatsApp',
                style: context.bodySmall?.copyWith(
                  color: CostItColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: outlinedButtonStyle(
                outlineColor: context.color.primary,
                color: context.color.primary,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () =>
                  guardAuth(context, ref, () => _contactVendor(context)),
              icon: Icon(Icons.call_rounded, size: 18.sp, color: Colors.white),
              label: Text(
                'Contact Vendor',
                style: context.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: flatButtonStyle(
                color: context.color.primary,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                borderRadius: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
