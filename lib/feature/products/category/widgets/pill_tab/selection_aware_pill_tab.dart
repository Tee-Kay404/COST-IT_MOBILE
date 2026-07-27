import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../category.dart';

class SelectionAwarePillTab extends StatefulWidget {
  final int index;
  final String label;
  final Color borderColor;

  const SelectionAwarePillTab({
    super.key,
    required this.index,
    required this.label,
    required this.borderColor,
  });

  @override
  State<SelectionAwarePillTab> createState() => _SelectionAwarePillTabState();
}

class _SelectionAwarePillTabState extends State<SelectionAwarePillTab> {
  TabController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newController = DefaultTabController.of(context);
    if (_controller != newController) {
      _controller?.removeListener(_onTabChange);
      _controller = newController..addListener(_onTabChange);
    }
  }

  int? _lastIndex;

  void _onTabChange() {
    final currentIndex = _controller?.index;
    if (currentIndex != _lastIndex && mounted) {
      setState(() {
        _lastIndex = currentIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = (_controller?.index ?? 0) == widget.index;
    return Tab(
      height: 34.h,
      child: CategoryPillTab(
        label: widget.label,
        isSelected: isSelected,
        borderColor: widget.borderColor,
      ),
    );
  }
}