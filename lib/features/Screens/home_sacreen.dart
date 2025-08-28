import 'package:construction_calculator/Core/Widgets/home_manubuttion.dart';
import 'package:construction_calculator/features/Screens/construction_calculator.dart';
import 'package:construction_calculator/features/Screens/setting_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // detect theme

    final List<Map<String, dynamic>> menuItems = [
      {
        "icon": Icons.calculate_outlined,
        "label": "Construction Calculator",
        "onPressed": () {
          // Function bana kar andar navigation rakho
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ConstructionCalculatorScreen(),
            ),
          );
        },
      },
      {
        "icon": 'assets/icons/area_calculator_icon.svg',
        "label": "Area Calculator",
        "onPressed": () => debugPrint('Navigate to Area Calculator'),
      },
      {
        "icon": Icons.draw_outlined,
        "label": "Draw your Plan",
        "onPressed": () => debugPrint('Navigate to Draw your Plan'),
      },
      {
        "icon": 'assets/icons/bubble.svg',
        "label": "Bubble Level",
        "onPressed": () => debugPrint('Navigate to Bubble Level'),
      },
      {
        "icon": 'assets/icons/ruler_scale.svg',
        "label": "Ruler Scales",
        "onPressed": () => debugPrint('Navigate to Ruler Scales'),
      },
      {
        "icon": 'assets/icons/tank_volume_calculator_icon.svg',
        "label": "Tank Volume Calculator",
        "onPressed": () => debugPrint('Navigate to Tank Volume Calculator'),
      },
      {
        "icon": 'assets/icons/saved_plans_icon.svg',
        "label": "Saved Plans",
        "onPressed": () => debugPrint('Navigate to Saved Plans'),
      },
      {
        "icon": 'assets/icons/floor_plan_icon.svg',
        "label": "Floor Plan",
        "onPressed": () => debugPrint('Navigate to Floor Plan'),
      },
      {
        "icon": Icons.receipt_long_outlined,
        "label": "Invoices Reports",
        "onPressed": () => debugPrint('Navigate to Invoices Reports'),
      },
      {
        "icon": 'assets/icons/construction_notes_icon.svg',
        "label": "Construction Notes",
        "onPressed": () => debugPrint('Navigate to Construction Notes'),
      },
      {
        "icon": 'assets/icons/geotechnical_eng_icon.svg',
        "label": "Geotechnical Engineering",
        "onPressed": () => debugPrint('Navigate to Geotechnical Engineering'),
      },
      {
        "icon": Icons.menu_book_outlined,
        "label": "Application Guides",
        "onPressed": () => debugPrint('Navigate to Application Guides'),
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Settings Icon
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingScreen()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFFF9C00),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Styled Title
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black,
                    fontFamily: 'Poppins',
                  ),
                  children: [
                    const TextSpan(text: 'Finally, an '),
                    const TextSpan(
                      text: 'Construction Calculator',
                      style: TextStyle(
                        color: Color(0xFFFF9C00),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: ' App That Speaks Construction.'),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              Text(
                'Your Construction Companion.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),

              // Grid of HomeMenuButtons
              Expanded(
                child: GridView.builder(
                  itemCount: menuItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 28,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return HomeMenuButton(
                      icon: item['icon'],
                      label: item['label'],
                      onPressed: item['onPressed'],
                      isDark: isDark, // pass the dark mode flag here
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
