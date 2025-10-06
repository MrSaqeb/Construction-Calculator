// import 'package:construction_calculator/Domain/entities/patch_roll.dart';
// import 'package:flutter/material.dart';

// class BubblePainter extends CustomPainter {
//   final PitchRoll data;

//   BubblePainter(this.data);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);

//     // settings
//     const strokeWidth = 2.0;
//     const centerCircleRadius = 25.0; // 🔹 thoda bada
//     const bubbleRadius = 22.0;
//     final circlePadding = size.width * 0.03; // screen width ka 3% padding
//     final radius = size.width / 1.7 - circlePadding;

//     // paints
//     final circlePaint = Paint()
//       ..color = Colors.orange
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth;

//     final fillPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     final bubblePaint = Paint()..color = Colors.orange;

//     // 🔸 White background inside outer circle
//     canvas.drawCircle(center, radius, fillPaint);

//     // 🔸 Outer orange circle border
//     canvas.drawCircle(center, radius, circlePaint);

//     // 🔸 Vertical line (cut at center circle)
//     canvas.drawLine(
//       Offset(center.dx, center.dy - radius),
//       Offset(center.dx, center.dy - centerCircleRadius),
//       circlePaint,
//     );
//     canvas.drawLine(
//       Offset(center.dx, center.dy + centerCircleRadius),
//       Offset(center.dx, center.dy + radius),
//       circlePaint,
//     );

//     // 🔸 Horizontal line (cut at center circle)
//     canvas.drawLine(
//       Offset(center.dx - radius, center.dy),
//       Offset(center.dx - centerCircleRadius, center.dy),
//       circlePaint,
//     );
//     canvas.drawLine(
//       Offset(center.dx + centerCircleRadius, center.dy),
//       Offset(center.dx + radius, center.dy),
//       circlePaint,
//     );

//     // 🔸 Bigger static center circle (white fill + orange border)
//     canvas.drawCircle(center, centerCircleRadius, fillPaint); // white fill
//     canvas.drawCircle(center, centerCircleRadius, circlePaint); // orange border

//     // 🔸 Bubble movement calculation
//     final offsetX = (data.roll / 30) * radius;
//     final offsetY = (data.pitch / 30) * radius;

//     final distance = Offset(offsetX, offsetY).distance;
//     Offset finalOffset;
//     if (distance > (radius - bubbleRadius)) {
//       // normalize vector and clamp
//       final scale = (radius - bubbleRadius) / distance;
//       finalOffset = Offset(offsetX * scale, offsetY * scale);
//     } else {
//       finalOffset = Offset(offsetX, offsetY);
//     }

//     final bubbleCenter = Offset(
//       center.dx + finalOffset.dx,
//       center.dy + finalOffset.dy,
//     );

//     // 🔸 Moving bubble
//     canvas.drawCircle(bubbleCenter, bubbleRadius, bubblePaint);
//   }

//   @override
//   bool shouldRepaint(covariant BubblePainter oldDelegate) {
//     return oldDelegate.data.pitch != data.pitch ||
//         oldDelegate.data.roll != data.roll;
//   }
// }
import 'package:construction_calculator/Domain/entities/patch_roll.dart';
import 'package:flutter/material.dart';

class BubblePainter extends CustomPainter {
  final PitchRoll data;
  final String viscosity; // 👈 add viscosity

  BubblePainter(this.data, {required this.viscosity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // settings
    const strokeWidth = 2.0;
    const centerCircleRadius = 25.0;
    const bubbleRadius = 22.0;
    final circlePadding = size.width * 0.03;
    final radius = size.width / 1.7 - circlePadding;

    // paints
    final circlePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final bubblePaint = Paint()..color = Colors.orange;

    // background
    canvas.drawCircle(center, radius, fillPaint);
    canvas.drawCircle(center, radius, circlePaint);

    // cross lines
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      circlePaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      circlePaint,
    );

    // center circle
    canvas.drawCircle(center, centerCircleRadius, fillPaint);
    canvas.drawCircle(center, centerCircleRadius, circlePaint);

    // 🔹 Bubble movement calculation
    final offsetX = (data.roll / 30) * radius;
    final offsetY = (data.pitch / 30) * radius;

    final distance = Offset(offsetX, offsetY).distance;

    Offset finalOffset;
    if (distance > (radius - bubbleRadius)) {
      final scale = (radius - bubbleRadius) / distance;
      finalOffset = Offset(offsetX * scale, offsetY * scale);
    } else {
      finalOffset = Offset(offsetX, offsetY);
    }

    // 🔹 viscosity effect
    double factor;
    switch (viscosity) {
      case "Low":
        factor = 1.0; // tez move
        break;
      case "Medium":
        factor = 0.6;
        break;
      case "High":
        factor = 0.3; // dheere move
        break;
      default:
        factor = 1.0;
    }

    final bubbleCenter = Offset(
      center.dx + finalOffset.dx * factor,
      center.dy + finalOffset.dy * factor,
    );

    // bubble draw
    canvas.drawCircle(bubbleCenter, bubbleRadius, bubblePaint);
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) {
    return oldDelegate.data.pitch != data.pitch ||
        oldDelegate.data.roll != data.roll ||
        oldDelegate.viscosity != viscosity;
  }
}
