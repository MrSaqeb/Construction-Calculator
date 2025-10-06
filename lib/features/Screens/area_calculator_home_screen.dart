import 'dart:io';
import 'package:construction_calculator/Core/Widgets/home_manubuttion.dart';
import 'package:construction_calculator/features/Screens/arch_calcualtor.dart';
import 'package:construction_calculator/features/Screens/circle_area_calculator.dart';
import 'package:construction_calculator/features/Screens/hemisphare_calculator.dart';
import 'package:construction_calculator/features/Screens/lshape_calculator.dart';
import 'package:construction_calculator/features/Screens/parallelpgram_calculator.dart';
import 'package:construction_calculator/features/Screens/quadilateral_calculator.dart';
import 'package:construction_calculator/features/Screens/rectangle_calculator_screen.dart';
import 'package:construction_calculator/features/Screens/rectangletopslot_calculator.dart';
import 'package:construction_calculator/features/Screens/sector_calculator.dart';
import 'package:construction_calculator/features/Screens/square_caculator.dart';
import 'package:construction_calculator/features/Screens/triangle_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Central routes map (New for Geometry Calculators)
final geometryRouteMapProvider = Provider<Map<String, Widget>>((ref) {
  return {
    "Circle Area": const CircleConverter(),
    "Rectangle Area": const RectangleConverter(),
    "Triangle Area": const TriangleCalculator(),
    "Square Area": const SquareConverter(),
    "Parallelogram Area": const ParallelpgramCalculator(),
    "Sector Area": const SectorAreaCalculatorScreen(),
    "Quadrilateral Area": const QuadilateralCalculator(),
    "Arch Area": const ArchConverter(),
    "Hemisphare Area": const HemisphareCalculator(),
    "L Shape Area": const LShapeCalculator(),
    "Top Slot Area": const RectangleTopSlotCalculator(),
  };
});

/// Categories data with routes (New)
final geometryCategoryDataProvider = Provider<List<Map<String, dynamic>>>((
  ref,
) {
  return [
    {
      "icon": "assets/icons/circle_icon.svg",
      "label": "Circle",
      "route": "Circle Area",
    },
    {
      "icon": "assets/icons/rectangle_icon.svg",
      "label": "Rectangle",
      "route": "Rectangle Area",
    },
    {
      "icon": "assets/icons/triangle_icon.svg",
      "label": "Triangle",
      "route": "Triangle Area",
    },
    {
      "icon": "assets/icons/square_icon.svg",
      "label": "Square",
      "route": "Square Area",
    },
    {
      "icon": "assets/icons/parallelogram_icon.svg",
      "label": "Parallelogram",
      "route": "Parallelogram Area",
    },
    {
      "icon": "assets/icons/quadrilateral_icon.svg",
      "label": "Quadilateral",
      "route": "Quadrilateral Area",
    },
    {
      "icon": "assets/icons/arch_icon.svg",
      "label": "Arch",
      "route": "Arch Area",
    },
    {
      "icon": "assets/icons/hemisphare_icon.svg",
      "label": "Hemisphare",
      "route": "Hemisphare Area",
    },
    {
      "icon": "assets/icons/l_shape_icon.svg",
      "label": "L Shape",
      "route": "L Shape Area",
    },
    {
      "icon": "assets/icons/top_slot_icon.svg",
      "label": "Top Slot Rec",
      "route": "Top Slot Area",
    },
    {
      "icon": "assets/icons/sector_icon.svg",
      "label": "Sector",
      "route": "Sector Area",
    },
  ];
});

class AreaCalculatorHomeScreen extends ConsumerWidget {
  const AreaCalculatorHomeScreen({super.key});
  final Color orangeColor = const Color(0xFFFF9C00);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final routeMap = ref.watch(geometryRouteMapProvider);
    final categories = ref.watch(geometryCategoryDataProvider);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: orangeColor,
        leading: IconButton(
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Area Calculator",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 15,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];
            return HomeMenuButton(
              icon: item['icon'],
              label: item['label'] as String,
              isDark: isDark,

              iconSize: 50.0, // 👈 sabhi categories ka icon thoda bara
              onPressed: () {
                final routeName = item['route'] as String?;
                if (routeName != null && routeMap.containsKey(routeName)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => routeMap[routeName]!),
                  );
                } else {
                  debugPrint("${item['label']} clicked");
                }
              },
            );
          },
        ),
      ),
    );
  }
}
