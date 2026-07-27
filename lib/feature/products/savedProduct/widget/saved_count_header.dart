import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedCountHeader extends StatelessWidget {
  final int count;
  final int total;
  final bool isFiltered;

  const SavedCountHeader({
    super.key,
    required this.count,
    required this.total,
    required this.isFiltered,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Row(
        children: [
          Text(
            isFiltered
                ? '$count of $total saved'
                : '$total saved product${total == 1 ? '' : 's'}',
            style: context.bodySmall?.copyWith(
              color: context.color.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
