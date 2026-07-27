import 'package:cost_it_mobile/feature/chat/models/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Conversations List Provider ──────────────────────────────────────────────
// Stub: replace with your actual repository / socket stream

class ConversationsNotifier
    extends AsyncNotifier<List<ChatConversation>> {
  @override
  Future<List<ChatConversation>> build() async {
    // TODO: replace with real backend fetch / WebSocket subscription
    // e.g. return ref.watch(chatRepositoryProvider).getConversations();
    await Future.delayed(const Duration(milliseconds: 600)); // simulate latency
    return []; // new user → empty
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 400));
      return <ChatConversation>[];
    });
  }

  /// Optimistically insert a new conversation (called after starting a chat)
  void addConversation(ChatConversation conversation) {
    state.whenData((list) {
      state = AsyncData([conversation, ...list]);
    });
  }

  /// Update unread count or last message when a socket event arrives
  void updateConversation(ChatConversation updated) {
    state.whenData((list) {
      final idx = list.indexWhere((c) => c.id == updated.id);
      if (idx == -1) {
        state = AsyncData([updated, ...list]);
      } else {
        final next = [...list];
        next[idx] = updated;
        // Bring to top if it has a newer message
        next.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        state = AsyncData(next);
      }
    });
  }

  void markAsRead(String conversationId) {
    state.whenData((list) {
      final next = list.map((c) {
        if (c.id == conversationId) {
          return ChatConversation(
            id: c.id,
            type: c.type,
            participants: c.participants,
            lastMessage: c.lastMessage,
            unreadCount: 0,
            updatedAt: c.updatedAt,
            productId: c.productId,
            productTitle: c.productTitle,
            productImageUrl: c.productImageUrl,
          );
        }
        return c;
      }).toList();
      state = AsyncData(next);
    });
  }
}

final conversationsProvider =
    AsyncNotifierProvider<ConversationsNotifier, List<ChatConversation>>(
  ConversationsNotifier.new,
);

// ─── Total unread badge count ─────────────────────────────────────────────────

final totalUnreadProvider = Provider<int>((ref) {
  return ref.watch(conversationsProvider).maybeWhen(
        data: (list) => list.fold(0, (sum, c) => sum + c.unreadCount),
        orElse: () => 0,
      );
});

// ─── Search / filter provider ─────────────────────────────────────────────────

final chatSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredConversationsProvider =
    Provider<AsyncValue<List<ChatConversation>>>((ref) {
  final conversations = ref.watch(conversationsProvider);
  final query = ref.watch(chatSearchQueryProvider).toLowerCase().trim();

  if (query.isEmpty) return conversations;

  return conversations.whenData(
    (list) => list.where((c) {
      return c.displayName.toLowerCase().contains(query) ||
          (c.productTitle?.toLowerCase().contains(query) ?? false) ||
          (c.lastMessage?.content.toLowerCase().contains(query) ?? false);
    }).toList(),
  );
});