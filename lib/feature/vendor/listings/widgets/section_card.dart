import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final Widget child;
  const SectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.theme.scaffoldBackgroundColor,
      border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
    ),
    clipBehavior: Clip.antiAlias,
    child: child,
  );
}
