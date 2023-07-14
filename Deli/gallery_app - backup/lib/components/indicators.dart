import 'package:flutter/material.dart';
import 'package:gallery_app/style.dart/style.dart';

class SlideIndicators extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final int currentIndex;
  final int itemCount;
  final Color activeColor;
  final Color inactiveColor;

  const SlideIndicators({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.currentIndex,
    required this.itemCount,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: screenWidth * 0.3,
        height: screenHeight * 0.05,
        child: Center(
          child: Text(
            '${currentIndex + 1}/$itemCount',
            style: quickAlertConfirm,
          ),
        ));
  }
}

// Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List<Widget>.generate(
//         itemCount,
//         (index) {
//           return Container(
//             width: 10,
//             height: 10,
//             margin: const EdgeInsets.symmetric(horizontal: 4),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: currentIndex == index ? activeColor : inactiveColor,
//             ),
//           );
//         },
//       ),
//     );