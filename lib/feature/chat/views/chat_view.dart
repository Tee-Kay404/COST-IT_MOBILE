import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/chat/providers/chat_permission_provider.dart';
import 'package:cost_it_mobile/feature/chat/providers/chat_provider.dart';
import 'package:cost_it_mobile/feature/chat/widgets/chat_list_body.dart';
import 'package:cost_it_mobile/feature/chat/widgets/chat_permission_banner.dart';
import 'package:cost_it_mobile/feature/chat/widgets/chat_permission_gate.dart';
import 'package:cost_it_mobile/feature/chat/widgets/new_chat.dart';
import 'package:cost_it_mobile/feature/chat/widgets/new_chat_fab.dart';
import 'package:cost_it_mobile/shared/appBar/costit_app_bar.dart';
import 'package:cost_it_mobile/shared/appBar/costit_back_app_bar.dart';
import 'package:cost_it_mobile/shared/searchBar/search_bar.dart';
import 'package:cost_it_mobile/widgets/app_bar_popup_menu.dart';
import 'package:cost_it_mobile/widgets/arrow_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Entry point for the chat feature.
/// Wrap with [ChatPermissionGate] so permissions are asked on first visit.
class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  bool _searchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(chatSearchQueryProvider.notifier).state = value;
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(chatSearchQueryProvider.notifier).state = '';
    setState(() => _searchActive = false);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return ChatPermissionGate(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: ChatListBody(
          onFindVendor: () {
            // TODO: navigate to product/vendor browse
          },
          onInviteContact: () => showNewChatSheet(context),
          onTapConversation: (conversation) {
            // TODO: push to ChatConversationPage(conversationId: conversation.id)
          },
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 65.h),
          child: NewChatFAB(onPressed: () => showNewChatSheet(context)),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final color = context.color;
    final user = ref.watch(appStateProvider).user;
    final userEmail = user?.email ?? '';

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState: _searchActive
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: CostItBackAppBar(
          title: 'Messages',
          showBackButton: false,
          leadingWidth: 60.w,
          leading: PopupMenuButton<void>(
            color: context.color.surface,
            offset: Offset(0, 48.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            itemBuilder: (context) => [
              PopupMenuItem<void>(
                enabled: false,
                child: Text(
                  userEmail.isEmpty ? 'Guest' : userEmail,
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.color.inverseSurface,
                  ),
                ),
              ),
            ],
            child: Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Center(child: const AvatarThumb()),
            ),
          ),
          actions: [
            Transform.translate(
              offset: Offset(22.w, 0),
              child: GestureDetector(
                onTap: () {
                  setState(() => _searchActive = true);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (mounted) _searchFocusNode.requestFocus();
                  });
                },
                child: const Icon(Icons.search_outlined, color: Colors.white),
              ),
            ),
            AppBarPopupMenu<String>(
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'settings',
                  child: Text(
                    'Settings',
                    style: context.bodyMedium?.copyWith(
                      color: context.color.inverseSurface,
                    ),
                  ),
                ),
              ],
              onSelected: (val) {},
            ),
            SizedBox(width: 8.w),
            // Permission warning badge
            Consumer(
              builder: (context, ref, _) {
                final permState = ref.watch(chatPermissionProvider);
                if (permState.missing.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  onPressed: () => _showPermissionBanner(context),
                  icon: Badge(
                    backgroundColor: color.error,
                    smallSize: 8,
                    child: Icon(
                      Icons.warning_amber_outlined,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? color.inverseSurface
                          : color.onSurface.withOpacity(0.7),
                    ),
                  ),
                  tooltip: 'Some permissions are missing',
                );
              },
            ),
          ],
        ),
        secondChild: AppBar(
          backgroundColor: context.color.primary,
          titleSpacing: 0,
          leading: ArrowBackButton(
            color: CostItColors.white,
            size: 24.sp,
            onPressed: _clearSearch,
          ),
          leadingWidth: 56.w,
          title: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: SizedBox(
              height: 45.h,
              child: CostItSearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                hint: 'Search conversations...',
                onChanged: _onSearchChanged,
                mode: SearchMode.instant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPermissionBanner(BuildContext context) {
    final permState = ref.read(chatPermissionProvider);
    final missing = permState.missing;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ChatPermissionBanner(
        missingPermissions: missing,
        onRequestAll: () async {
          Navigator.pop(context);
          await ref.read(chatPermissionProvider.notifier).requestAll();
        },
        onOpenSettings: () async {
          Navigator.pop(context);
          await ref.read(chatPermissionProvider.notifier).openSettings();
        },
      ),
    );
  }
}
