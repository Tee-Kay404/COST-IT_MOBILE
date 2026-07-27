import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DiscountModal extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onSave;

  const DiscountModal({super.key, required this.initialValue, required this.onSave});

  @override
  State<DiscountModal> createState() => _DiscountModalState();
}

class _DiscountModalState extends State<DiscountModal> {
  static const options = [
    '5%',
    '10%',
    '15%',
    '20%',
    '25%',
    '30%',
    '40%',
    '50%',
    'Other',
  ];
  String _selected = '10%';
  final _customCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue.isNotEmpty) {
      if (widget.initialValue.endsWith(' off')) {
        final pct = widget.initialValue.replaceAll(' off', '');
        if (options.contains(pct)) {
          _selected = pct;
        } else {
          _selected = 'Other';
          _customCtrl.text = widget.initialValue;
        }
      } else {
        _selected = 'Other';
        _customCtrl.text = widget.initialValue;
      }
    }
  }

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.w,
        right: 20.w,
        top: 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Discount',
                style: context.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded, color: Colors.grey.shade500),
              ),
            ],
          ),
          Gap(16.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: options.map((opt) {
              final isSelected = _selected == opt;
              return ChoiceChip(
                label: Text(opt),
                selected: isSelected,
                showCheckmark: false,
                onSelected: (val) {
                  if (val) setState(() => _selected = opt);
                },
                selectedColor: context.color.primary.withOpacity(0.15),
                labelStyle: TextStyle(
                  color: isSelected
                      ? context.color.primary
                      : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14.sp,
                ),
                backgroundColor: isDark
                    ? CostItColors.brightGrey.shade800
                    : Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(
                    color: isSelected
                        ? context.color.primary
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              );
            }).toList(),
          ),
          if (_selected == 'Other') ...[
            Gap(20.h),
            CostItFormfield(
              controller: _customCtrl,
              labelText: 'Custom Offer',
              hintText: 'e.g. Buy 2 get 1 free',
              autofocus: true,
            ),
          ],
          Gap(32.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final val = _selected == 'Other'
                    ? _customCtrl.text.trim()
                    : '$_selected off';
                if (val.isEmpty) return;
                widget.onSave(val);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.color.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save Offer',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Gap(24.h),
        ],
      ),
    );
  }
}
