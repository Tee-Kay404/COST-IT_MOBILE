import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/Screens/onBoarding/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.pages});

  final List<OnBoardingData> pages;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  // Unique key forces _TypewriterText to fully rebuild on each page change
  Key _typewriterKey = UniqueKey();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _typewriterKey = UniqueKey(); // restart typewriter for new headline
    });
    _animController
      ..reset()
      ..forward();
  }

  void _onNext() {
    if (_currentPage < widget.pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOut,
      );
    } else {
      _goToGetStarted();
    }
  }

  void _goToGetStarted() {
    Navigator.pushNamed(context, PageRoutes.getStarted.name);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageHeight = size.height * 0.60;

    final bool isLastPage = _currentPage == widget.pages.length - 1;
    final page = widget.pages[_currentPage];

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _ImageSection(
              pages: widget.pages,
              pageController: _pageController,
              currentPage: _currentPage,
              onPageChanged: _onPageChanged,
              onSkip: _goToGetStarted,
              imageHeight: imageHeight,
            ),

            //  Bottom Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Column(
                  children: [
                    Gap(24.h),

                    // Page badge
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.color.secondary,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              page.accentIcon,
                              size: 13.sp,
                              color: context.color.inversePrimary,
                            ),
                            Gap(5.w),
                            Text(
                              '${_currentPage + 1} of ${widget.pages.length}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: context.color.inversePrimary,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gap(14.h),

                    // Typewriter animated headline
                    SizedBox(
                      width: double.infinity,
                      child: AnimatedTextKit(
                        key: _typewriterKey,
                        totalRepeatCount: 3,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            widget.pages[_currentPage].headlineText,
                            cursor: '...',
                            textAlign: TextAlign.center,
                            textStyle: context.bodyLarge?.copyWith(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w800,
                              color: context.color.primary,
                              height: 1.2,
                            ),
                            speed: const Duration(milliseconds: 55),
                          ),
                        ],
                      ),
                    ),

                    Gap(12.h),

                    // Body text — fades in
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Text(
                          '${page.bodyText} ${page.bottomText}',
                          textAlign: TextAlign.center,
                          style: context.bodyMedium?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: CostItColors.brightGrey.shade400,
                          ),
                        ),
                      ),
                    ),

                    Spacer(),

                    SmoothPageIndicator(
                      controller: _pageController,
                      count: widget.pages.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8.h,
                        dotWidth: 8.w,
                        expansionFactor: 3.5,
                        spacing: 6.w,
                        radius: 8.r,
                        dotColor: context.color.secondary,
                        activeDotColor: context.color.primary,
                      ),
                      onDotClicked: (index) => _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                      ),
                    ),

                    Gap(18.h),

                    // CTA Button — "Next" on all pages except the last, "Done" on last
                    SharedButton(
                      onPressed: _onNext,
                      text: isLastPage ? 'Done' : 'Next',
                      color: context.color.primary,
                      width: double.infinity,
                    ),

                    Gap(24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Image section

class _ImageSection extends StatelessWidget {
  const _ImageSection({
    required this.pages,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.onSkip,
    required this.imageHeight,
  });

  final List<OnBoardingData> pages;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onSkip;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: imageHeight,
      child: Stack(
        children: [
          // Rounded image PageView
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28.r),
              child: PageView.builder(
                controller: pageController,
                onPageChanged: onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        pages[index].imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, __) => _PlaceholderImage(
                          index: index,
                          icon: pages[index].accentIcon,
                        ),
                      ),
                      // Bottom gradient overlay
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: imageHeight * 0.22,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.28),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Skip
          Positioned(
            top: 22.h,
            right: 28.w,
            child: GestureDetector(
              onTap: onSkip,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: context.color.secondary,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Skip',
                  style: context.bodySmall?.copyWith(
                    color: context.color.inversePrimary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder gradient when image asset is missing

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage({required this.index, required this.icon});

  final int index;
  final IconData icon;

  static const _gradients = [
    [Color(0xFF6580CF), Color(0xFF8BA4E8)],
    [Color(0xFF4A6BE0), Color(0xFF7B96F5)],
    [Color(0xFF3D5BD9), Color(0xFF6580CF)],
    [Color(0xFF5470C8), Color(0xFF8BA4E8)],
  ];

  @override
  Widget build(BuildContext context) {
    final grad = _gradients[index % _gradients.length];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: grad,
        ),
      ),
      child: Center(
        child: Icon(icon, size: 72, color: Colors.white.withOpacity(0.35)),
      ),
    );
  }
}