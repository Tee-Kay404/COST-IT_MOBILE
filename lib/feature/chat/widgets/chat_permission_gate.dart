import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_permission_provider.dart';
import '../utils/permission/chat_permission.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        child: SingleChildScrollView(
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
                  color: Theme.of(context).brightness == Brightness.dark
                      ? color.onPrimary
                      : color.primary,
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
                  color: Theme.of(context).brightness == Brightness.dark
                      ? CostItColors.brightGrey.shade500
                      : color.onSurface.withOpacity(0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),
              ...ChatPermission.values.map(
                (p) => _PermissionRow(permission: p),
              ),
              const SizedBox(height: 40),
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
              SizedBox(height: 100.h),
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
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              permission.icon,
              color: Theme.of(context).brightness == Brightness.dark
                  ? color.onPrimary
                  : color.primary,
              size: 20,
            ),
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
                    color: color.onSurface.withOpacity(0.55),
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
