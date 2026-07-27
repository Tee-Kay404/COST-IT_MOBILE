import 'dart:io';
import 'package:cost_it_mobile/app/global/utils/exception.dart';
import 'package:cost_it_mobile/app/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A single file that uploaded successfully.
/// [index] is its position in the batch you sent — use it to match
/// results back to the original File list.
class UploadedImage {
  final int index;
  final String url;
  UploadedImage({required this.index, required this.url});

  factory UploadedImage.fromMap(Map<String, dynamic> map) {
    return UploadedImage(index: map['index'] as int, url: map['url'] as String);
  }
}

/// A single file that failed — with a reason safe to show the vendor
/// directly (it's server-written, not a raw exception string).
class FailedImageUpload {
  final int index;
  final String filename;
  final String reason;
  FailedImageUpload({
    required this.index,
    required this.filename,
    required this.reason,
  });

  factory FailedImageUpload.fromMap(Map<String, dynamic> map) {
    return FailedImageUpload(
      index: map['index'] as int,
      filename: map['filename'] as String,
      reason: map['reason'] as String,
    );
  }
}

/// Result of one upload batch. Files are independent — some can succeed
/// while others fail in the same call.
class ImageUploadBatchResult {
  final List<UploadedImage> succeeded;
  final List<FailedImageUpload> failed;
  ImageUploadBatchResult({required this.succeeded, required this.failed});

  bool get hasFailures => failed.isNotEmpty;
  bool get allSucceeded => failed.isEmpty;
}

class UploadValidationException implements Exception {
  final String message;
  UploadValidationException(this.message);

  @override
  String toString() => 'UploadValidationException: $message';
}

class ImageUploadService {
  final Dio _dio;

  ImageUploadService({required Dio dio}) : _dio = dio;

  /// Upload 1–5 files. Call this again with just the previously-failed
  /// files (see [FailedImageUpload.index]) to retry — a batch of 1 is
  /// valid. The "2–5 images per listing" rule is enforced separately,
  /// at product-creation time, not here.
  Future<ImageUploadBatchResult> uploadImages(
    List<File> files, {
    void Function(double progress)? onProgress,
  }) async {
    if (files.isEmpty || files.length > 5) {
      throw UploadValidationException(
        'You can upload between 1 and 5 photos at a time.',
      );
    }

    debugPrint('[ImageUpload] Starting upload of ${files.length} file(s)');
    final formData = FormData();
    for (final file in files) {
      final fileName = file.path.split(Platform.pathSeparator).last;
      debugPrint(
        '[ImageUpload] Adding file: $fileName (${(file.lengthSync() / 1024).toStringAsFixed(1)}KB)',
      );

      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: DioMediaType.parse(_mimeTypeFromPath(file.path)),
          ),
        ),
      );
    }

    try {
      final response = await _dio.post(
        'products/upload-images',
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0) {
            final progress = sent / total;
            final percent = (progress * 100).toInt();
            // \r moves cursor to start of line; \x1B[2K clears the line —
            // together they overwrite the same line instead of printing a new one.
            stdout.write('\r\x1B[2K[ImageUpload] in Progress: $percent%');
            if (sent == total) {
              stdout.write('\n'); // move to next line only when fully done
            }
            onProgress?.call(progress);
          }
        },
      );

      final data = response.data as Map<String, dynamic>;
      final succeeded = (data['succeeded'] as List<dynamic>)
          .map((e) => UploadedImage.fromMap(e as Map<String, dynamic>))
          .toList();
      final failed = (data['failed'] as List<dynamic>)
          .map((e) => FailedImageUpload.fromMap(e as Map<String, dynamic>))
          .toList();

      debugPrint(
        '[ImageUpload] Batch complete → succeeded=${succeeded.length}, failed=${failed.length}',
      );

      return ImageUploadBatchResult(succeeded: succeeded, failed: failed);
    } on DioException catch (e) {
      // Request-level failure (network down, 401, server error) — distinct
      // from a per-file failure, which comes back as a normal 200 above.
      final err = e.error;
      debugPrint(
        '[ImageUpload] DioException: ${err is GlobalException ? err.message : e.message}',
      );
      if (err is GlobalException) throw err;

      throw GlobalException(
        type: ErrorType.unknown,
        message: 'Upload failed. Please try again.',
      );
    } catch (e, stack) {
      debugPrint('[ImageUpload] Unexpected error: $e');
      debugPrint('$stack');
      throw GlobalException(
        type: ErrorType.unknown,
        message: 'Something went wrong while uploading. Please try again.',
      );
    }
  }

  String _mimeTypeFromPath(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }
}

final imageUploadServiceProvider = Provider<ImageUploadService>((ref) {
  return ImageUploadService(dio: ref.watch(rawDioProvider));
});
