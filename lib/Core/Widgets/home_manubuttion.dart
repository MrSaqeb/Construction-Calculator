// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class HomeMenuButton extends StatelessWidget {
//   final dynamic icon;
//   final String label;
//   final VoidCallback onPressed;
//   final bool isDark;
//   final bool isSelected; // yeh optional banega

//   const HomeMenuButton({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.onPressed,
//     required this.isDark,
//     this.isSelected = false, required Color textColor, // default value false
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     final Color iconAndBorderColor = isSelected
//         ? Colors.white
//         : const Color(0xFFFF9C00);
//     final Color fillColor = isSelected
//         ? const Color(0xFFFF9C00)
//         : Colors.transparent;
//     final Color textColor = isDark ? Colors.white : Colors.black;

//     return GestureDetector(
//       onTap: onPressed,
//       child: SizedBox(
//         height: screenHeight * 0.12,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Icon container
//             Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: fillColor,
//                 border: Border.all(
//                   color: iconAndBorderColor,
//                   width: screenWidth * 0.005,
//                 ),
//               ),
//               padding: EdgeInsets.all(screenWidth * 0.025),
//               child: icon is IconData
//                   ? Icon(
//                       icon,
//                       color: iconAndBorderColor,
//                       size: screenWidth * 0.07,
//                     )
//                   : SvgPicture.asset(
//                       icon,
//                       width: screenWidth * 0.07,
//                       height: screenWidth * 0.07,
//                       color: iconAndBorderColor,
//                     ),
//             ),

//             SizedBox(height: screenHeight * 0.005),

//             // Label
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: screenWidth * 0.031,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Poppins',
//                 height: 1.2,
//                 color: textColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeMenuButton extends StatelessWidget {
  final dynamic icon;
  final String label;
  final VoidCallback onPressed;
  final bool isDark;
  final bool isSelected;
  final double? iconSize; // optional icon size
  final double? circleRadius; // optional circle radius

  const HomeMenuButton({
    this.circleRadius,
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.isDark,
    this.isSelected = false,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final Color iconAndBorderColor = isSelected
        ? Colors.white
        : const Color(0xFFFF9C00);
    final Color fillColor = isSelected
        ? const Color(0xFFFF9C00)
        : Colors.transparent;
    final Color textColor = isDark ? Colors.white : Colors.black;

    // agar user ne iconSize diya hai to wahi use hoga, warna default
    final double effectiveIconSize = iconSize ?? screenWidth * 0.07;

    // agar user ne circleRadius diya hai to wahi use hoga, warna default
    final double effectiveCircleSize = circleRadius ?? screenWidth * 0.18;

    return GestureDetector(
      onTap: () {
        debugPrint("Clicked $label");
        onPressed();
      },
      child: SizedBox(
        height: screenHeight * 0.15, // thoda zyada space circle ke liye
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: effectiveCircleSize,
              height: effectiveCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fillColor,
                border: Border.all(
                  color: iconAndBorderColor,
                  width: screenWidth * 0.005,
                ),
              ),
              child: Center(
                child: icon is IconData
                    ? Icon(
                        icon,
                        color: iconAndBorderColor,
                        size: effectiveIconSize,
                      )
                    : SvgPicture.asset(
                        icon,
                        width: effectiveIconSize,
                        height: effectiveIconSize,
                        color: iconAndBorderColor,
                      ),
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            // Label
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenWidth * 0.031,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                height: 1.2,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
