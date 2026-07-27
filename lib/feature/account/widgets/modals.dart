import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';

final List<Map<String, dynamic>> changePhotoOptions = [
  {
    'id': 'gallery',
    'title': 'Choose from Gallery',
    'icon': Icons.photo_library_outlined,
  },
  {
    'id': 'camera',
    'title': 'Take a Photo',
    'icon': Icons.camera_alt_outlined,
  },
];

final List<Map<String, dynamic>> viewOrEditPhotoOptions = [
  {
    'id': 'view',
    'title': 'View Photo',
    'icon': Icons.fullscreen_rounded,
  },
  {
    'id': 'edit',
    'title': 'Change Profile Photo',
    'icon': Icons.edit_outlined,
  },
];

class ModalOptionsSheet extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> options;

  const ModalOptionsSheet({
    super.key,
    required this.title,
    required this.options,
  });

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required List<Map<String, dynamic>> options,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => ModalOptionsSheet(title: title, options: options),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Text(
              title,
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap(12.h),
            ...options.map((option) {
              return ListTile(
                leading: Icon(
                  option['icon'] as IconData,
                  size: 24.sp,
                  color: CostItColors.brightGrey.shade500,
                ),
                title: Text(
                  option['title'] as String,
                  style: context.bodySmall,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: CostItColors.brightGrey.shade500,
                ),
                onTap: () => Navigator.pop(context, option['id'] as String),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
