import 'package:cost_it_mobile/app/theme/theme.dart';
import '../models/sell_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class _TierMeta {
  final VisibilityTier tier;
  final String name;
  final String tagline;
  final String price;
  final IconData icon;
  final List<String> perks;
  final Color accent;

  const _TierMeta({
    required this.tier,
    required this.name,
    required this.tagline,
    required this.price,
    required this.icon,
    required this.perks,
    required this.accent,
  });
}

const _tiers = [
  _TierMeta(
    tier: VisibilityTier.standard,
    name: 'Standard',
    tagline: 'Post for free',
    price: 'Free',
    icon: Icons.storefront_outlined,
    perks: ['Appears in search results', 'Active for 30 days'],
    accent: Color(0xFF6580CF),
  ),
  _TierMeta(
    tier: VisibilityTier.featured,
    name: 'Featured',
    tagline: 'Get seen faster',
    price: '₦4,999 / 7 days',
    icon: Icons.rocket_launch_outlined,
    perks: [
      'Pinned above standard listings',
      'Up to 10× more views',
      'Badge on listing',
    ],
    accent: Color(0xFF17BEFC),
  ),
  _TierMeta(
    tier: VisibilityTier.premium,
    name: 'Premium',
    tagline: 'Maximum reach',
    price: '₦19,999 / 30 days',
    icon: Icons.workspace_premium_outlined,
    perks: [
      'Top of every search',
      'Homepage spotlight',
      'Priority support',
      'Analytics dashboard',
    ],
    accent: Color(0xFFFFD700),
  ),
];

class VisibilityBoostSelector extends StatelessWidget {
  final VisibilityTier selected;
  final ValueChanged<VisibilityTier> onChanged;

  const VisibilityBoostSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Boost your listing',
          style: context.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Gap(4.h),
        Text(
          'More visibility = more enquiries',
          style: context.bodySmall?.copyWith(
            fontSize: 12.sp,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
          ),
        ),
        Gap(12.h),
        ..._tiers.map(
          (meta) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _TierCard(
              meta: meta,
              isSelected: selected == meta.tier,
              onTap: () => onChanged(meta.tier),
            ),
          ),
        ),
      ],
    );
  }
}

class _TierCard extends StatelessWidget {
  final _TierMeta meta;
  final bool isSelected;
  final VoidCallback onTap;

  const _TierCard({
    required this.meta,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? meta.accent.withOpacity(0.07)
              : context.color.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? meta.accent : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: meta.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(meta.icon, size: 20.sp, color: meta.accent),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        meta.name,
                        style: context.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? meta.accent
                              : context.theme.primaryColorDark,
                        ),
                      ),
                      Text(
                        meta.price,
                        style: context.bodySmall?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? meta.accent
                              : context.theme.primaryColorDark,
                        ),
                      ),
                    ],
                  ),
                  Gap(2.h),
                  Text(
                    meta.tagline,
                    style: context.bodySmall?.copyWith(
                      fontSize: 11.sp,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Gap(8.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 4.h,
                    children: meta.perks
                        .map(
                          (perk) => _PerkChip(label: perk, color: meta.accent),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            Gap(8.w),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? meta.accent : Colors.transparent,
                border: Border.all(
                  color: isSelected ? meta.accent : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _PerkChip extends StatelessWidget {
  final String label;
  final Color color;

  const _PerkChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: context.bodySmall?.copyWith(
          fontSize: 10.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
