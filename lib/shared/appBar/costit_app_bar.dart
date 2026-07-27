import 'package:cost_it_mobile/app/global/utils/guest_gate.dart';
import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/location/widget/location_field.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CostItAppBar extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CostItAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final topPadding = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      primary: false,
      toolbarHeight: 60.h,
      floating: true,
      snap: true,
      pinned: false,
      automaticallyImplyLeading: false,
      backgroundColor: context.color.primary,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => scaffoldKey.currentState?.openDrawer(),
                  child: AvatarThumb(),
                ),
                SizedBox(width: 10.w),
                Text(
                  'Explore',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LocationFieldWidget(),
                SizedBox(width: 8.w),
                NotificationIcon(
                  hasNotification: true,
                  onTap: () {
                    guardAuth(context, ref, () {
                      Navigator.pushNamed(
                        context,
                        PageRoutes.notifications.name,
                      );
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AvatarThumb extends ConsumerWidget {
  const AvatarThumb({super.key});

  static const List<List<Color>> _gradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    [Color(0xFF43E97B), Color(0xFF38F9D7)],
    [Color(0xFFA18CD1), Color(0xFFFC74A8)],
    [Color(0xFFF7971E), Color(0xFFFFD200)],
    [Color(0xFF4FACFE), Color(0xFF00F2FE)],
  ];

  List<Color> _getGradient(String email) {
    if (email.isEmpty) return _gradients[0];
    final index = email.hashCode.abs() % _gradients.length;
    return _gradients[index];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appStateProvider).user;

    final userEmail = user?.email ?? '';
    final photoUrl = user?.photoUrl;
    final isGoogleUser = photoUrl != null && photoUrl.isNotEmpty;
    final fallbackLetter = userEmail.isNotEmpty
        ? userEmail[0].toUpperCase()
        : 'G';
    final emailForGradient = userEmail.isEmpty ? 'G' : userEmail;

    if (isGoogleUser) {
      return CircleAvatar(
        radius: 17.r,
        backgroundImage: NetworkImage(photoUrl),
      );
    }

    return Container(
      width: 34.r,
      height: 34.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: _getGradient(emailForGradient),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        fallbackLetter,
        style: context.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
