import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/Screens/onBoarding/model.dart';
import 'package:flutter/material.dart';
import 'package:cost_it_mobile/Screens/onBoarding/onboarding_screen.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      pages: [
        OnBoardingData(
          imagePath: AppImages.onboarding1,
          headlineText: 'Buy & Sell\nWith Ease',
          bodyText:
              'Purchase or list construction materials, plant and heavy machinery',
          bottomText: 'all in one trusted marketplace built for professionals.',
          accentIcon: Icons.storefront_rounded,
        ),
        OnBoardingData(
          imagePath: AppImages.onboarding2,
          headlineText: 'Connect With\nSkilled Professionals',
          bodyText:
              'Find and link up with verified artisans, contractors and experts',
          bottomText: 'to get the right people for every job.',
          accentIcon: Icons.people_alt_rounded,
        ),
        OnBoardingData(
          imagePath: AppImages.onboarding3,
          headlineText: 'Hire & Offer\nServices',
          bodyText:
              'Need a service or have one to offer? Easily hire or get hired',
          bottomText: 'for construction jobs of any scale.',
          accentIcon: Icons.handyman_rounded,
        ),
        OnBoardingData(
          imagePath: AppImages.onboarding4,
          headlineText: 'Chat & Stay\nConnected',
          bodyText:
              'Message suppliers, clients and followers directly within the app',
          bottomText: 'and keep all your conversations in one place.',
          accentIcon: Icons.chat_bubble_rounded,
        ),
        OnBoardingData(
          imagePath: AppImages.onboarding5,
          headlineText: 'Promote Your\nBusiness',
          bodyText:
              'Advertise your products, services and brand to the right audience',
          bottomText: 'and grow your visibility faster.',
          accentIcon: Icons.campaign_rounded,
        ),
      ],
    );
  }
}
