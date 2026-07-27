import 'package:cost_it_mobile/Screens/dashboard/home_page.dart';
import 'package:cost_it_mobile/app/global/utils/guest_gate.dart';
import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/components/drawer/drawer.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/extensions/string_extension.dart';
import 'package:cost_it_mobile/feature/chat/pages/chat_page.dart';
import 'package:cost_it_mobile/feature/account/view/account_view.dart';
import 'package:cost_it_mobile/feature/vendor/listings/views/listing_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

enum HomeTab {
  home("home"),
  chat("chat"),
  sell("sell"),
  account("account");

  final String value;
  const HomeTab(this.value);

  factory HomeTab.fromString(String value) {
    return HomeTab.values.firstWhere(
      (type) => type.value == value,
      orElse: () => HomeTab.home,
    );
  }

  String get label => name.titleCase;
  String get iconPath => 'assets/inactive_navbar_icon/$name.svg';
  String get activeIconPath => 'assets/active_navbar_icon/active_$name.svg';
}

class CustomBottomNavigationBar extends ConsumerStatefulWidget {
  final int? pageNumber;
  const CustomBottomNavigationBar({super.key, this.pageNumber});

  @override
  ConsumerState<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

final selectedTabProvider = StateProvider<int>((ref) => 0);
final bottomBarVisibleProvider = StateProvider<bool>((ref) => true);

class _CustomBottomNavigationBarState
    extends ConsumerState<CustomBottomNavigationBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(scaffoldKey: _scaffoldKey),
      const ChatPage(),
      const SellFormView(),
      const AccountView(),
    ];
    if (widget.pageNumber != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedTabProvider.notifier).state = widget.pageNumber!;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      ref.read(selectedTabProvider.notifier).state = index;
      return;
    }
    guardAuth(context, ref, () {
      ref.read(selectedTabProvider.notifier).state = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedTabProvider);
    final isBottomBarVisible = ref.watch(bottomBarVisibleProvider);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse) {
            if (isBottomBarVisible) {
              ref.read(bottomBarVisibleProvider.notifier).state = false;
            }
          } else if (notification.direction == ScrollDirection.forward) {
            if (!isBottomBarVisible) {
              ref.read(bottomBarVisibleProvider.notifier).state = true;
            }
          }
          return false;
        },
        child: IndexedStack(index: selectedIndex, children: _pages),
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: isBottomBarVisible ? Offset.zero : const Offset(0, 1),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: context.color.primary,
            notchMargin: 8,
            elevation: 0,
            height: 65.h,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: HomeTab.values.map((tab) {
                final index = HomeTab.values.indexOf(tab);
                final isSelected = selectedIndex == index;

                final isLeftOfNotch = index == 1;
                final isRightOfNotch = index == 2;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: isLeftOfNotch ? 28 : 0,
                      left: isRightOfNotch ? 28 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => _onItemTapped(index),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            width: 42.w,
                            height: 42.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? context.color.secondary
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                isSelected ? tab.activeIconPath : tab.iconPath,
                                width: 20.w,
                                height: 20.h,
                                colorFilter: ColorFilter.mode(
                                  isSelected
                                      ? CostItColors.white
                                      : CostItColors.brightGrey.shade200,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Transform.translate(
                            offset: const Offset(0, -2),
                            child: Text(
                              tab.label,
                              textAlign: TextAlign.center,
                              style: context.bodySmall?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: isSelected
                                    ? CostItColors.white
                                    : CostItColors.brightGrey.shade200,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: isBottomBarVisible ? Offset.zero : const Offset(0, 0.35),
        child: SizedBox(
          width: 60.w,
          height: 60.h,
          child: RawMaterialButton(
            fillColor: context.color.primary,
            shape: CircleBorder(
              side: BorderSide(width: 2, color: context.color.secondary),
            ),
            padding: EdgeInsets.zero,
            elevation: 4,
            onPressed: () => ref.read(selectedTabProvider.notifier).state = 0,
            child: ClipOval(
              child: Image.asset(
                AppImages.floatLogo,
                fit: BoxFit.cover,
                height: 60.h,
                width: 60.w,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
