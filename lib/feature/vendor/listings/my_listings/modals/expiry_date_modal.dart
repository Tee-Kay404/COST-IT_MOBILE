import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpiryDateModal extends StatefulWidget {
  final DateTime? initialDate;

  const ExpiryDateModal({super.key, this.initialDate});

  @override
  State<ExpiryDateModal> createState() => _ExpiryDateModalState();
}

class _ExpiryDateModalState extends State<ExpiryDateModal> {
  late DateTime _selectedDate;
  late final DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // Ensure initial date is not before minimum date
    final init = widget.initialDate ?? _now.add(const Duration(days: 7));
    _selectedDate = init.isBefore(_now) ? _now : init;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 320.h,
        child: Column(
          children: [
            Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Text(
                    'Offer Expiry Date',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, _selectedDate);
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: CostItColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                minimumDate: _now,
                maximumDate: _now.add(const Duration(days: 365)),
                onDateTimeChanged: (d) {
                  _selectedDate = d;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
