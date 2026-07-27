import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/vendor/listings/models/sell_form_state.dart';
import 'package:cost_it_mobile/feature/vendor/listings/providers/sell_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../models/sell.dart';

class ImageSection extends StatelessWidget {
  final SellFormState state;
  final SellFormNotifier notifier;
  final VoidCallback onAddPhoto;
  final String? photoError;
  final bool collapsed;

  const ImageSection({
    super.key,
    required this.state,
    required this.notifier,
    required this.onAddPhoto,
    this.photoError,
    this.collapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormSectionHeader(
            title: 'Photos',
            subtitle: 'Clear photos get 3× more enquiries',
            icon: Icons.photo_library_outlined,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeInOutCubic,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: collapsed ? 0.0 : 1.0,
              child: collapsed
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PhotoPickerGrid(
                            photos: state.photos,
                            minRequired: 2,
                            maxPhotos: 5,
                            onAddPhoto: onAddPhoto,
                            onRemove: notifier.removePhoto,
                            onRetry: notifier.retryPhoto,
                            onReorder: notifier.reorderPhotos,
                          ),
                          if (photoError != null) ...[
                            Gap(6.h),
                            Text(
                              photoError!,
                              style: context.bodySmall?.copyWith(
                                fontSize: 11.sp,
                                color: context.color.error,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
