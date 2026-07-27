import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ThemeOption {
  final ThemeMode mode;
  final String title;
  final String subtitle;
  final IconData icon;

  const ThemeOption({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class ThemeTile extends StatelessWidget {
  final ThemeOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemeTile({super.key, 
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected
            ? context.color.onPrimary.withOpacity(0.06)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSelected ? context.color.onPrimary : Colors.grey.shade300,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.color.onPrimary
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    option.icon,
                    size: 20.sp,
                    color: isSelected
                        ? Colors.white
                        : CostItColors.brightGrey.shade500,
                  ),
                ),
                Gap(14.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: context.bodySmall?.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? context.color.onPrimary
                              : context.theme.primaryColorDark,
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        option.subtitle,
                        style: context.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: isSelected
                              ? context.color.onPrimary
                              : CostItColors.brightGrey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? context.color.onPrimary
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? context.color.onPrimary
                          : Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          size: 13.sp,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
