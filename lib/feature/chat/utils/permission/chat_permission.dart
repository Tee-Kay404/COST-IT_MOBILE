import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

enum ChatPermission {
  notifications,
  camera,
  gallery,
  microphone,
  contacts,
}

extension ChatPermissionX on ChatPermission {
  Permission get handler {
    switch (this) {
      case ChatPermission.notifications:
        return Permission.notification;
      case ChatPermission.camera:
        return Permission.camera;
      case ChatPermission.gallery:
        return Permission.photos; // iOS; Android uses storage / mediaImages
      case ChatPermission.microphone:
        return Permission.microphone;
      case ChatPermission.contacts:
        return Permission.contacts;
    }
  }

  String get label {
    switch (this) {
      case ChatPermission.notifications:
        return 'Notifications';
      case ChatPermission.camera:
        return 'Camera';
      case ChatPermission.gallery:
        return 'Photo Library';
      case ChatPermission.microphone:
        return 'Microphone';
      case ChatPermission.contacts:
        return 'Contacts';
    }
  }

  String get rationale {
    switch (this) {
      case ChatPermission.notifications:
        return 'So you never miss a reply from a vendor or contact.';
      case ChatPermission.camera:
        return 'To take and send photos of materials or job sites.';
      case ChatPermission.gallery:
        return 'To share product images and photos from your library.';
      case ChatPermission.microphone:
        return 'To record and send voice notes.';
      case ChatPermission.contacts:
        return 'To invite friends and colleagues to Cost-It.';
    }
  }

  IconData get icon {
    switch (this) {
      case ChatPermission.notifications:
        return Icons.notifications_outlined;
      case ChatPermission.camera:
        return Icons.camera_alt_outlined;
      case ChatPermission.gallery:
        return Icons.photo_library_outlined;
      case ChatPermission.microphone:
        return Icons.mic_outlined;
      case ChatPermission.contacts:
        return Icons.contacts_outlined;
    }
  }
}
