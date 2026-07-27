import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class UploadOverlay extends StatelessWidget {
  final bool isUploading;
  final double uploadProgress;

  const UploadOverlay({
    super.key,
    required this.isUploading,
    required this.uploadProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            width: 280.w,
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 28.h,
            ),
            decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 36.sp,
                  color: context.color.primary,
                ),
                Gap(12.h),
                Text(
                  isUploading ? 'Uploading photos...' : 'Publishing listing...',
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.color.onPrimary,
                  ),
                ),
                Gap(16.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: isUploading ? uploadProgress : null,
                    minHeight: 8.h,
                    backgroundColor: context.color.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.color.primary,
                    ),
                  ),
                ),
                Gap(10.h),
                if (isUploading)
                  Text(
                    '${(uploadProgress * 100).toStringAsFixed(0)}%',
                    style: context.bodySmall?.copyWith(
                      color: context.color.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
