import 'dart:io';

enum PhotoUploadStatus { pending, uploading, success, failed }

class PhotoItem {
  /// Local file — null for photos loaded from an existing product URL.
  final File? file;
  final PhotoUploadStatus status;
  final String? url;
  final String? errorReason;
  final double progress;

  const PhotoItem({
    this.file,
    this.status = PhotoUploadStatus.pending,
    this.url,
    this.errorReason,
    this.progress = 0.0,
  });

  /// Creates a PhotoItem from an already-uploaded URL (e.g. when editing
  /// an existing product). No local file is needed — it's already on the CDN.
  factory PhotoItem.fromUrl(String url) => PhotoItem(
        file: null,
        status: PhotoUploadStatus.success,
        url: url,
        progress: 1.0,
      );

  bool get isPending => status == PhotoUploadStatus.pending;
  bool get isUploading => status == PhotoUploadStatus.uploading;
  bool get isSuccess => status == PhotoUploadStatus.success;
  bool get isFailed => status == PhotoUploadStatus.failed;

  /// True when this item has no local file and was loaded from a remote URL.
  bool get isRemote => file == null && url != null;

  PhotoItem copyWith({
    PhotoUploadStatus? status,
    String? url,
    String? errorReason,
    double? progress,
    bool clearError = false,
  }) {
    return PhotoItem(
      file: file,
      status: status ?? this.status,
      url: url ?? this.url,
      errorReason: clearError ? null : (errorReason ?? this.errorReason),
      progress: progress ?? this.progress,
    );
  }
}