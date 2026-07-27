import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

// ─── State ────────────────────────────────────────────────────────────────────

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

// ─── Notifier ─────────────────────────────────────────────────────────────────

class ChatPermissionNotifier extends StateNotifier<ChatPermissionState> {
  ChatPermissionNotifier() : super(const ChatPermissionState());

  /// Check current permission statuses without requesting
  Future<void> checkStatuses() async {
    final Map<ChatPermission, PermissionStatus> map = {};
    for (final p in ChatPermission.values) {
      map[p] = await p.handler.status;
    }
    state = state.copyWith(statuses: map);
  }

  /// Request all missing permissions sequentially with rationale shown first
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

  /// Request a single permission (e.g. on first use of camera in chat)
  Future<PermissionStatus> requestSingle(ChatPermission permission) async {
    final status = await permission.handler.request();
    final updated = Map<ChatPermission, PermissionStatus>.from(state.statuses);
    updated[permission] = status;
    state = state.copyWith(statuses: updated);
    return status;
  }

  /// Open app settings for permanently denied permissions
  Future<void> openSettings() => openAppSettings();
}

final chatPermissionProvider =
    StateNotifierProvider<ChatPermissionNotifier, ChatPermissionState>(
  (ref) => ChatPermissionNotifier(),
);

// ─── Permission Gate Widget ───────────────────────────────────────────────────

/// Shows a full-screen permission rationale before requesting.
/// Place this as an interstitial before entering the chat list for the first time.
class ChatPermissionGate extends ConsumerStatefulWidget {
  final Widget child;

  const ChatPermissionGate({super.key, required this.child});

  @override
  ConsumerState<ChatPermissionGate> createState() => _ChatPermissionGateState();
}

class _ChatPermissionGateState extends ConsumerState<ChatPermissionGate> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(chatPermissionProvider.notifier).checkStatuses();
      setState(() => _checked = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final permState = ref.watch(chatPermissionProvider);

    // If all granted OR already asked once → let them through
    if (permState.allGranted || permState.hasRequestedOnce) {
      return widget.child;
    }

    return _PermissionRationaleScreen(
      onAllow: () async {
        await ref.read(chatPermissionProvider.notifier).requestAll();
      },
    );
  }
}

// ─── Rationale Screen ─────────────────────────────────────────────────────────

class _PermissionRationaleScreen extends StatelessWidget {
  final VoidCallback onAllow;

  const _PermissionRationaleScreen({required this.onAllow});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: color.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Before you start\nchatting',
                style: context.titleLarge?.copyWith(
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Cost-It needs a few permissions to give you a full messaging experience.',
                style: context.bodyLarge?.copyWith(
                  color: color.onSurface.withOpacity(0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),
              // Permission list
              ...ChatPermission.values.map(
                (p) => _PermissionRow(permission: p),
              ),
              const Spacer(),
              // CTA
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onAllow,
                  child: const Text('Allow & Continue'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Mark as asked so they can proceed with limited functionality
                    // The notifier will handle this via hasRequestedOnce
                    onAllow();
                  },
                  child: const Text('Skip for now'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  final ChatPermission permission;

  const _PermissionRow({required this.permission});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: context.color.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(permission.icon, color: context.color.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  permission.label,
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  permission.rationale,
                  style: context.bodySmall?.copyWith(
                    color: context.color.onSurface.withOpacity(0.55),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}