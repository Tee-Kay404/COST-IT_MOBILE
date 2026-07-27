import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/components/textfields/costit_textfield.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EditProfileForm extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final FocusNode firstNameFocusNode;
  final bool isEditing;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final VoidCallback? onVerifyPhone;

  const EditProfileForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.firstNameFocusNode,
    required this.isEditing,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.onVerifyPhone,
  });

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  String? _activeBadge;

  void _hideBadges() {
    if (_activeBadge != null) {
      setState(() {
        _activeBadge = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _hideBadges,
      child: Column(
        children: [
          _buildField(
            context,
            'First Name',
            Icons.person_outline,
            widget.firstNameController,
            focusNode: widget.firstNameFocusNode,
          ),
          Gap(16.h),
          _buildField(
            context,
            'Last Name',
            Icons.person_outline,
            widget.lastNameController,
          ),
          Gap(16.h),
          _buildField(
            context,
            'Email Address',
            Icons.email_outlined,
            widget.emailController,
            keyboardType: TextInputType.emailAddress,
            suffixIcon: _buildStatusBadge(
              context,
              widget.isEmailVerified,
              'email',
            ),
            bottomWidget: _buildVerifyAction(
              context,
              widget.isEmailVerified,
              'email',
              null,
            ),
          ),
          Gap(16.h),
          _buildField(
            context,
            'Phone Number',
            Icons.phone_outlined,
            widget.phoneController,
            keyboardType: TextInputType.phone,
            suffixIcon: _buildStatusBadge(
              context,
              widget.isPhoneVerified,
              'phone',
            ),
            bottomWidget: _buildVerifyAction(
              context,
              widget.isPhoneVerified,
              'phone',
              widget.onVerifyPhone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isVerified, String type) {
    return GestureDetector(
      onTap: () {
        if (!isVerified && !widget.isEditing) {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                child: Text(
                  'Click edit to verify',
                  textAlign: TextAlign.center,
                  style: context.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        } else {
          setState(() {
            _activeBadge = _activeBadge == type ? null : type;
          });
        }
      },
      child: Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: isVerified ? CostItColors.success : context.color.secondary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isVerified ? Icons.check : Icons.priority_high,
          color: Colors.white,
          size: 10.sp,
        ),
      ),
    );
  }

  Widget? _buildVerifyAction(
    BuildContext context,
    bool isVerified,
    String type,
    VoidCallback? onVerify,
  ) {
    if (!isVerified && widget.isEditing) {
      return Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 120.w,
            child: SharedButton(
              onPressed: () {
                _hideBadges();
                if (onVerify != null) onVerify();
              },
              text: 'Verify',
              height: 32.h,
              color: context.color.secondary,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      );
    }

    if (_activeBadge != type) return null;

    if (isVerified) {
      // Show verified text dropdown
      return Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Verified',
            style: context.bodySmall?.copyWith(
              color: const Color(0xFF00B53F),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return null; // The modal handles the unverified case outside edit mode
  }

  Widget _buildField(
    BuildContext context,
    String label,
    IconData? prefixIcon,
    TextEditingController controller, {
    TextInputType? keyboardType,
    FocusNode? focusNode,
    Widget? suffixIcon,
    Widget? bottomWidget,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label*',
          style: context.bodyMedium?.copyWith(
            color: isDark ? Colors.white70 : context.color.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(8.h),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            CostItTextfield(
              focusNode: focusNode,
              prefixIcon: Icon(
                prefixIcon,
                color: CostItColors.brightGrey.shade300,
                size: 26.sp,
              ),
              suffixIcon: suffixIcon != null ? SizedBox(width: 48.w) : null,
              controller: controller,
              enabled: widget.isEditing,
              keyboardType: keyboardType,
              fillColor: isDark
                  ? context.color.surface
                  : const Color(0xFFF5F9FE),
              style: context.bodyMedium?.copyWith(
                color: isDark ? Colors.white : Colors.black,
              ),
              filled: true,
              enabledBorderColor: widget.isEditing
                  ? context.theme.focusColor
                  : Colors.transparent,
            ),
            if (suffixIcon != null) Positioned(right: 0, child: suffixIcon),
          ],
        ),
        if (bottomWidget != null) bottomWidget,
      ],
    );
  }
}
