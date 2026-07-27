import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:cost_it_mobile/shared/appBar/costit_back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class FeedbackSuggestionsPage extends StatefulWidget {
  const FeedbackSuggestionsPage({super.key});

  @override
  State<FeedbackSuggestionsPage> createState() => _FeedbackSuggestionsPageState();
}

class _FeedbackSuggestionsPageState extends State<FeedbackSuggestionsPage> {
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController(text: '813 209 9450');
  String? _selectedIssue;

  @override
  void dispose() {
    _descCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: const CostItBackAppBar(title: 'Feedback and Suggestions'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSupportBanner(),
            Gap(24.h),
            _buildFormSection(
              title: 'Type of Issue',
              child: _buildDropdown(),
            ),
            Gap(16.h),
            _buildFormSection(
              title: 'Issue Description',
              child: _buildDescriptionField(),
            ),
            Gap(16.h),
            _buildFormSection(
              title: 'Upload Supporting Documents',
              subtitle: '(Optional)',
              child: _buildUploadArea(),
            ),
            Gap(16.h),
            _buildFormSection(
              title: 'Contact Phone Number',
              child: _buildPhoneField(context),
            ),
            Gap(32.h),
            SharedButton(
              text: 'Submit',
              onPressed: () {
                // submit logic
              },
              height: 55.h,
              color: const Color(0xFF00B074),
            ),
            Gap(32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportBanner() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundColor: const Color(0xFFE8F8F5),
          child: Icon(Icons.support_agent, color: const Color(0xFF00B074), size: 28.w),
        ),
        Gap(12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.r),
                topRight: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              "Don't worry, let us know your issue, and our dedicated team will contact you to help resolve it.",
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection({required String title, String? subtitle, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              if (subtitle != null) ...[
                Gap(4.w),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ],
          ),
          Gap(12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedIssue,
          hint: Text(
            'Select Type of Issue',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
          items: ['Bug Report', 'Feature Request', 'Payment Issue', 'Other']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            setState(() => _selectedIssue = val);
          },
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TextField(
            controller: _descCtrl,
            maxLines: 5,
            maxLength: 500,
            onChanged: (val) => setState(() {}),
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.w),
              hintText: 'Please briefly describe your problem so our support team can understand it in advance and provide assistance.',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
          ),
        ),
        Gap(4.h),
        Text(
          '${_descCtrl.text.length}/500',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // pick image
              },
              child: Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Icon(Icons.add, color: Colors.grey.shade400, size: 28.w),
                ),
              ),
            ),
          ],
        ),
        Text(
          '0/3',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Text('🇳🇬', style: TextStyle(fontSize: 18.sp)),
                Gap(8.w),
                Text(
                  '+234',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 24.h,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
