import 'dart:async';

import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/app/global/styles/colors.dart';

// lib/shared/widgets/search_bar/costit_search_bar.dart
/// Defines how the search bar behaves.
enum SearchMode {
  /// Fires [onChanged] on every keystroke — good for local/client-side filtering.
  instant,

  /// Debounces [onChanged] by [debounceDuration] — good for backend/API search.
  debounced,
}

class CostItSearchBar extends ConsumerStatefulWidget {
  /// Called whenever the query changes (debounced if [mode] is [SearchMode.debounced]).
  final ValueChanged<String>? onChanged;

  /// Called when the user submits via keyboard action.
  final ValueChanged<String>? onSubmitted;

  /// Called when the clear button is tapped.
  final VoidCallback? onCleared;

  /// Placeholder text inside the field.
  final String hint;

  /// Behaviour mode — instant (local) or debounced (backend).
  final SearchMode mode;

  /// Only used when [mode] is [SearchMode.debounced]. Defaults to 450 ms.
  final Duration debounceDuration;

  /// Pre-fill the field (e.g. restore a previous query).
  final String? initialValue;

  /// Pass your own controller if you need external access.
  final TextEditingController? controller;

  /// Show a loading spinner — drive this from your provider's loading state.
  final bool isLoading;

  /// Autofocus when the widget mounts.
  final bool autofocus;

  /// Height of the text field. Defaults to 45.h.
  final double? height;
  final FocusNode focusNode;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? focusBorder;

  const CostItSearchBar({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.onCleared,
    this.hint = 'Search...',
    this.mode = SearchMode.instant,
    this.debounceDuration = const Duration(milliseconds: 450),
    this.initialValue,
    this.controller,
    this.isLoading = false,
    this.autofocus = false,
    this.height,
    required this.focusNode,
    this.enabledBorder,
    this.focusBorder,
  });

  @override
  ConsumerState<CostItSearchBar> createState() => _CostItSearchBarState();
}

class _CostItSearchBarState extends ConsumerState<CostItSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounce;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    // Only dispose if we created our own controller
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _handleChanged(String value) {
    if (widget.onChanged == null) return;

    if (widget.mode == SearchMode.instant) {
      widget.onChanged!(value.trim());
      return;
    }

    // Debounced — cancel previous timer and start fresh
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      if (mounted) widget.onChanged!(value.trim());
    });
  }

  void _handleClear() {
    _controller.clear();
    _debounce?.cancel();
    widget.onChanged?.call('');
    widget.onCleared?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 50.h,
      child: TextField(
        cursorColor: context.theme.focusColor,
        controller: _controller,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        style: context.bodySmall?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        onChanged: _handleChanged,
        onSubmitted: (v) => widget.onSubmitted?.call(v.trim()),
        decoration: InputDecoration(
          fillColor: context.theme.cardColor,
          filled: true,
          hintText: widget.hint,
          hintStyle: context.bodyMedium?.copyWith(
            color: CostItColors.brightGrey.shade400,
          ),
          prefixIcon: widget.isLoading
              ? UnconstrainedBox(
                  child: SizedBox(
                    width: 18.sp,
                    height: 18.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: context.color.primary,
                    ),
                  ),
                )
              : Icon(
                  Icons.search_rounded,
                  size: 20.sp,
                  color: CostItColors.brightGrey.shade400,
                ),
          suffixIcon: _hasText
              ? GestureDetector(
                  onTap: _handleClear,
                  child: Icon(
                    Icons.clear_outlined,
                    size: 24.sp,
                    color: CostItColors.brightGrey.shade400,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder:
              widget.enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: context.theme.dividerColor,
                  width: 1,
                ),
              ),
          focusedBorder:
              widget.focusBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: context.theme.focusColor,
                  width: 1.5,
                ),
              ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
        ),
      ),
    );
  }
}
