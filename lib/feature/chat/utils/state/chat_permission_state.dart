import 'package:permission_handler/permission_handler.dart';
import '../permission/chat_permission.dart';

class ChatPermissionState {
  final Map<ChatPermission, PermissionStatus> statuses;
  final bool hasRequestedOnce;

  const ChatPermissionState({
    this.statuses = const {},
    this.hasRequestedOnce = false,
  });

  bool get allGranted =>
      ChatPermission.values.every((p) => statuses[p]?.isGranted == true);

  bool get notificationsGranted =>
      statuses[ChatPermission.notifications]?.isGranted == true;

  /// Returns permissions that are denied or not yet determined
  List<ChatPermission> get missing => ChatPermission.values
      .where((p) => statuses[p]?.isGranted != true)
      .toList();

  ChatPermissionState copyWith({
    Map<ChatPermission, PermissionStatus>? statuses,
    bool? hasRequestedOnce,
  }) {
    return ChatPermissionState(
      statuses: statuses ?? this.statuses,
      hasRequestedOnce: hasRequestedOnce ?? this.hasRequestedOnce,
    );
  }
}
