import 'package:flutter/material.dart';

class LineSelectionModel extends ChangeNotifier {
  int? selectedLineIndex;

  // ✅ colors/strokes ab global rakho per square nahi
  List<Color> lineColors = [
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
  ];
  List<double> lineStrokes = [3.0, 3.0, 3.0, 3.0];

  void selectLine(int? index) {
    selectedLineIndex = index;
    notifyListeners();
  }

  void updateColor(Color color) {
    if (selectedLineIndex != null) {
      lineColors[selectedLineIndex!] = color;
      notifyListeners();
    }
  }

  void updateStroke(double stroke) {
    if (selectedLineIndex != null) {
      lineStrokes[selectedLineIndex!] = stroke;
      notifyListeners();
    }
  }

  bool get hasSelection => selectedLineIndex != null;

  // ✅ sirf selection reset karo
  void resetSelection() {
    selectedLineIndex = null;
    notifyListeners();
  }
}
