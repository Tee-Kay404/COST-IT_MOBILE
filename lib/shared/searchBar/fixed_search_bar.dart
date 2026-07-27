import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/app/global/styles/colors.dart';

class FixedSearchBar extends StatelessWidget {
  const FixedSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        boxShadow: Theme.of(context).brightness == Brightness.light ? const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ] : null,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, PageRoutes.search.name);
        },
        child: AbsorbPointer(
          child: TextFormField(
            readOnly: true,
            style: context.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Search products, materials...',
              hintStyle: context.bodyMedium?.copyWith(
                color: CostItColors.brightGrey.shade600,
                
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 24.sp,
                color: CostItColors.brightGrey.shade600,
              ),
              filled: true,
              fillColor: context.theme.cardColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: context.theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
