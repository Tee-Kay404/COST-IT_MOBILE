import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/notifications/providers/notification_provider.dart';
import 'package:cost_it_mobile/feature/notifications/views/notification_detail_page.dart';
import 'package:cost_it_mobile/feature/notifications/widgets/notification_card.dart';
import 'package:cost_it_mobile/feature/notifications/widgets/notification_empty_state.dart';
import 'package:cost_it_mobile/shared/appBar/costit_back_app_bar.dart';
import 'package:cost_it_mobile/widgets/app_bar_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:cost_it_mobile/feature/notifications/models/notification_model.dart';

enum _NotificationOverflowAction { readAll, markAllUnread, select, clearAll }

enum _SelectOverflowAction {
  markRead,
  markUnread,
  delete,
  selectAll,
  deselectAll,
}

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);
    final notifier = ref.read(notificationProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.color.surface,
      appBar: state.isSelectMode
          ? _buildSelectAppBar(context, state, notifier)
          : _buildNormalAppBar(context, state, notifier),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.notifications.isEmpty
          ? const NotificationEmptyState()
          : _NotificationList(state: state, notifier: notifier, isDark: isDark),
    );
  }

  // ── Normal app bar with three-dot menu ──
  PreferredSizeWidget _buildNormalAppBar(
    BuildContext context,
    NotificationState state,
    NotificationNotifier notifier,
  ) {
    return CostItBackAppBar(
      title: 'Notifications',
      actions: [
        if (state.notifications.isNotEmpty)
          AppBarPopupMenu<_NotificationOverflowAction>(
            itemBuilder: (_) => [
              _buildMenuItem(
                context,
                value: _NotificationOverflowAction.readAll,
                icon: Icons.done_all_rounded,
                label: 'Read All',
                enabled: state.hasUnread,
              ),
              _buildMenuItem(
                context,
                value: _NotificationOverflowAction.markAllUnread,
                icon: Icons.markunread_rounded,
                label: 'Mark All as Unread',
                enabled: state.readNotifications.isNotEmpty,
              ),
              const PopupMenuDivider(),
              _buildMenuItem(
                context,
                value: _NotificationOverflowAction.select,
                icon: Icons.check_circle_outline_rounded,
                label: 'Select',
              ),
              _buildMenuItem(
                context,
                value: _NotificationOverflowAction.clearAll,
                icon: Icons.delete_sweep_outlined,
                label: 'Clear All',
                isDestructive: true,
              ),
            ],
            onSelected: (action) =>
                _handleNormalAction(context, action, notifier),
          ),
        SizedBox(width: 8.w),
      ],
    );
  }

  // ── Selection mode app bar ──
  PreferredSizeWidget _buildSelectAppBar(
    BuildContext context,
    NotificationState state,
    NotificationNotifier notifier,
  ) {
    final count = state.selectedIds.length;

    return CostItBackAppBar(
      showBackButton: false,
      leading: IconButton(
        onPressed: () => notifier.exitSelectMode(),
        icon: Icon(Icons.close_rounded, color: CostItColors.white, size: 24.sp),
      ),
      title: '$count selected',
      actions: [
        AppBarPopupMenu<_SelectOverflowAction>(
          itemBuilder: (_) => [
            _buildSelectMenuItem(
              context,
              value: _SelectOverflowAction.markRead,
              icon: Icons.done_all_rounded,
              label: 'Mark as Read',
              enabled: count > 0,
            ),
            _buildSelectMenuItem(
              context,
              value: _SelectOverflowAction.markUnread,
              icon: Icons.markunread_rounded,
              label: 'Mark as Unread',
              enabled: count > 0,
            ),
            const PopupMenuDivider(),
            _buildSelectMenuItem(
              context,
              value: state.allSelected
                  ? _SelectOverflowAction.deselectAll
                  : _SelectOverflowAction.selectAll,
              icon: state.allSelected
                  ? Icons.deselect_rounded
                  : Icons.select_all_rounded,
              label: state.allSelected ? 'Deselect All' : 'Select All',
            ),
            _buildSelectMenuItem(
              context,
              value: _SelectOverflowAction.delete,
              icon: Icons.delete_outline_rounded,
              label: 'Delete Selected',
              isDestructive: true,
              enabled: count > 0,
            ),
          ],
          onSelected: (action) =>
              _handleSelectAction(context, action, notifier),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  // ── Menu item builders ──

  PopupMenuItem<_NotificationOverflowAction> _buildMenuItem(
    BuildContext context, {
    required _NotificationOverflowAction value,
    required IconData icon,
    required String label,
    bool isDestructive = false,
    bool enabled = true,
  }) {
    final color = isDestructive
        ? CostItColors.error
        : enabled
        ? context.color.inverseSurface
        : context.color.inverseSurface.withValues(alpha: 0.35);

    return PopupMenuItem<_NotificationOverflowAction>(
      value: value,
      enabled: enabled,
      height: 44.h,
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: color),
          SizedBox(width: 10.w),
          Text(
            label,
            style: context.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<_SelectOverflowAction> _buildSelectMenuItem(
    BuildContext context, {
    required _SelectOverflowAction value,
    required IconData icon,
    required String label,
    bool isDestructive = false,
    bool enabled = true,
  }) {
    final color = isDestructive
        ? (enabled
              ? CostItColors.error
              : CostItColors.error.withValues(alpha: 0.35))
        : enabled
        ? context.color.inverseSurface
        : context.color.inverseSurface.withValues(alpha: 0.35);

    return PopupMenuItem<_SelectOverflowAction>(
      value: value,
      enabled: enabled,
      height: 44.h,
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: color),
          SizedBox(width: 10.w),
          Text(
            label,
            style: context.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Action handlers ──

  void _handleNormalAction(
    BuildContext context,
    _NotificationOverflowAction action,
    NotificationNotifier notifier,
  ) {
    switch (action) {
      case _NotificationOverflowAction.readAll:
        notifier.markAllAsRead();
        break;
      case _NotificationOverflowAction.markAllUnread:
        notifier.markAllAsUnread();
        break;
      case _NotificationOverflowAction.select:
        notifier.enterSelectMode();
        break;
      case _NotificationOverflowAction.clearAll:
        _showClearAllSheet(context, notifier);
        break;
    }
  }

  void _handleSelectAction(
    BuildContext context,
    _SelectOverflowAction action,
    NotificationNotifier notifier,
  ) {
    switch (action) {
      case _SelectOverflowAction.markRead:
        notifier.markSelectedAsRead();
        break;
      case _SelectOverflowAction.markUnread:
        notifier.markSelectedAsUnread();
        break;
      case _SelectOverflowAction.selectAll:
        notifier.selectAll();
        break;
      case _SelectOverflowAction.deselectAll:
        notifier.clearSelection();
        break;
      case _SelectOverflowAction.delete:
        notifier.deleteSelected();
        break;
    }
  }

  void _showClearAllSheet(BuildContext context, NotificationNotifier notifier) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.color.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? CostItColors.brightGrey.shade800
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Gap(20.h),
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: CostItColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_off_outlined,
                  size: 32.sp,
                  color: CostItColors.error,
                ),
              ),
              Gap(16.h),
              Text(
                'Clear all notifications?',
                style: context.titleMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: context.color.inverseSurface,
                ),
              ),
              Gap(8.h),
              Text(
                'All your notifications will be permanently removed. This cannot be undone.',
                textAlign: TextAlign.center,
                style: context.bodySmall?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? CostItColors.brightGrey.shade400
                      : Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              Gap(28.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    notifier.clearAll();
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CostItColors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Yes, clear all',
                    style: context.bodyMedium?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Gap(10.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? CostItColors.brightGrey.shade800
                        : CostItColors.brightGrey.shade200,
                    foregroundColor: context.color.inverseSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Cancel',
                    style: context.bodyMedium?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: context.color.inverseSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  final NotificationState state;
  final NotificationNotifier notifier;
  final bool isDark;

  const _NotificationList({
    required this.state,
    required this.notifier,
    required this.isDark,
  });

  void _openDetail(BuildContext context, NotificationItem n) {
    // Mark as read when opening
    if (!n.isRead) notifier.markAsRead(n.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailPage(notification: n),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unread = state.unreadNotifications;
    final read = state.readNotifications;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      children: [
        // Unread section
        if (unread.isNotEmpty) ...[
          _SectionLabel(label: 'New', count: unread.length, isDark: isDark),
          Gap(8.h),
          ...unread.map(
            (n) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: NotificationCard(
                notification: n,
                onTap: () => _openDetail(context, n),
                onDismiss: () => notifier.deleteNotification(n.id),
                isSelectMode: state.isSelectMode,
                isSelected: state.selectedIds.contains(n.id),
                onToggleSelect: () => notifier.toggleSelection(n.id),
              ),
            ),
          ),
          Gap(16.h),
        ],

        // Read section
        if (read.isNotEmpty) ...[
          _SectionLabel(label: 'Earlier', count: read.length, isDark: isDark),
          Gap(8.h),
          ...read.map(
            (n) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: NotificationCard(
                notification: n,
                onTap: () => _openDetail(context, n),
                onDismiss: () => notifier.deleteNotification(n.id),
                isSelectMode: state.isSelectMode,
                isSelected: state.selectedIds.contains(n.id),
                onToggleSelect: () => notifier.toggleSelection(n.id),
              ),
            ),
          ),
        ],

        Gap(80.h),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final int count;
  final bool isDark;

  const _SectionLabel({
    required this.label,
    required this.count,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: context.bodySmall?.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: isDark
                ? context.color.secondary.withValues(alpha: 0.15)
                : context.color.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? context.color.secondary : context.color.primary,
            ),
          ),
        ),
      ],
    );
  }
}
