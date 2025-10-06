import 'dart:io';
import 'package:construction_calculator/Core/Widgets/home_manubuttion.dart';
import 'package:construction_calculator/features/Screens/Vertical_elliptical.dart';
import 'package:construction_calculator/features/Screens/cone_bottom.dart';
import 'package:construction_calculator/features/Screens/cone_top.dart';
import 'package:construction_calculator/features/Screens/frustum_cal.dart';
import 'package:construction_calculator/features/Screens/horizontal_capsule.dart';
import 'package:construction_calculator/features/Screens/horizontal_cylinder.dart';
import 'package:construction_calculator/features/Screens/horizontal_elliptical.dart';
import 'package:construction_calculator/features/Screens/rectangular_prism_cal.dart';
import 'package:construction_calculator/features/Screens/vertical_capsule.dart';
import 'package:construction_calculator/features/Screens/vertical_cylinder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Central routes map (New for Geometry Calculators)
final geometryRouteMapProvider = Provider<Map<String, Widget>>((ref) {
  return {
    "Vertical Cylinder": const VerticalCylinderScreen(),
    "Horizontal Cylinder": const HorizontalCylinder(),
    "Rectangular Prism": const RectangularPrismCal(),
    "Vertical Capsule": const VerticalCapsule(),
    "Horizontal Capsule": const HorizontalCapsule(),
    "Vertical Elliptical": VerticalElliptical(),
    "Horizontal Elliptical": const HorizontalElliptical(),
    "Cone Bottom": const ConeBottom(),
    "Cone Top": const ConeTop(),
    "Frustum": const FrustumCal(),
  };
});

/// Categories data with aligned routes
final geometryCategoryDataProvider = Provider<List<Map<String, dynamic>>>((
  ref,
) {
  return [
    {
      "icon": "assets/icons/Vector.svg",
      "label": "Vertical Cylinder",
      "route": "Vertical Cylinder",
    },
    {
      "icon": "assets/icons/horizontal.svg",
      "label": "Horizontal Cylinder",
      "route": "Horizontal Cylinder",
    },
    {
      "icon": "assets/icons/tankrectangle.svg",
      "label": "Rectangular Prism",
      "route": "Rectangular Prism",
    },
    {
      "icon": "assets/icons/vertical_capsule_icon.svg",
      "label": "Vertical Capsule",
      "route": "Vertical Capsule",
    },
    {
      "icon": "assets/icons/horizontal_capsule_icon.svg",
      "label": "Horizontal Capsule",
      "route": "Horizontal Capsule",
    },
    {
      "icon": "assets/icons/vertical_elliptical_icon.svg",
      "label": "Vertical Elliptical",
      "route": "Vertical Elliptical",
    },
    {
      "icon": "assets/icons/horizontal_elliptical_icon.svg",
      "label": "Horizontal Elliptical",
      "route": "Horizontal Elliptical",
    },
    {
      "icon": "assets/icons/cone_bottom_icon.svg",
      "label": "Cone Bottom",
      "route": "Cone Bottom",
    },
    {
      "icon": "assets/icons/cone_top_icon.svg",
      "label": "Cone Top",
      "route": "Cone Top",
    },
    {
      "icon": "assets/icons/frustum_icon.svg",
      "label": "Frustum",
      "route": "Frustum",
    },
  ];
});

class TankVolumeHomeScreen extends ConsumerWidget {
  const TankVolumeHomeScreen({super.key});
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
          "Tank Volume Calculator",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 19,
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

              iconSize: 33, // 👈 sabhi categories ka icon thoda bara
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
