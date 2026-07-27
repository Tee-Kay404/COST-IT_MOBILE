import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/chat/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatListTile extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;

  const ChatListTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final hasUnread = conversation.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Avatar
            _ConversationAvatar(conversation: conversation),
            SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.displayName,
                          style: context.bodyMedium?.copyWith(
                            fontWeight: hasUnread
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Timestamp
                      if (conversation.lastMessage != null)
                        Text(
                          _formatTime(conversation.lastMessage!.timestamp),
                          style: context.text.labelSmall?.copyWith(
                            color: hasUnread
                                ? color.primary
                                : color.onSurface.withOpacity(0.45),
                            fontWeight: hasUnread
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      // Product chip
                      if (conversation.type == ConversationType.vendorInquiry &&
                          conversation.productTitle != null) ...[
                        _ProductChip(title: conversation.productTitle!),
                        SizedBox(width: 6.w),
                      ],
                      // Last message preview
                      Expanded(
                        child: Text(
                          _lastMessagePreview(conversation),
                          style: context.bodySmall?.copyWith(
                            color: hasUnread
                                ? color.onSurface.withOpacity(0.75)
                                : color.onSurface.withOpacity(0.45),
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Unread badge
                      if (hasUnread) ...[
                        SizedBox(width: 8.w),
                        _UnreadBadge(count: conversation.unreadCount),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _lastMessagePreview(ChatConversation c) {
    final msg = c.lastMessage;
    if (msg == null) return 'No messages yet';
    switch (msg.type) {
      case MessageType.image:
        return '📷 Photo';
      case MessageType.audio:
        return '🎤 Voice note';
      case MessageType.productCard:
        return '📦 ${msg.productTitle ?? 'Product'}';
      case MessageType.text:
        return msg.content;
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dt.weekday - 1];
    }
    return '${dt.day}/${dt.month}';
  }
}

// ─── Avatar ───────────────────────────────────────────────────────────────────

class _ConversationAvatar extends StatelessWidget {
  final ChatConversation conversation;

  const _ConversationAvatar({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final avatarUrl = conversation.displayAvatarUrl;
    final isGroup = conversation.isGroupChat;
    final name = conversation.displayName;

    return Stack(
      children: [
        CircleAvatar(
          radius: 26.r,
          backgroundColor: color.primary.withOpacity(0.12),
          backgroundImage:
              avatarUrl != null ? NetworkImage(avatarUrl) : null,
          child: avatarUrl == null
              ? Text(
                  isGroup ? '👥' : (name.isNotEmpty ? name[0].toUpperCase() : '?'),
                  style: context.titleMedium?.copyWith(
                    fontSize: isGroup ? 18.sp : 16.sp,
                    fontWeight: FontWeight.w600,
                    color: color.primary,
                  ),
                )
              : null,
        ),

        // Conversation type indicator dot
        Positioned(
          bottom: 0,
          right: 0,
          child: _TypeIndicator(type: conversation.type),
        ),
      ],
    );
  }
}

class _TypeIndicator extends StatelessWidget {
  final ConversationType type;

  const _TypeIndicator({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = context.color;

    if (type == ConversationType.userToUser ||
        type == ConversationType.invitedContact) {
      return const SizedBox.shrink();
    }

    // Vendor inquiry → small store icon badge
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        color: color.secondary,
        shape: BoxShape.circle,
        border: Border.all(
            color: color.surface, width: 1.5),
      ),
      child: Icon(Icons.storefront_rounded, size: 10.r, color: Colors.white),
    );
  }
}

// ─── Product chip ─────────────────────────────────────────────────────────────

class _ProductChip extends StatelessWidget {
  final String title;

  const _ProductChip({required this.title});

  @override
  Widget build(BuildContext context) {
    final color = context.color;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        title,
        style: context.text.labelSmall?.copyWith(
          fontSize: 10.sp,
          color: color.primary,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ─── Unread badge ─────────────────────────────────────────────────────────────

class _UnreadBadge extends StatelessWidget {
  final int count;

  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final label = count > 99 ? '99+' : count.toString();

    return Container(
      constraints: BoxConstraints(minWidth: 20.r),
      height: 20.r,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: context.text.labelSmall?.copyWith(
          color: color.onPrimary,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}