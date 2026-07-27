import 'package:cost_it_mobile/feature/chat/widgets/tabs/contacts_tab.dart';
import 'package:cost_it_mobile/feature/chat/widgets/tabs/vendors_tab.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/shared/searchBar/search_bar.dart';

void showNewChatSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _NewChatSheet(),
  );
}

class _NewChatSheet extends ConsumerStatefulWidget {
  const _NewChatSheet();

  @override
  ConsumerState<_NewChatSheet> createState() => _NewChatSheetState();
}

class _NewChatSheetState extends ConsumerState<_NewChatSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final mq = MediaQuery.of(context);

    return Container(
      height: mq.size.height * 0.82,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: color.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Row(
              children: [
                Text(
                  'New Conversation',
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.color.inverseSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.black),
                  style: IconButton.styleFrom(
                    backgroundColor: color.surfaceContainerHighest,
                    padding: EdgeInsets.zero,
                    minimumSize: Size(36.r, 36.r),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: CostItSearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (_) => setState(() {}),
              hint: 'Search vendors or contacts...',
              mode: SearchMode.instant,
            ),
          ),

          TabBar(
            controller: _tabController,
            labelColor: context.color.onPrimary,
            unselectedLabelColor: context.color.inverseSurface.withValues(alpha: 0.5),
            indicatorColor: context.color.onPrimary,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: 'Vendors'),
              Tab(text: 'Contacts'),
            ],
          ),

          Divider(height: 1, color: color.outlineVariant),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                VendorsTab(query: _searchController.text),
                ContactsTab(query: _searchController.text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

