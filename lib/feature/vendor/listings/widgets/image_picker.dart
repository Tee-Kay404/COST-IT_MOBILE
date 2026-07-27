import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/vendor/listings/models/photo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoPickerGrid extends StatelessWidget {
  final List<PhotoItem> photos;
  final int maxPhotos;
  final int minRequired;
  final VoidCallback onAddPhoto;
  final void Function(int index) onRemove;
  final void Function(int index) onRetry;
  final void Function(int oldIndex, int newIndex) onReorder;

  const PhotoPickerGrid({
    super.key,
    required this.photos,
    required this.onAddPhoto,
    required this.onRemove,
    required this.onRetry,
    required this.onReorder,
    this.maxPhotos = 5,
    this.minRequired = 2,
  });

  @override
  Widget build(BuildContext context) {
    final slotSize = 88.w;
    final photoCount = photos.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Photos',
              style: context.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: photoCount >= minRequired
                    ? context.color.primary.withValues(alpha: 0.12)
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '$photoCount/$maxPhotos · min $minRequired',
                style: context.bodySmall?.copyWith(
                  fontSize: 10.sp,
                  color: photoCount >= minRequired
                      ? context.color.primary
                      : Colors.orange.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ReorderableWrap(
          photos: photos,
          slotSize: slotSize,
          maxPhotos: maxPhotos,
          onAddPhoto: onAddPhoto,
          onRemove: onRemove,
          onRetry: onRetry,
          onReorder: onReorder,
        ),
        SizedBox(height: 8.h),
        Text(
          'First photo will be the cover image. Hold & drag to reorder.',
          style: context.bodySmall?.copyWith(
            fontSize: 11.sp,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class ReorderableWrap extends StatelessWidget {
  final List<PhotoItem> photos;
  final double slotSize;
  final int maxPhotos;
  final VoidCallback onAddPhoto;
  final void Function(int) onRemove;
  final void Function(int) onRetry;
  final void Function(int, int) onReorder;

  const ReorderableWrap({
    super.key,
    required this.photos,
    required this.slotSize,
    required this.maxPhotos,
    required this.onAddPhoto,
    required this.onRemove,
    required this.onRetry,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        ...photos.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return _PhotoSlot(
            key: ValueKey(item.file?.path ?? item.url ?? i.toString()),
            item: item,
            index: i,
            size: slotSize,
            isCover: i == 0,
            onRemove: () => onRemove(i),
            onRetry: () => onRetry(i),
          );
        }),
        if (photos.length < maxPhotos)
          _AddSlot(size: slotSize, onTap: onAddPhoto),
      ],
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  final PhotoItem item;
  final int index;
  final double size;
  final bool isCover;
  final VoidCallback onRemove;
  final VoidCallback onRetry;

  const _PhotoSlot({
    super.key,
    required this.item,
    required this.index,
    required this.size,
    required this.isCover,
    required this.onRemove,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: item.isRemote && item.url != null
                ? Image.network(item.url!, fit: BoxFit.cover)
                : Image.file(item.file!, fit: BoxFit.cover),
          ),

          if (item.isUploading || item.isFailed)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),

          if (item.isUploading)
            Center(
              child: SizedBox(
                width: 26.w,
                height: 26.w,
                child: CircularProgressIndicator(
                  value: item.progress > 0 ? item.progress : null,
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ),
            ),

          if (item.isFailed)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.r),
                  onTap: onRetry,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded, color: Colors.white, size: 20.sp),
                        SizedBox(height: 2.h),
                        Text(
                          'Tap to retry',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          if (isCover && item.isSuccess)
            Positioned(
              bottom: 4.h,
              left: 4.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: context.color.secondary,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Cover',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

          Positioned(
            top: 4.h,
            right: 4.w,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddSlot extends StatelessWidget {
  final double size;
  final VoidCallback onTap;

  const _AddSlot({required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.color.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: context.color.onPrimary.withValues(alpha: 0.35),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 26.sp,
              color: context.color.onPrimary,
            ),
            SizedBox(height: 4.h),
            Text(
              'Add photo',
              style: context.bodySmall?.copyWith(
                fontSize: 10.sp,
                color: context.color.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}