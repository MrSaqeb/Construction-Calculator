// ignore_for_file: deprecated_member_use

import 'package:construction_calculator/Core/Widgets/home_manubuttion.dart';
import 'package:construction_calculator/features/Screens/Excavation_calculation.dart';
import 'package:construction_calculator/features/Screens/T_bar_calculator.dart';
import 'package:construction_calculator/features/Screens/air_condition_calculator.dart';
import 'package:construction_calculator/features/Screens/angle_unit_converter.dart';
import 'package:construction_calculator/features/Screens/anti_termite_calculator.dart';
import 'package:construction_calculator/features/Screens/area_unit_converter.dart';
import 'package:construction_calculator/features/Screens/beam_steal_calculator.dart';
import 'package:construction_calculator/features/Screens/boundary_wall_calculator.dart';
import 'package:construction_calculator/features/Screens/bricks_calculation.dart';
import 'package:construction_calculator/features/Screens/carpet_area_calculator.dart';
import 'package:construction_calculator/features/Screens/cement_concrete%20calcilator.dart';
import 'package:construction_calculator/features/Screens/channel_bar_calculator.dart';
import 'package:construction_calculator/features/Screens/civil_unit_calculator.dart';
import 'package:construction_calculator/features/Screens/concrete_tube_calculator.dart';
import 'package:construction_calculator/features/Screens/concreteblock_calculator.dart';
import 'package:construction_calculator/features/Screens/construction_cost.dart';
import 'package:construction_calculator/features/Screens/distance_unit_converter.dart';
import 'package:construction_calculator/features/Screens/flooring_calcilator.dart';
import 'package:construction_calculator/features/Screens/frequency_unit_converter.dart';
import 'package:construction_calculator/features/Screens/fule_unit_converter.dart';
import 'package:construction_calculator/features/Screens/kitchen_platform_calculator.dart';
import 'package:construction_calculator/features/Screens/mass_converter_calculator.dart';
import 'package:construction_calculator/features/Screens/paint_calculator.dart';
import 'package:construction_calculator/features/Screens/plaster_calculator.dart';
import 'package:construction_calculator/features/Screens/plywood_sheet_calculator.dart';
import 'package:construction_calculator/features/Screens/pressure_unit_converter.dart';
import 'package:construction_calculator/features/Screens/roofpitch-calculatior.dart';
import 'package:construction_calculator/features/Screens/round_column_calculator.dart';
import 'package:construction_calculator/features/Screens/round_pipe_calculator.dart';
import 'package:construction_calculator/features/Screens/round_steal_weight_calculator.dart';
import 'package:construction_calculator/features/Screens/solar_rooftop_calculator.dart';
import 'package:construction_calculator/features/Screens/solor_water_heater_calculator.dart';
import 'package:construction_calculator/features/Screens/speed_unit_converter.dart';
import 'package:construction_calculator/features/Screens/sqaure_bar_calculator.dart';
import 'package:construction_calculator/features/Screens/stairs_case_calculator.dart';
import 'package:construction_calculator/features/Screens/steal_weight_calculator.dart';
import 'package:construction_calculator/features/Screens/still_quantity_calulator.dart';
import 'package:construction_calculator/features/Screens/time_unit_converter_calculator.dart';
import 'package:construction_calculator/features/Screens/top_soil_calculator.dart';
import 'package:construction_calculator/features/Screens/volume_unit_converter_calculator.dart';
import 'package:construction_calculator/features/Screens/water_sumpcalculator.dart';
import 'package:construction_calculator/features/Screens/weight_unit_converter_calculator.dart';
import 'package:construction_calculator/features/Screens/woodframe_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Providers
final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedMainMenuIndexProvider = StateProvider<int>((ref) => 0);

