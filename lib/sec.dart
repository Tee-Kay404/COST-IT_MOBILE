// import 'package:cost_it_mobile/stuff.dart';
// import 'package:flutter/material.dart';

// class Sec extends StatefulWidget {
//   const Sec({super.key});

//   @override
//   State<Sec> createState() => _SecState();
// }

// class _SecState extends State<Sec> {
//   Widget? activeScreen;

//   @override
//   void initState() {
//     activeScreen = Lift(switchScreen);
//     super.initState();
//   }

//   void switchScreen() {
//     setState(() {
//       activeScreen = Sec();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.red,
//       body: Column(
//         children: [
//           TextButton(
//             onPressed: switchScreen,
//             child: Text('Screen 2', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }
