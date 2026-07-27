import 'package:flutter/foundation.dart';

enum ConversationType {
  vendorInquiry, 
  userToUser, 
  invitedContact,
}


enum InviteStatus {
  pending, 
  joined, 
  onApp
}

@immutable
class ChatContact {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? phoneNumber;
  final bool isOnApp;
  final InviteStatus inviteStatus;

  const ChatContact({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.phoneNumber,
    required this.isOnApp,
    this.inviteStatus = InviteStatus.onApp,
  });
}

enum MessageType { text, image, audio, productCard }

enum MessageStatus { sending, sent, delivered, read, failed }

@immutable
class ChatMessage {
  final String id;
  final String senderId;
  final String content; 
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final String? mediaUrl;  
  final String? productId; 
  final String? productTitle;
  final String? productImageUrl;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    required this.timestamp,
    this.mediaUrl,
    this.productId,
    this.productTitle,
    this.productImageUrl,
  });
}

@immutable
class ChatConversation {
  final String id;
  final ConversationType type;
  final List<ChatContact> participants; 
  final ChatMessage? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;

  final String? productId;
  final String? productTitle;
  final String? productImageUrl;

  const ChatConversation({
    required this.id,
    required this.type,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
    required this.updatedAt,
    this.productId,
    this.productTitle,
    this.productImageUrl,
  });

  String get displayName {
    if (participants.isEmpty) return 'Unknown';
    if (participants.length == 1) return participants.first.name;
    return participants.map((p) => p.name.split(' ').first).join(', ');
  }

  String? get displayAvatarUrl {
    return participants.isNotEmpty ? participants.first.avatarUrl : null;
  }

  bool get isGroupChat => participants.length > 1;
}