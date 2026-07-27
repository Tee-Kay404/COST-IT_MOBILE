import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/shared/validators.dart';
import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryDropdown extends ConsumerWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const CategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.valueOrNull ?? [];

    return DropdownButtonFormField2<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Category *',
        labelStyle: TextStyle(
          fontSize: 13.sp,
          color: CostItColors.brightGrey.shade600,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Icon(
            Icons.category_outlined,
            size: 18.sp,
            color: CostItColors.brightGrey.shade500,
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 44.w),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: context.color.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: context.color.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: context.color.error, width: 1.5),
        ),
      ),
      style: context.bodyMedium?.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: context.theme.primaryColorDark,
      ),
      iconStyleData: IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 20.sp,
          color: CostItColors.brightGrey.shade500,
        ),
      ),
      buttonStyleData: ButtonStyleData(padding: EdgeInsets.only(right: 4.w)),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: context.color.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        maxHeight: 220.h,
        offset: Offset(0, -4.h),
      ),
      menuItemStyleData: MenuItemStyleData(
        height: 46.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        selectedMenuItemBuilder: (ctx, child) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            color: isDark
                ? Colors.transparent
                : CostItColors.brightGrey.shade100,
            child: child,
          );
        },
      ),
      selectedItemBuilder: (ctx) {
        return categories.map((cat) {
          return Text(
            cat.label,
            style: context.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: context.theme.primaryColorDark,
            ),
          );
        }).toList();
      },
      items: categories.map((cat) {
        final isSelected = value == cat.id;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return DropdownMenuItem<String>(
          value: cat.id,
          child: Text(
            cat.label,
            style: context.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? (isDark
                        ? CostItColors.secondaryDark
                        : context.color.primary)
                  : context.theme.primaryColorDark,
            ),
          ),
        );
      }).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      validator: Validators.isNotEmpty,
    );
  }
}