/// Central routes map
final routeMapProvider = Provider<Map<String, Widget>>((ref) {
  return {
    // Quantity tab
    "Construction Cost": const ConstructionCostScreen(),
    "Brick": BrickCalculationScreen(),
    "Cement Concrete": CementCalculatorScreen(),
    "Plastering": PlasterCalculatorScreen(),
    "Concrete Block": ConcreteBlockCalculationScreen(),
    "Boundary Wall": BoundaryWallCalculatorScreen(),
    "Flooring": FlooringCalculatorScreen(),
    "Kitchen Platform": KitchenPlatformCalculator(),
    "Water Sump": WaterSumpCalculatorScreen(),
    "Air Conditioner": AirConditionCalculatorScreen(),
    "Solar Rooftop": SolorCalculatorScreen(),
    "Solar Water Heater": SolorwaterheaterCalculatorScreen(),
    "Paint Work": PaintCalculationScreen(),
    "Excavation": ExcavationCalculationScreen(),
    "Wood Frame": WoodFrameCalculationScreen(),
    "Plywood Sheets": PlywoodSheetScreen(),
    "Anti Termite": AntiTermiteCalculatorScreen(),
    "Round Column": ColumnCalculatorScreen(),
    "Stair Case": StairCalculatorScreen(),
    "Top Soil": TopSoilCalculator(),
    "Civil Unit": UnitConversionCalculator(),
    "Concrete Tube": ConcreteTubeCalculatorScreen(),
    "Roof Pitch": RoofPitchCalculator(),
    "Carpet Area": CarpetAreaCalculator(),

    // Metal tab
    "Steel Quantity": StillQuantityCalulator(),
    "Steel Weight": StealWeightCalculator(),
    "Beam Steel": BeamStealCalculator(),
    "Round Bar": RoundStealCalculator(),
    "Round Pipe": RoundPipeCalculator(),
    "Channel Bar": ChannelBarCalculator(),
    "T Bar": TBarCalculator(),
    "Square Bar": SqaureBarCalculator(),

    // Converter tab
    "Distance": DistanceUnitConverter(),
    "Area": AreaUnitConverter(),
    "Volume": VolumeUnitConverter(),
    "Weight": WeightUnitConverter(),
    "Time": TimeUnitConverter(),
    "Mass": MassUnitConverter(),
    "Pressure": PressureUnitConverter(),
    "Speed": SpeedUnitConverter(),
    "Fuel": FuelUnitConverter(),
    "Frequency": FrequencyUnitConverter(),
    "Angle": AngleUnitConverter(),
  };
});

/// Categories data with routes
final categoryDataProvider = Provider<List<List<Map<String, dynamic>>>>((ref) {
  return [
    // Quantity tab
    [
      {
        "icon": "assets/icons/construction_cost_icon.svg",
        "label": "Construction Cost",
        "route": "Construction Cost",
      },
      {
        "icon": "assets/icons/brick_icon.svg",
        "label": "Brick",
        "route": "Brick",
      },
      {
        "icon": "assets/icons/cement_concrete_icon.svg",
        "label": "Cement Concrete",
        "route": "Cement Concrete",
      },
      {
        "icon": "assets/icons/plastering_icon.svg",
        "label": "Plastering",
        "route": "Plastering",
      },
      {
        "icon": "assets/icons/concrete_block_icon.svg",
        "label": "Concrete Block",
        "route": "Concrete Block",
      },
      {
        "icon": "assets/icons/boundary_wall_icon.svg",
        "label": "Boundary Wall",
        "route": "Boundary Wall",
      },
      {
        "icon": "assets/icons/flooring_icon.svg",
        "label": "Flooring",
        "route": "Flooring",
      },
      {
        "icon": "assets/icons/kitchen_platform_icon.svg",
        "label": "Kitchen Platform",
        "route": "Kitchen Platform",
      },
      {
        "icon": "assets/icons/water_sump_icon.svg",
        "label": "Water Sump",
        "route": "Water Sump",
      },
      {
        "icon": "assets/icons/air_conditioner_icon.svg",
        "label": "Air Conditioner",
        "route": "Air Conditioner",
      },
      {
        "icon": "assets/icons/solar_rooftop_icon.svg",
        "label": "Solar Rooftop",
        "route": "Solar Rooftop",
      },
      {
        "icon": "assets/icons/solar_water_heater_icon.svg",
        "label": "Solar Water Heater",
        "route": "Solar Water Heater",
      },
      {
        "icon": "assets/icons/paint_work_icon.svg",
        "label": "Paint Work",
        "route": "Paint Work",
      },
      {
        "icon": "assets/icons/excavation_icon.svg",
        "label": "Excavation",
        "route": "Excavation",
      },
      {
        "icon": "assets/icons/wood_frame_icon.svg",
        "label": "Wood Frame",
        "route": "Wood Frame",
      },
      {
        "icon": "assets/icons/plywood_sheets_icon.svg",
        "label": "Plywood Sheets",
        "route": "Plywood Sheets",
      },
      {
        "icon": "assets/icons/anti_termite_icon.svg",
        "label": "Anti Termite",
        "route": "Anti Termite",
      },
      {
        "icon": "assets/icons/round_column_icon.svg",
        "label": "Round Column",
        "route": "Round Column",
      },
      {
        "icon": "assets/icons/stair_case_icon.svg",
        "label": "Stair Case",
        "route": "Stair Case",
      },
      {
        "icon": "assets/icons/top_soil_icon.svg",
        "label": "Top Soil",
        "route": "Top Soil",
      },
      {
        "icon": "assets/icons/civil_unit_icon.svg",
        "label": "Civil Unit",
        "route": "Civil Unit",
      },
      {
        "icon": "assets/icons/concrete_tube_icon.svg",
        "label": "Concrete Tube",
        "route": "Concrete Tube",
      },
      {
        "icon": "assets/icons/roof_pitch_icon.svg",
        "label": "Roof Pitch",
        "route": "Roof Pitch",
      },
      {
        "icon": "assets/icons/carpet_area_icon.svg",
        "label": "Carpet Area",
        "route": "Carpet Area",
      },
    ],

    // Metal tab
    [
      {
        "icon": "assets/icons/steal_quanitity_icon.svg",
        "label": "Steel Quantity",
        "route": "Steel Quantity",
      },
      {
        "icon": "assets/icons/steal_weight_icon.svg",
        "label": "Steel Weight",
        "route": "Steel Weight",
      },
      {
        "icon": "assets/icons/beam_steal_icon.svg",
        "label": "Beam Steel",
        "route": "Beam Steel",
      },
      {
        "icon": "assets/icons/round_bar_icon.svg",
        "label": "Round Bar",
        "route": "Round Bar",
      },
      {
        "icon": "assets/icons/round_pipe_icon.svg",
        "label": "Round Pipe",
        "route": "Round Pipe",
      },
      {
        "icon": "assets/icons/channel_bar_icon.svg",
        "label": "Channel Bar",
        "route": "Channel Bar",
      },
      {
        "icon": "assets/icons/t_bar_icon.svg",
        "label": "T Bar",
        "route": "T Bar",
      },
      {
        "icon": "assets/icons/square_bar_icon.svg",
        "label": "Square Bar",
        "route": "Square Bar",
      },
    ],

    // Converter tab
    [
      {
        "icon": "assets/icons/distance_icon.svg",
        "label": "Distance",
        "route": "Distance",
      },
      {"icon": "assets/icons/area_icon.svg", "label": "Area", "route": "Area"},
      {
        "icon": "assets/icons/volume_icon.svg",
        "label": "Volume",
        "route": "Volume",
      },
      {
        "icon": "assets/icons/weight_icon.svg",
        "label": "Weight",
        "route": "Weight",
      },
      {"icon": "assets/icons/time_icon.svg", "label": "Time", "route": "Time"},
      {"icon": "assets/icons/mass_icon.svg", "label": "Mass", "route": "Mass"},
      {
        "icon": "assets/icons/pressure_icon.svg",
        "label": "Pressure",
        "route": "Pressure",
      },
      {
        "icon": "assets/icons/speed_icon.svg",
        "label": "Speed",
        "route": "Speed",
      },
      {"icon": "assets/icons/fuel_icon.svg", "label": "Fuel", "route": "Fuel"},
      {
        "icon": "assets/icons/frequency_icon.svg",
        "label": "Frequency",
        "route": "Frequency",
      },
      {
        "icon": "assets/icons/angle_icon.svg",
        "label": "Angle",
        "route": "Angle",
      },
    ],
  ];
});

