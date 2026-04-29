import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/global/styles.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/utils/phone/phone_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IntlPhoneTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String? errorText;
  final String? initialValue;
  final FormFieldSetter<PhoneNumber>? onChanged;
  final FormFieldSetter<PhoneNumber>? onSaved;
  final FormFieldValidator<PhoneNumber>? validator;

  const IntlPhoneTextfield({
    super.key,
    this.errorText,
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      style: context.bodyMedium?.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: context.theme.primaryColorDark,
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      invalidNumberMessage: 'Phone Number is invalid',
      initialValue: initialValue,
      keyboardType: TextInputType.phone,

      initialCountryCode: 'NG',
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        NigerianPhoneInputFormatter(),
      ],
      showCountryFlag: true,
      showDropdownIcon: true,
      dropdownIcon: Icon(MdiIcons.chevronDown, size: 20.sp),
      dropdownIconPosition: IconPosition.trailing,

      flagsButtonPadding: EdgeInsets.symmetric(horizontal: 8.sp),
      dropdownTextStyle: context.bodyMedium?.copyWith(
        color: CostItColors.brightGrey.shade800,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),

      decoration: outlinedTextFields(context).copyWith(
        contentPadding: EdgeInsets.symmetric(vertical: 14.sp),
        counterText: '',
        hintText: '800 000 0000',
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),

      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
}
