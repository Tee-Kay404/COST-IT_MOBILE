import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CostItBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CostItBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),

      child: CurvedNavigationBar(
        index: currentIndex,
        height: 53.h,
        maxWidth: double.infinity.w,
        color: context.color.primary,
        backgroundColor: context.color.inversePrimary,
        buttonBackgroundColor: context.color.secondary,

        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 400),

        onTap: onTap,

        items: [
          _NavIcon(icon: Icons.home_rounded, isActive: currentIndex == 0),

          _NavIcon(icon: Icons.chat_outlined, isActive: currentIndex == 1),

          _NavIcon(icon: Icons.sell_outlined, isActive: currentIndex == 2),

          _NavIcon(icon: Icons.settings, isActive: currentIndex == 3),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const _NavIcon({required this.icon, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 250),
      scale: isActive ? 1.05 : 1,

      child: Icon(
        icon,
        size: 26.sp,
        color: isActive ? context.color.surface : context.color.secondary,
      ),
    );
  }
}
