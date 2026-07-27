import 'package:flutter/material.dart';

enum NotificationType {
  order,
  priceAlert,
  message,
  promotion,
  system,
}

extension NotificationTypeX on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.order:
        return 'Order';
      case NotificationType.priceAlert:
        return 'Price Alert';
      case NotificationType.message:
        return 'Message';
      case NotificationType.promotion:
        return 'Promotion';
      case NotificationType.system:
        return 'System';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.order:
        return Icons.receipt_long_outlined;
      case NotificationType.priceAlert:
        return Icons.trending_down_rounded;
      case NotificationType.message:
        return Icons.chat_bubble_outline_rounded;
      case NotificationType.promotion:
        return Icons.local_offer_outlined;
      case NotificationType.system:
        return Icons.info_outline_rounded;
    }
  }

  Color get tintColor {
    switch (this) {
      case NotificationType.order:
        return const Color(0xFF4CAF50);
      case NotificationType.priceAlert:
        return const Color(0xFFFF9800);
      case NotificationType.message:
        return const Color(0xFF2196F3);
      case NotificationType.promotion:
        return const Color(0xFFE91E63);
      case NotificationType.system:
        return const Color(0xFF9E9E9E);
    }
  }
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      type: type,
      title: title,
      body: body,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
