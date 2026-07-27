import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/components/drawer/drawer_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cost_it_mobile/feature/account/widgets/logout_sheet.dart';

class AccountTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? profileImageUrl;
  final String? fallbackInitial;
  final VoidCallback? onTap;

  const AccountTile({
    super.key,
    required this.userName,
    required this.userEmail,
    this.profileImageUrl,
    this.fallbackInitial,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: ListTile(
        tileColor: context.color.primary,
        onTap: onTap,
        titleTextStyle: context.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: CostItColors.white,
        ),
        subtitleTextStyle: context.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: CostItColors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        minTileHeight: 60.h,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
        leading: CircleAvatar(
          radius: 35.r,
          backgroundColor: profileImageUrl == null
              ? CostItColors.white
              : Colors.transparent,
          backgroundImage: profileImageUrl != null
              ? NetworkImage(profileImageUrl!)
              : null,
          child: profileImageUrl == null
              ? Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: context.bodyLarge?.copyWith(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: context.color.primary,
                  ),
                )
              : null,
        ),
        title: Text(userName),
        subtitle: Text(userEmail),
      ),
    );
  }
}

class DrawerItem {
  final String title;
  final IconData icon;
  final DrawerRoute route;

  const DrawerItem({
    required this.title,
    required this.icon,
    required this.route,
  });

  bool get isDestructive => route.isDestructive;
}

const List<DrawerItem> drawerItems = [
  DrawerItem(title: 'Home', icon: Icons.home_outlined, route: DrawerRoute.home),
  DrawerItem(
    title: 'Categories',
    icon: Icons.storefront_outlined,
    route: DrawerRoute.categories,
  ),
  DrawerItem(
    title: 'Saved',
    icon: Icons.save_outlined,
    route: DrawerRoute.saved,
  ),

  DrawerItem(
    title: 'Settings',
    icon: Icons.settings_outlined,
    route: DrawerRoute.settings,
  ),
  DrawerItem(
    title: 'Contact Us',
    icon: Icons.headset_mic_outlined,
    route: DrawerRoute.contactUs,
  ),
  DrawerItem(
    title: 'Rate App',
    icon: Icons.star_outline_rounded,
    route: DrawerRoute.rateApp,
  ),
  DrawerItem(title: 'Logout', icon: Icons.logout, route: DrawerRoute.logout),
];

class DrawerTile extends ConsumerWidget {
  final DrawerItem item;

  const DrawerTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = item.isDestructive
        ? context.color.error
        : Theme.of(context).colorScheme.inverseSurface;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      child: ListTile(
        tileColor: isDark
            ? context.color.primary.withValues(alpha: 0.1)
            : context.color.inversePrimary,
        titleTextStyle: context.bodyMedium?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        iconColor: item.isDestructive ? textColor : context.color.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        minTileHeight: 60.h,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
        leading: Icon(item.icon, size: 20.sp),
        title: Text(item.title),
        onTap: () => item.route.navigate(
          context,
          onLogout: () {
            showLogoutSheet(context);
          },
        ),
      ),
    );
  }
}
