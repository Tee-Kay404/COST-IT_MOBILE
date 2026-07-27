import 'dart:io';
import 'package:cost_it_mobile/app/global/utils/exception.dart';
import 'package:cost_it_mobile/app/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoService {
  final Dio _dio;
  final ImagePicker _picker = ImagePicker();

  ProfilePhotoService({required Dio dio}) : _dio = dio;

  Future<String?> pickAndUpload({
    ImageSource source = ImageSource.gallery,
    void Function(double progress)? onProgress,
  }) async {
    debugPrint('[ProfilePhoto] Opening ${source == ImageSource.camera ? "camera" : "gallery"}');

    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (picked == null) {
      debugPrint('[ProfilePhoto] User cancelled picker');
      return null;
    }

    final file = File(picked.path);
    final fileName = picked.path.split('/').last;
    final sizeKb = (file.lengthSync() / 1024).toStringAsFixed(1);
    debugPrint('[ProfilePhoto] Picked: $fileName (${sizeKb}KB)');

    return _upload(file, fileName, onProgress: onProgress);
  }

  Future<String> _upload(
    File file,
    String fileName, {
    void Function(double progress)? onProgress,
  }) async {
    debugPrint('[ProfilePhoto] Starting upload: $fileName');

    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: DioMediaType.parse(_mimeTypeFromPath(file.path)),
      ),
    });

    try {
      final response = await _dio.patch(
        'user/profile-photo',
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0) {
            final progress = sent / total;
            debugPrint('[ProfilePhoto] Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
            onProgress?.call(progress);
          }
        },
      );

      final data = response.data as Map<String, dynamic>;
      final photoUrl = data['photoUrl'] as String;

      debugPrint('[ProfilePhoto] Upload complete → $photoUrl');
      return photoUrl;
    } on DioException catch (e) {
      final err = e.error;
      debugPrint(
        '[ProfilePhoto] DioException: ${err is GlobalException ? err.message : e.message}',
      );
      if (err is GlobalException) throw err;

      throw GlobalException(
        type: ErrorType.unknown,
        message: 'Upload failed. Please try again.',
      );
    } catch (e, stack) {
      debugPrint('[ProfilePhoto] Unexpected error: $e');
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
      case 'heic':
        return 'image/heic';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}

final profilePhotoServiceProvider = Provider<ProfilePhotoService>((ref) {
  return ProfilePhotoService(dio: ref.watch(rawDioProvider));
});