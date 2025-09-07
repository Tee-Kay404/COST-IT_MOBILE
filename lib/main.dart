import 'package:cost_it_mobile/screens/onBoarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CostItApp());
}

class CostItApp extends StatelessWidget {
  const CostItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingScreen(),
    );
  }
}