import 'package:cost_it_mobile/app/theme/theme.dart';
import '../models/sell_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NegotiationToggle extends StatelessWidget {
  final NegotiationStance value;
  final ValueChanged<NegotiationStance> onChanged;

  const NegotiationToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const _options = [
    (NegotiationStance.open, 'Open', Icons.handshake_outlined),
    (NegotiationStance.firm, 'Fixed price', Icons.lock_outline_rounded),
    (NegotiationStance.flexible, 'Ask me', Icons.help_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark
        ? context.color.secondary
        : context.color.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price negotiable?',
          style: context.bodySmall?.copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: _options.map((opt) {
            final (stance, label, icon) = opt;
            final selected = value == stance;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: opt != _options.last ? 8.w : 0),
                child: GestureDetector(
                  onTap: () => onChanged(stance),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: selected ? activeColor : context.color.surface,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: selected
                            ? activeColor
                            : (isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300),
                        width: 1,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: activeColor.withOpacity(0.25),
                                blurRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          icon,
                          size: 18.sp,
                          color: selected ? Colors.white : Colors.grey.shade500,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          label,
                          style: context.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected
                                ? Colors.white
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