class ConstructionCalculatorScreen extends ConsumerWidget {
  const ConstructionCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedIndex = ref.watch(selectedMainMenuIndexProvider);

    final allCategories = ref.watch(categoryDataProvider)[selectedIndex];
    final routeMap = ref.watch(routeMapProvider);

    final filteredCategories = searchQuery.isEmpty
        ? allCategories
        : allCategories
              .where(
                (item) => item['label'].toString().toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
              )
              .toList();

    final textColor = isDark ? Colors.white : Colors.black;
    final searchFillColor = isDark ? Colors.white30 : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Construction Calculator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFFFF9C00),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          /// Search
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              style: TextStyle(color: textColor),
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Search any item',
                hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                prefixIcon: Icon(
                  Icons.search,
                  color: textColor.withOpacity(0.7),
                ),
                filled: true,
                fillColor: searchFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(
                    color: Colors.black.withOpacity(0.4), // opacity 0.4
                    width: 0.4,
                  ),
                ),

                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: textColor),
                        onPressed: () =>
                            ref.read(searchQueryProvider.notifier).state = '',
                      )
                    : null,
              ),
            ),
          ),

          /// Menu
          SizedBox(
            height: 60,
            child: Row(
              children: List.generate(3, (index) {
                final labels = ["Quantity", "Metal", "Converter"];
                final isSelected = index == selectedIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(selectedMainMenuIndexProvider.notifier).state =
                          index;
                      ref.read(searchQueryProvider.notifier).state = '';
                    },
                    child: Container(
                      color: isSelected
                          ? const Color(0xFFFF9C00)
                          : Colors.white38,
                      alignment: Alignment.center,
                      child: Text(
                        labels[index],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFFF9C00),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          /// Categories Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: filteredCategories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final item = filteredCategories[index];
                  return HomeMenuButton(
                    icon: item['icon'],
                    label: item['label'] as String,
                    circleRadius: 60, // 👈 bara circle
                    iconSize: 35,
                    isDark: isDark,
                    onPressed: () {
                      final routeName = item['route'] as String?;
                      if (routeName != null &&
                          routeMap.containsKey(routeName)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => routeMap[routeName]!,
                          ),
                        );
                      } else {
                        debugPrint("${item['label']} clicked");
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
