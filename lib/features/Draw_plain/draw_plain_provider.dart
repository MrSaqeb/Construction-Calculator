import 'package:construction_calculator/Domain/entities/draw_plain_model.dart';
import 'package:construction_calculator/Domain/repositories/draw_plain_repo.dart';
import 'package:construction_calculator/features/Draw_plain/selcetion_line_model.dart';
import 'package:construction_calculator/features/History/Data/draw_plian_repo_impl.dart';
import 'package:construction_calculator/riverpode_providers/draw_plain_notifer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository Provider
final drawRepositoryProvider = Provider<DrawRepository>((ref) {
  return DrawRepositoryImpl();
});

/// Draw Notifier Provider
// final drawNotifierProvider = StateNotifierProvider<DrawNotifier, DrawState>((
//   ref,
// ) {
//   final repo = ref.watch(drawRepositoryProvider);
//   return DrawNotifier();
// });

final selectedColorProvider = StateProvider<Color>((ref) => Colors.black);
final selectedWidthProvider = StateProvider<double>((ref) => 2.0);

final drawNotifierProvider = StateNotifierProvider<DrawNotifier, DrawState>((
  ref,
) {
  return DrawNotifier();
});

/// Draw Mode Provider (pen, eraser, select)
final drawModeProvider = StateProvider<String>((ref) => "draw");

/// ✅ Line Selection Provider (for selecting individual rectangle lines)
final lineSelectionProvider = ChangeNotifierProvider<LineSelectionModel>((ref) {
  return LineSelectionModel();
});

/// ✅ Track whether background picker layer should be shown
final showBackgroundPickerProvider = StateProvider<bool>((ref) => false);

/// ✅ selected background color store karega
final backgroundColorProvider = StateProvider<Color>(
  (ref) => Colors.transparent,
);

// Current stroke color & width for freehand drawing
final freehandStrokeColorProvider = StateProvider<Color>((ref) => Colors.black);
final freehandStrokeWidthProvider = StateProvider<double>((ref) => 1.0);

/// ✅ New provider for color layer visibility
final isColorLayerVisibleProvider = StateProvider<bool>((ref) => false);
final currentStrokeProvider = StateProvider<List<Offset>>((ref) => []);

/// Global Color (if multiple widgets use it)
final globalFreehandColorProvider = StateProvider<Color>((ref) => Colors.black);

/// Current Stroke (for tracking ongoing freehand stroke)
final currentFreehandStrokeProvider = StateProvider<List<Offset>>((ref) => []);
// ===== DrawMode ke strokes ke liye =====
// DrawMode ke liye ek hi color provider
final drawModeStrokeColorProvider = StateProvider<Color>((ref) => Colors.black);
final drawModeStrokeWidthProvider = StateProvider<double>((ref) => 1.0);
final drawModeCurrentStrokeProvider = StateProvider<List<Offset>>((ref) => []);
// New provider for Draw Mode stroke color
final drawStrokeColorProvider = StateProvider<Color>((ref) => Colors.black);

// Optional: stroke width provider
final drawStrokeWidthProvider = StateProvider<double>((ref) => 2.0);
