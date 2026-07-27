import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/permission/chat_permission.dart';
import '../utils/state/chat_permission_state.dart';

class ChatPermissionNotifier extends StateNotifier<ChatPermissionState> {
  ChatPermissionNotifier() : super(const ChatPermissionState());

  Future<void> checkStatuses() async {
    final Map<ChatPermission, PermissionStatus> map = {};
    for (final p in ChatPermission.values) {
      map[p] = await p.handler.status;
    }
    state = state.copyWith(statuses: map);
  }

  Future<void> requestAll() async {
    final Map<Permission, PermissionStatus> results = await [
      Permission.notification,
      Permission.camera,
      Permission.photos,
      Permission.microphone,
      Permission.contacts,
    ].request();

    final Map<ChatPermission, PermissionStatus> map = {
      ChatPermission.notifications:
          results[Permission.notification] ?? PermissionStatus.denied,
      ChatPermission.camera:
          results[Permission.camera] ?? PermissionStatus.denied,
      ChatPermission.gallery:
          results[Permission.photos] ?? PermissionStatus.denied,
      ChatPermission.microphone:
          results[Permission.microphone] ?? PermissionStatus.denied,
      ChatPermission.contacts:
          results[Permission.contacts] ?? PermissionStatus.denied,
    };

    state = state.copyWith(statuses: map, hasRequestedOnce: true);
  }

  Future<PermissionStatus> requestSingle(ChatPermission permission) async {
    final status = await permission.handler.request();
    final updated = Map<ChatPermission, PermissionStatus>.from(state.statuses);
    updated[permission] = status;
    state = state.copyWith(statuses: updated);
    return status;
  }

  Future<void> openSettings() => openAppSettings();
}

final chatPermissionProvider =
    StateNotifierProvider<ChatPermissionNotifier, ChatPermissionState>(
  (ref) => ChatPermissionNotifier(),
);
