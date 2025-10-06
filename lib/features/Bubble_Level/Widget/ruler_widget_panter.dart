// import 'package:flutter/material.dart';

// class RulerWidget extends StatelessWidget {
//   final int maxInches;
//   final bool isLeft;

//   const RulerWidget({super.key, required this.maxInches, this.isLeft = true});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 70,
//       color: Colors.grey.shade100,
//       child: CustomPaint(
//         size: const Size(double.infinity, double.infinity),
//         painter: _RulerPainter(maxInches: maxInches, isLeft: isLeft),
//       ),
//     );
//   }
// }

// class _RulerPainter extends CustomPainter {
//   final int maxInches;
//   final bool isLeft;

//   _RulerPainter({required this.maxInches, required this.isLeft});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.grey.shade800
//       ..strokeWidth = 1;

//     final textPainter = TextPainter(textDirection: TextDirection.ltr);
//     final inchHeight = size.height / maxInches;

//     for (int inch = 0; inch <= maxInches; inch++) {
//       double y = inch * inchHeight;

//       // Major tick (on left side)
//       double majorTickLength = size.width;
//       canvas.drawLine(Offset(0, y), Offset(majorTickLength, y), paint);

//       // Label on left side
//       textPainter.text = TextSpan(
//         text: "$inch",
//         style: TextStyle(
//           fontSize: 11,
//           color: Colors.grey.shade700,
//           fontWeight: FontWeight.w500,
//         ),
//       );
//       textPainter.layout();

//       double x = 4; // small left padding
//       textPainter.paint(canvas, Offset(x, y - textPainter.height / 2));

//       // Sub-ticks (also on left)
//       if (inch < maxInches) {
//         for (int i = 1; i < 10; i++) {
//           double subY = y + (inchHeight / 10) * i;
//           double tickLength = i % 5 == 0 ? size.width * 0.7 : size.width * 0.5;
//           canvas.drawLine(Offset(0, subY), Offset(tickLength, subY), paint);
//         }
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
// ruler_screen.dart
import 'package:flutter/material.dart';

class RulerScreen extends StatefulWidget {
  const RulerScreen({super.key});

  @override
  State<RulerScreen> createState() => _RulerScreenState();
}

class _RulerScreenState extends State<RulerScreen> {
  double leftHandle = 100; // y offset for left circle
  double rightHandle = 250; // y offset for right circle

  double maxHeight = 500; // screen ruler height

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Ruler"),
        centerTitle: false,
        backgroundColor: Colors.orange,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "CM/INCH",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Row(
          children: [
            // Left Ruler
            Expanded(child: RulerWidget(maxInches: 11, isLeft: true)),

            // Center draggable lines with handles
            Container(
              width: 120,
              color: Colors.white,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Left vertical line
                  Positioned(
                    left: 30,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 2, color: Colors.black),
                  ),
                  // Right vertical line
                  Positioned(
                    right: 30,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 2, color: Colors.black),
                  ),

                  // Left draggable circle
                  Positioned(
                    top: leftHandle,
                    left: 15,
                    child: GestureDetector(
                      onPanUpdate: (d) {
                        setState(() {
                          leftHandle += d.delta.dy;
                          leftHandle = leftHandle.clamp(0, maxHeight - 40);
                        });
                      },
                      child: _circleHandle(),
                    ),
                  ),

                  // Right draggable circle
                  Positioned(
                    top: rightHandle,
                    right: 15,
                    child: GestureDetector(
                      onPanUpdate: (d) {
                        setState(() {
                          rightHandle += d.delta.dy;
                          rightHandle = rightHandle.clamp(0, maxHeight - 40);
                        });
                      },
                      child: _circleHandle(),
                    ),
                  ),

                  // Reset button in center bottom
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          leftHandle = 100;
                          rightHandle = 250;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.refresh, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Right Ruler
            Expanded(child: RulerWidget(maxInches: 20, isLeft: false)),
          ],
        ),
      ),
    );
  }

  Widget _circleHandle() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 2),
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.unfold_more, color: Colors.orange),
    );
  }
}

// ruler_widget.dart
class RulerWidget extends StatelessWidget {
  final int maxInches;
  final bool isLeft;

  const RulerWidget({super.key, required this.maxInches, this.isLeft = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: _RulerPainter(maxInches: maxInches, isLeft: isLeft),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  final int maxInches;
  final bool isLeft;

  _RulerPainter({required this.maxInches, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final inchHeight = size.height / maxInches;

    for (int inch = 0; inch <= maxInches; inch++) {
      double y = inch * inchHeight;

      // Major tick
      double majorTickLength = 20;
      if (isLeft) {
        canvas.drawLine(
          Offset(size.width - majorTickLength, y),
          Offset(size.width, y),
          paint,
        );
      } else {
        canvas.drawLine(Offset(0, y), Offset(majorTickLength, y), paint);
      }

      // Labels
      textPainter.text = TextSpan(
        text: "$inch",
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();

      if (isLeft) {
        textPainter.paint(
          canvas,
          Offset(size.width - majorTickLength - 20, y - 6),
        );
      } else {
        textPainter.paint(canvas, Offset(majorTickLength + 4, y - 6));
      }

      // Sub-ticks
      if (inch < maxInches) {
        for (int i = 1; i < 10; i++) {
          double subY = y + (inchHeight / 10) * i;
          double tickLength = i % 5 == 0 ? 12 : 7;

          if (isLeft) {
            canvas.drawLine(
              Offset(size.width - tickLength, subY),
              Offset(size.width, subY),
              paint,
            );
          } else {
            canvas.drawLine(Offset(0, subY), Offset(tickLength, subY), paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
