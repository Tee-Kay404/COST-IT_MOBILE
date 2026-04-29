import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:cost_it_mobile/widgets/speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DashBoard extends ConsumerStatefulWidget {
  const DashBoard({super.key});

  @override
  ConsumerState<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends ConsumerState<DashBoard> {
  final List<IconData> iconList = [
    Icons.home,
    Icons.message,
    Icons.shopping_cart,
    Icons.person,
  ];

  int _bottomNavIndex = 0; 

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final email = ref.watch(userEmailProvider);
    final fullEmail = email?.characters.toLowerCase() ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CostItColors.primary2,
        title: Text('CostIt'),
        titleTextStyle: TextStyle(
          color: theme.primaryColorLight,
          fontSize: 28.sp,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        width: 200,
        child: Center(child: Text('I\'m still working\n on it biko 🙏')),
      ),
      body: Column(
        children: [
          Image.asset('assets/images/cost-it_logo.png'),
          Gap(20.h),
          Text(
            'Welcome, $fullEmail\nPage index: $_bottomNavIndex',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CostItColors.primary2,
        mini: true,
        foregroundColor: theme.primaryColorLight,
        shape: CircleBorder(),
        onPressed: () {
          // You can add logic for FAB here
          // var username = 'TeeKay';
          
        },
        child: Column(children: [CostItSpeedDial()]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              final color = isActive
                  ? CostItColors.primary1
                  : theme.primaryColorLight;

              return AnimatedScale(
                scale: isActive ? 1.3 : 1.0, // zoom when active
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: Icon(iconList[index], size: 28.sp, color: color),
              );
            },
            activeIndex: _bottomNavIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.defaultEdge,
            leftCornerRadius: 30.sp,
            rightCornerRadius: 30.sp,
            backgroundColor: CostItColors.primary2,
            onTap: (index) {
              setState(() => _bottomNavIndex = index);
            },
          );
        },
      ),
    );
  }
}
