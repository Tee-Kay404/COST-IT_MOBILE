import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/extensions/string_extension.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/shared/bottomNavBar/bott_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../feature/billing/models/billing_models.dart';
import 'drawer_route.dart';
import 'drawer_utils.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final appState = ref.watch(appStateProvider);
    final isGuest = appState.isGuestLoggedIn;
    final user = appState.user;
    final firstName = user?.firstName.trim() ?? '';
    final lastName = user?.lastName.trim() ?? '';
    final joined = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
    final fullName = joined.isEmpty ? 'Guest' : joined;
    final userEmail = user?.email ?? '';
    final photoUrl = user?.photoUrl;
    final isGoogleUser = photoUrl != null && photoUrl.isNotEmpty;

    return Drawer(
      width: mediaQuery.size.width * 0.78,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: mediaQuery.size.height * 0.115,
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(color: context.color.primary),
                child: Center(
                  child: isGuest
                      ? _GuestDrawerHeader()
                      : AccountTile(
                          userName: fullName,
                          userEmail: userEmail,
                          profileImageUrl: isGoogleUser ? photoUrl : null,
                          fallbackInitial: nameInitials(firstName, lastName),
                          onTap: () {
                            Navigator.pop(context);
                            ref.read(selectedTabProvider.notifier).state = 3;
                            final currentRouteName = ModalRoute.of(
                              context,
                            )?.settings.name;
                            if (currentRouteName != PageRoutes.dashBoard.name) {
                              Navigator.popUntil(context, (route) => route.isFirst);
                            }
                          },
                        ),
                ),
              ),
            ),

            if (!isGuest) ...[
              SizedBox(height: 10.h),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: drawerItems
                      .where((item) => item.route != DrawerRoute.logout)
                      .map((item) => DrawerTile(item: item))
                      .toList(),
                ),
              ),

              Consumer(
                builder: (context, ref, _) {
                  final sub = ref.watch(activeSubscriptionProvider);
                  if (sub == null) return const SizedBox.shrink();
                  return CurrentPlanTile(
                    onTap: () {
                      Navigator.pop(context); 
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BillingScreen()),
                      );
                    },
                  );
                },
              ),

              DrawerTile(
                item: drawerItems.firstWhere(
                  (item) => item.route == DrawerRoute.logout,
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ],
        ),
      ),
    );
  }
}

class _GuestDrawerHeader extends StatelessWidget {
  const _GuestDrawerHeader();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, PageRoutes.getStarted.name);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: CostItColors.white,
              child: Icon(
                Icons.person_outline_rounded,
                size: 28.sp,
                color: context.color.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign in / Create account',
                    style: context.bodyMedium?.copyWith(
                      color: CostItColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Access all features',
                    style: context.bodySmall?.copyWith(
                      color: CostItColors.white.withValues(alpha: 0.7),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: CostItColors.white,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}
