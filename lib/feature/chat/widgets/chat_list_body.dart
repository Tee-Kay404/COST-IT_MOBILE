import 'package:cost_it_mobile/feature/chat/models/chat_model.dart';
import 'package:cost_it_mobile/feature/chat/providers/chat_provider.dart';
import 'package:cost_it_mobile/feature/chat/utils/state/chat_empty_state.dart';
import 'package:cost_it_mobile/feature/chat/widgets/chat_list_tile.dart';
import 'package:cost_it_mobile/feature/chat/widgets/chat_error_state.dart';
import 'package:cost_it_mobile/feature/chat/widgets/conversations_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatListBody extends ConsumerWidget {
  final VoidCallback onFindVendor;
  final VoidCallback onInviteContact;
  final ValueChanged<ChatConversation> onTapConversation;

  const ChatListBody({
    super.key,
    required this.onFindVendor,
    required this.onInviteContact,
    required this.onTapConversation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(filteredConversationsProvider);

    return async.when(
      loading: () => const ConversationsSkeleton(),
      error: (e, _) => ChatErrorState(
        onRetry: () {
          ref.invalidate(conversationsProvider);
        },
      ),
      data: (conversations) {
        if (conversations.isEmpty) {
          return ChatEmptyState(
            onFindVendor: onFindVendor,
            onInviteContact: onInviteContact,
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(conversationsProvider.notifier).refresh(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: conversations.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, indent: 70.w, endIndent: 0),
            itemBuilder: (context, i) {
              final conv = conversations[i];
              return ChatListTile(
                conversation: conv,
                onTap: () => onTapConversation(conv),
              );
            },
          ),
        );
      },
    );
  }
}
