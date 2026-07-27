import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'shared_widgets.dart';

/// Expandable product description with "Show more/less" toggle,
/// accented with the primary color on the toggle label.
class DescriptionCard extends StatefulWidget {
  final String description;
  const DescriptionCard({super.key, required this.description});

  @override
  State<DescriptionCard> createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<DescriptionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(label: 'Description'),
          Gap(10.h),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 280),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(
              widget.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: context.bodySmall?.copyWith(
                fontSize: 13.sp,
                color: CostItColors.brightGrey.shade500,
                height: 1.65,
                fontWeight: FontWeight.w400,
              ),
            ),
            secondChild: Text(
              widget.description,
              style: context.bodySmall?.copyWith(
                fontSize: 13.sp,
                color: CostItColors.brightGrey.shade500,
                height: 1.65,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Gap(6.h),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Show less' : 'Show more',
              style: TextStyle(
                color: context.color.onPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
