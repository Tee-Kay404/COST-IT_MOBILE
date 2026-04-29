import 'package:cost_it_mobile/app/layout/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralised responsive sizing for all auth screens.
///
/// Place this file at: lib/app/layout/auth_layout.dart
///
/// Every auth screen does one thing:
///   final r = AuthLayout(context);
///
/// Then uses r.horizontalPadding, r.logoHeight, r.buttonHeight, etc.
///
/// For bottom-pinning buttons/footers, use [AuthLayout.bottomSpacer].
/// It takes the available height from LayoutBuilder and the form height
/// from a GlobalKey — Flutter measures both, nothing is hardcoded.
class AuthLayout {
  AuthLayout(BuildContext context) {
    horizontalPadding = ScreenSize.isTablet(context) ? 40.w : 20.w;
    topSpacing        = ScreenSize.isMobile(context)  ? 20.h : 40.h;
    logoHeight        = ScreenSize.isTablet(context)  ? 60.h : 45.h;
    fieldSpacing      = ScreenSize.isTablet(context)  ? 20.h : 16.h;
    titleSpacing      = ScreenSize.isTablet(context)  ? 60.h : 50.h;
    buttonHeight      = ScreenSize.isTablet(context)  ? 60.h : 50.h;
    bottomSpacing     = ScreenSize.isTablet(context)  ? 24.h : 20.h;
  }

  late final double horizontalPadding;
  late final double topSpacing;
  late final double logoHeight;
  late final double fieldSpacing;
  late final double titleSpacing;
  late final double buttonHeight;
  late final double bottomSpacing;

  /// Returns a spacer whose height is the difference between the total
  /// available screen height (from LayoutBuilder) and the rendered height
  /// of the form content (measured via a GlobalKey on the form widget).
  ///
  /// Flutter measures both values at runtime — nothing is estimated.
  /// Minimum height is 24.h so it never collapses to zero.
  ///
  /// Usage:
  ///   // 1. Declare a key on your form container widget:
  ///   final _formKey = GlobalKey();
  ///
  ///   // 2. Wrap your form Column with it:
  ///   Column(key: _formKey, children: [ ...fields... ])
  ///
  ///   // 3. Inside LayoutBuilder, place the spacer after the form:
  ///   LayoutBuilder(builder: (context, constraints) {
  ///     return SingleChildScrollView(
  ///       child: Column(children: [
  ///         formWidget,
  ///         AuthLayout.bottomSpacer(
  ///           availableHeight: constraints.maxHeight,
  ///           formKey: _formKey,
  ///         ),
  ///         ...footer widgets...
  ///       ]),
  ///     );
  ///   })
  static Widget bottomSpacer({
    required double availableHeight,
    required GlobalKey formKey,
  }) {
    return _BottomSpacer(
      availableHeight: availableHeight,
      formKey: formKey,
    );
  }
}

/// Internal widget that reads the rendered size of [formKey]'s widget
/// and returns a SizedBox tall enough to push the footer to the bottom.
class _BottomSpacer extends StatefulWidget {
  const _BottomSpacer({
    required this.availableHeight,
    required this.formKey,
  });

  final double availableHeight;
  final GlobalKey formKey;

  @override
  State<_BottomSpacer> createState() => _BottomSpacerState();
}

class _BottomSpacerState extends State<_BottomSpacer> {
  double _spacerHeight = 0;

  @override
  void initState() {
    super.initState();
    // Schedule after the first frame so the form has been laid out
    // and RenderBox.size is available.
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculate());
  }

  @override
  void didUpdateWidget(_BottomSpacer old) {
    super.didUpdateWidget(old);
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculate());
  }

  void _calculate() {
    if (!mounted) return;
    final box =
        widget.formKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final formHeight = box.size.height;
    final space = widget.availableHeight - formHeight;
    final clamped = space > 24.h ? space : 24.h;
    if (clamped != _spacerHeight) {
      setState(() => _spacerHeight = clamped);
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(height: _spacerHeight);
}