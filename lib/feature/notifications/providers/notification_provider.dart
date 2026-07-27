import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../models/notification_dummy_data.dart';

class NotificationState {
  final List<NotificationItem> notifications;
  final bool isLoading;
  final bool isSelectMode;
  final Set<String> selectedIds;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.isSelectMode = false,
    this.selectedIds = const {},
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;
  bool get hasUnread => unreadCount > 0;

  List<NotificationItem> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  List<NotificationItem> get readNotifications =>
      notifications.where((n) => n.isRead).toList();

  bool get allSelected =>
      notifications.isNotEmpty &&
      selectedIds.length == notifications.length;

  NotificationState copyWith({
    List<NotificationItem>? notifications,
    bool? isLoading,
    bool? isSelectMode,
    Set<String>? selectedIds,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      isSelectMode: isSelectMode ?? this.isSelectMode,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(const NotificationState()) {
    _loadNotifications();
  }

  void _loadNotifications() {
    state = state.copyWith(isLoading: true);
    // TODO: Replace with API call
    state = state.copyWith(
      notifications: List.from(dummyNotifications),
      isLoading: false,
    );
  }

  void markAsRead(String id) {
    final updated = state.notifications.map((n) {
      if (n.id == id) return n.copyWith(isRead: true);
      return n;
    }).toList();
    state = state.copyWith(notifications: updated);
  }

  void markAllAsRead() {
    final updated = state.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    state = state.copyWith(notifications: updated);
  }

  void markAllAsUnread() {
    final updated = state.notifications
        .map((n) => n.copyWith(isRead: false))
        .toList();
    state = state.copyWith(notifications: updated);
  }

  void deleteNotification(String id) {
    final updated =
        state.notifications.where((n) => n.id != id).toList();
    state = state.copyWith(notifications: updated);
  }

  void clearAll() {
    state = state.copyWith(notifications: []);
  }

  // ── Selection mode ──

  void enterSelectMode() {
    state = state.copyWith(isSelectMode: true, selectedIds: {});
  }

  void exitSelectMode() {
    state = state.copyWith(isSelectMode: false, selectedIds: {});
  }

  void toggleSelection(String id) {
    final updated = Set<String>.from(state.selectedIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = state.copyWith(selectedIds: updated);
  }

  void selectAll() {
    final allIds = state.notifications.map((n) => n.id).toSet();
    state = state.copyWith(selectedIds: allIds);
  }

  void clearSelection() {
    state = state.copyWith(selectedIds: {});
  }

  void deleteSelected() {
    final updated = state.notifications
        .where((n) => !state.selectedIds.contains(n.id))
        .toList();
    state = state.copyWith(
      notifications: updated,
      selectedIds: {},
      isSelectMode: false,
    );
  }

  void markSelectedAsRead() {
    final updated = state.notifications.map((n) {
      if (state.selectedIds.contains(n.id)) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    state = state.copyWith(
      notifications: updated,
      selectedIds: {},
      isSelectMode: false,
    );
  }

  void markSelectedAsUnread() {
    final updated = state.notifications.map((n) {
      if (state.selectedIds.contains(n.id)) {
        return n.copyWith(isRead: false);
      }
      return n;
    }).toList();
    state = state.copyWith(
      notifications: updated,
      selectedIds: {},
      isSelectMode: false,
    );
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
  (_) => NotificationNotifier(),
);
