// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:construction_calculator/Domain/entities/Lshape_history_item.dart';
import 'package:construction_calculator/Domain/entities/air_history_item.dart';
import 'package:construction_calculator/Domain/entities/angle_history_item.dart';
import 'package:construction_calculator/Domain/entities/anti_termite_history_item.dart';
import 'package:construction_calculator/Domain/entities/arch_history_item.dart';
import 'package:construction_calculator/Domain/entities/beam_steal_history_item.dart';
import 'package:construction_calculator/Domain/entities/boundary_wall_history_item.dart';
import 'package:construction_calculator/Domain/entities/brick_history_item.dart';
import 'package:construction_calculator/Domain/entities/cement_history_item.dart';
import 'package:construction_calculator/Domain/entities/circle_history_item.dart';
import 'package:construction_calculator/Domain/entities/civilunitconversion_history_item.dart';
import 'package:construction_calculator/Domain/entities/concrete_tube_history_item.dart';
import 'package:construction_calculator/Domain/entities/concreteblock_history_item.dart';
import 'package:construction_calculator/Domain/entities/cone_bottom_history_item.dart';
import 'package:construction_calculator/Domain/entities/cone_top_history_item.dart';
import 'package:construction_calculator/Domain/entities/construction_cost_history_item.dart';
import 'package:construction_calculator/Domain/entities/distance_history_item.dart';
import 'package:construction_calculator/Domain/entities/excavation_history_item.dart';
import 'package:construction_calculator/Domain/entities/flooring_history_item.dart';
import 'package:construction_calculator/Domain/entities/frequency_history_item.dart';
import 'package:construction_calculator/Domain/entities/frustum_history_item.dart';
import 'package:construction_calculator/Domain/entities/fuel_history_item.dart';
import 'package:construction_calculator/Domain/entities/hemisphere_history_item.dart';
import 'package:construction_calculator/Domain/entities/horizontal_capsule_item.dart';
import 'package:construction_calculator/Domain/entities/horizontal_cylinder_item.dart';
import 'package:construction_calculator/Domain/entities/horizontal_elliptical_item.dart';
import 'package:construction_calculator/Domain/entities/kitchen_history_item.dart';
import 'package:construction_calculator/Domain/entities/mass_history_item.dart';
import 'package:construction_calculator/Domain/entities/paint_history_item.dart';
import 'package:construction_calculator/Domain/entities/plaster_history_item.dart';
import 'package:construction_calculator/Domain/entities/plywood_sheet_history_item.dart';
import 'package:construction_calculator/Domain/entities/pressure_history_item.dart';
import 'package:construction_calculator/Domain/entities/rectangle_history_item.dart';
import 'package:construction_calculator/Domain/entities/rectangleslot_history_item.dart';
import 'package:construction_calculator/Domain/entities/rectangular_prism_item.dart';
import 'package:construction_calculator/Domain/entities/roof_pitch_history_item.dart';
import 'package:construction_calculator/Domain/entities/round_column_history_item.dart';
import 'package:construction_calculator/Domain/entities/round_steal_history_item.dart';
import 'package:construction_calculator/Domain/entities/sector_history_item.dart';
import 'package:construction_calculator/Domain/entities/solar_roofttop_history_item.dart';
import 'package:construction_calculator/Domain/entities/solor_waterheater_history_item.dart';
import 'package:construction_calculator/Domain/entities/speed_history_item.dart';
import 'package:construction_calculator/Domain/entities/square_bar_history_item.dart';
import 'package:construction_calculator/Domain/entities/stair_history_item.dart';
import 'package:construction_calculator/Domain/entities/steal_we_history_item.dart';
import 'package:construction_calculator/Domain/entities/steal_weight_history_item.dart';
import 'package:construction_calculator/Domain/entities/time_history_item.dart';
import 'package:construction_calculator/Domain/entities/topsoil_history_item.dart';
import 'package:construction_calculator/Domain/entities/vertical_capsule_item.dart';
import 'package:construction_calculator/Domain/entities/vertical_cylinder_item.dart';
import 'package:construction_calculator/Domain/entities/vertical_elliptical_item.dart';
import 'package:construction_calculator/Domain/entities/water_sump_history_item.dart';
import 'package:construction_calculator/Domain/entities/wood_frame_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:construction_calculator/Core/theme/app_fonts.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final Map<int, bool> expandedCards = {}; // Track expanded state per card

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final history = ref.watch(unifiedHistoryProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("History", style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline_outlined,
              color: Colors.white,
            ),
            onPressed: () => _showDeleteAllConfirmation(context),
          ),
        ],
      ),
      body: history.isEmpty
          ? Center(
              child: Text(
                "No history yet",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return _buildHistoryCard(item, index);
              },
            ),
    );
  }

  Widget _buildHistoryCard(HistoryItem item, int index) {
    final theme = Theme.of(context);
    final isExpanded = expandedCards[index] ?? false;

    bool hasConstructionData = item.type == "construction";
    bool hasBrickData = item.type == "brick";
    bool hasCementData = item.type == "cement";
    bool hasPlasterData = item.type == "plaster";
    bool hasConcreteBlockData = item.type == "concreteBlock";
    bool hasBoundaryWallData = item.type == "boundaryWall";
    bool hasflooringData = item.type == "flooring";
    bool haskitchenData = item.type == "kitchen";
    bool haswaterData = item.type == "water_sump_history";
    bool hasacData = item.type == "air_history";
    bool hassolorData = item.type == "solar_rooftop_history";
    bool hassolorwaterData = item.type == "solar_waterheater_history";
    bool haspaintData = item.type == "paint_history";
    bool hasexcavationData = item.type == "excavation_history";
    bool haswoodframeData = item.type == "wood_frame_history";
    bool hasplysheetData = item.type == "plywood_sheet_history";
    bool hasantitermiteData = item.type == "anti_termite_history";
    bool hasroundcolumnData = item.type == "round_column_history";
    bool hasstairData = item.type == "stair_case_history";
    bool hastopsoilData = item.type == "topsoil_history";
    bool hastubeData = item.type == "concrete_tube_history";
    bool hasroofpitchData = item.type == "roof_pitch_history";
    bool hascivilunitData = item.type == "civil_unit_history";
    bool hasstealData = item.type == "steal_history";
    bool hassteelData = item.type == "steal_weight_history";
    bool hasbeamData = item.type == "beam_history";
    bool hasroundData = item.type == "round_history";
    bool hassqbarData = item.type == "square_bar_history";
    bool hasdistanceData = item.type == "distance_history";

    bool hasTimeData = item.type == "time_history";
    bool hasMassData = item.type == "mass_history";
    bool hasPressureData = item.type == "pressure_history";
    bool hasFrequencyData = item.type == "frequency_history";
    bool hasAngleData = item.type == "angle_history";
    bool hasFuelData = item.type == "fuel_history";
    bool hasspeedData = item.type == "speed_history";
    bool hascircledata = item.type == "circle_history";
    bool hasRectangleData = item.type == "rectangle_history";
    bool hasLShapeData = item.type == "lshape_history";
    bool hasHemisphereData = item.type == "hemisphere_history";
    bool hasSectorData = item.type == "sector_history";
    bool hasArchData = item.type == "arch_history";
    bool hasRectangleSlotData = item.type == "rectangle_slot_history";
    bool hasverticalData = item.type == "vertical_cylinder_history";
    bool hasHorizontalCylinderData = item.type == "horizontal_cylinder_history";
    bool hasRectangularPrismData = item.type == "rectangular_prism_history";
    bool hasVerticalCapsuleData = item.type == "vertical_capsule_history";
    bool hasHorizontalCapsuleData = item.type == "horizontal_capsule_history";
    bool hasVerticalEllipticalData = item.type == "vertical_elliptical_history";
    bool hasHorizontalEllipticalData =
        item.type == "horizontal_elliptical_history";
    bool hasConeBottomData = item.type == "cone_bottom_history";
    bool hasConeTopData = item.type == "cone_top_history";
    bool hasFrustumData = item.type == "frustum_history";

    String cardTitle;
    String iconPath;

    if (hasConstructionData) {
      cardTitle = "Construction Cost";
      iconPath = 'assets/icons/construction_cost_icon.svg';
    } else if (hasBrickData) {
      cardTitle = "Brick Calculator";
      iconPath = 'assets/icons/brick_icon.svg';
    } else if (hasCementData) {
      cardTitle = "Cement Calculator";
      iconPath = 'assets/icons/cement_concrete_icon.svg';
    } else if (hasPlasterData) {
      cardTitle = "Plaster Calculator";
      iconPath = 'assets/icons/plastering_icon.svg';
    } else if (hasConcreteBlockData) {
      cardTitle = "Concrete Block Calculator";
      iconPath = 'assets/icons/concrete_block_icon.svg';
    } else if (hasBoundaryWallData) {
      cardTitle = "Boundary Wall";
      iconPath = 'assets/icons/boundary_wall_icon.svg';
    } else if (hasflooringData) {
      cardTitle = "Flooring Calculator";
      iconPath = 'assets/icons/flooring_icon.svg';
    } else if (haskitchenData) {
      cardTitle = "Kitchen Platform Calculator";
      iconPath = 'assets/icons/kitchen_platform_icon.svg';
    } else if (haswaterData) {
      cardTitle = "Water-Sump Calculation";
      iconPath = 'assets/icons/water_sump_icon.svg';
    } else if (hasacData) {
      cardTitle = "AC Calculation";
      iconPath = 'assets/icons/air_conditioner_icon.svg';
    } else if (hassolorData) {
      cardTitle = "Solor Rooftop Calculation";
      iconPath = 'assets/icons/solar_rooftop_icon.svg';
    } else if (hassolorwaterData) {
      cardTitle = "Solor Water Heater Calculation";
      iconPath = 'assets/icons/solar_water_heater_icon.svg';
    } else if (haspaintData) {
      cardTitle = "Paint Calculation";
      iconPath = 'assets/icons/paint_work_icon.svg';
    } else if (hasexcavationData) {
      cardTitle = "Excavation Calculation";
      iconPath = 'assets/icons/excavation_icon.svg';
    } else if (haswoodframeData) {
      cardTitle = "Wood Frame Calculation";
      iconPath = 'assets/icons/wood_frame_icon.svg';
    } else if (hasplysheetData) {
      cardTitle = "PlyWood Sheet Calculation";
      iconPath = 'assets/icons/plywood_sheets_icon.svg';
    } else if (hasantitermiteData) {
      cardTitle = "Anti-Termite Calculation";
      iconPath = 'assets/icons/anti_termite_icon.svg';
    } else if (hasroundcolumnData) {
      cardTitle = "Round-Column Calculation";
      iconPath = 'assets/icons/round_column_icon.svg';
    } else if (hasstairData) {
      cardTitle = "Stair-Case Calculation";
      iconPath = 'assets/icons/stair_case_icon.svg';
    } else if (hastopsoilData) {
      cardTitle = "Top-Soil Calculation";
      iconPath = 'assets/icons/top_soil_icon.svg';
    } else if (hastubeData) {
      cardTitle = "Concrete-Tube Calculation";
      iconPath = 'assets/icons/concrete_tube_icon.svg';
    } else if (hasroofpitchData) {
      cardTitle = "Roof-Pitch Calculation";
      iconPath = 'assets/icons/roof_pitch_icon.svg';
    } else if (hascivilunitData) {
      cardTitle = "Civil-Unit Conversion";
      iconPath = 'assets/icons/civil_unit_icon.svg';
    } else if (hasstealData) {
      cardTitle = "Steal Weight Conversion";
      iconPath = 'assets/icons/steal_quanitity_icon.svg';
    } else if (hassteelData) {
      cardTitle = "Steal Weight Conversion";
      iconPath = 'assets/icons/steal_weight_icon.svg';
    } else if (hasbeamData) {
      cardTitle = "Steal Beam Conversion";
      iconPath = 'assets/icons/beam_steal_icon.svg';
    } else if (hasroundData) {
      cardTitle = "Round Bar Conversion";
      iconPath = 'assets/icons/round_bar_icon.svg';
    } else if (hassqbarData) {
      cardTitle = "Square Bar Conversion";
      iconPath = 'assets/icons/square_bar_icon.svg';
    } else if (hasdistanceData) {
      cardTitle = "Distance Converter";
      iconPath = 'assets/icons/distance_icon.svg';
    } else if (hasTimeData) {
      cardTitle = "Time Converter";
      iconPath = 'assets/icons/time_icon.svg';
    } else if (hasMassData) {
      cardTitle = "Mass Converter";
      iconPath = 'assets/icons/mass_icon.svg';
    } else if (hasPressureData) {
      cardTitle = "Pressure Converter";
      iconPath = 'assets/icons/pressure_icon.svg';
    } else if (hasspeedData) {
      cardTitle = "SpeedConverter";
      iconPath = 'assets/icons/speed_icon.svg';
    } else if (hasFuelData) {
      cardTitle = "Fuel Converter";
      iconPath = 'assets/icons/fuel_icon.svg';
    } else if (hasFrequencyData) {
      cardTitle = "Frequency Converter";
      iconPath = 'assets/icons/frequency_icon.svg';
    } else if (hasAngleData) {
      cardTitle = "Angle Converter";
      iconPath = 'assets/icons/angle_icon.svg';
    } else if (hascircledata) {
      cardTitle = "Circle Area Converter";
      iconPath = 'assets/icons/circle.svg';
    } else if (hasRectangleData) {
      cardTitle = "Rectangle Area Converter";
      iconPath = 'assets/icons/rectangle.svg';
    } else if (hasLShapeData) {
      cardTitle = "L-Shape Area Converter";
      iconPath = 'assets/icons/lShape.svg';
    } else if (hasHemisphereData) {
      cardTitle = "Hemisphere  Converter";
      iconPath = 'assets/icons/hemisphare.svg';
    } else if (hasSectorData) {
      cardTitle = "Sector Area Converter";
      iconPath = 'assets/icons/sector.svg';
    } else if (hasArchData) {
      cardTitle = "Arch  Converter";
      iconPath = 'assets/icons/arch.svg';
    } else if (hasRectangleSlotData) {
      cardTitle = "Rectangle Slot Converter";
      iconPath = 'assets/icons/rectangle.svg';
    } else if (hasverticalData) {
      cardTitle = "Vertical Sylinder";
      iconPath = 'assets/icons/Vector.svg';
    } else if (hasHorizontalCylinderData) {
      cardTitle = "Horizontal Cylinder";
      iconPath = 'assets/icons/horizontal.svg';
    } else if (hasRectangularPrismData) {
      cardTitle = "Rectangular Prism";
      iconPath = 'assets/icons/tankrectangle.svg';
    } else if (hasVerticalCapsuleData) {
      cardTitle = "Vertical Capsule";
      iconPath = 'assets/icons/vertical_capsule_icon.svg';
    } else if (hasHorizontalCapsuleData) {
      cardTitle = "Horizontal Capsule";
      iconPath = 'assets/icons/horizontal_capsule_icon.svg';
    } else if (hasVerticalEllipticalData) {
      cardTitle = "Vertical Elliptical";
      iconPath = 'assets/icons/vertical_elliptical_icon.svg';
    } else if (hasHorizontalEllipticalData) {
      cardTitle = "Horizontal Elliptical";
      iconPath = 'assets/icons/horizontal_elliptical_icon.svg';
    } else if (hasConeBottomData) {
      cardTitle = "Cone Bottom";
      iconPath = 'assets/icons/cone_bottom_icon.svg';
    } else if (hasConeTopData) {
      cardTitle = "Cone Top";
      iconPath = 'assets/icons/cone_top_icon.svg';
    } else if (hasFrustumData) {
      cardTitle = "Frustum";
      iconPath = 'assets/icons/frustum_icon.svg';
    } else {
      cardTitle = "Calculation";
      iconPath = 'assets/icons/construction_cost_icon.svg';
    }

    String? subtitle;
    if (hasConstructionData) {
      final data = item.data as ConstructionCostHistoryItem;
      subtitle =
          "Total: ${data.totalCost?.toStringAsFixed(2) ?? 0} ${data.unit ?? ''}";
    } else if (hasBrickData) {
      final data = item.data as BrickHistoryItem;
      final totalBricks = data.bricksQty?.toInt() ?? 0;
      subtitle = "Total Bricks: $totalBricks";
    } else if (hasCementData) {
      final data = item.data as CementHistoryItem;
      subtitle = "Total Volume: ${data.volume.toStringAsFixed(2)} m³";
    } else if (hasPlasterData) {
      final data = item.data as PlasterHistoryItem;
      subtitle = "Total Area: ${data.area.toStringAsFixed(2)} ${data.unit}";
    } else if (hasConcreteBlockData) {
      final data = item.data as ConcreteBlockHistory;
      subtitle = "Total Blocks: ${data.totalBlocks}";
    } else if (hasBoundaryWallData) {
      final data = item.data as BoundaryWallItem;
      subtitle = "Total Panels: ${data.totalPanels}";
    } else if (hasflooringData) {
      final data = item.data as FlooringHistoryItem;
      subtitle = "Total Tiles: ${data.totalTiles}";
    } else if (haskitchenData) {
      final data = item.data as KitchenHistoryItem;
      subtitle = "Total Area: ${data.area}";
    } else if (haswaterData) {
      final data = item.data as WaterSumpHistoryItem;
      subtitle = "Volume: ${data.volume.toStringAsFixed(2)} m³";
    } else if (hasacData) {
      final data = item.data as AirHistoryItem;
      subtitle = "Size: ${data.tons.toStringAsFixed(3)} ";
    } else if (hassolorData) {
      final data = item.data as SolarHistoryItem;
      subtitle = "Total Plates: ${data.totalPanels.toStringAsFixed(2)} ";
    } else if (hassolorwaterData) {
      final data = item.data as SolarWaterHistoryItem;
      subtitle = "Capasity: ${data.totalCapacity.toStringAsFixed(2)} ";
    } else if (haspaintData) {
      final data = item.data as PaintHistoryItem;
      subtitle = "Paint Area: ${data.paintArea} ";
    } else if (hasexcavationData) {
      final data = item.data as ExcavationHistoryItem;
      subtitle = "Volume: ${data.volume.toStringAsFixed(2)} ";
    } else if (haswoodframeData) {
      final data = item.data as WoodFrameHistoryItem;
      subtitle = "Volume: ${data.volume.toStringAsFixed(2)} ";
    } else if (hasplysheetData) {
      final data = item.data as PlywoodSheetItem;
      subtitle = "Total Sheets: ${data.totalSheets.toStringAsFixed(2)} ";
    } else if (hasantitermiteData) {
      final data = item.data as AntiTermiteHistoryItem;
      subtitle = "Area: ${data.area.toStringAsFixed(2)} ";
    } else if (hasroundcolumnData) {
      final data = item.data as RoundColumnHistoryItem;
      subtitle = "Area: ${data.volume.toStringAsFixed(2)} ";
    } else if (hasstairData) {
      final data = item.data as StairHistoryItem;
      subtitle = "Area: ${data.volume.toStringAsFixed(2)} ";
    } else if (hastopsoilData) {
      final data = item.data as TopSoilHistoryItem;
      subtitle = "Area: ${data.volume.toStringAsFixed(2)} ";
    } else if (hastubeData) {
      final data = item.data as ConcreteTubeHistoryItem;
      subtitle = "Area: ${data.concreteVolume.toStringAsFixed(2)} ";
    } else if (hasroofpitchData) {
      final data = item.data as RoofPitchHistoryItem;
      subtitle = "RoofPitch: ${data.roofPitch.toStringAsFixed(2)} ";
    } else if (hascivilunitData) {
      final data = item.data as ConversionHistory;
      subtitle = "Result: ${data.resultValue} ";
    } else if (hasstealData) {
      final data = item.data as StealWeightHistory;
      subtitle = "Weight: ${data.calculatedWeight}";
    } else if (hassteelData) {
      final data = item.data as StealHistoryItem;
      subtitle = "Weight: ${data.volume}";
    } else if (hasbeamData) {
      final data = item.data as BeamStealHistoryItem;
      subtitle = "Cost: ${data.costPerKg.toStringAsFixed(2)} ";
    } else if (hasroundData) {
      final data = item.data as RoundStealHistoryItem;
      subtitle = "Cost: ${data.costPerKg.toStringAsFixed(2)} ";
    } else if (hassqbarData) {
      final data = item.data as SquareBarHistoryItem;
      subtitle = "Cost: ${data.costPerKg.toStringAsFixed(2)} ";
    } else if (hasdistanceData) {
      final data = item.data as DistanceHistoryItem;
      subtitle = "Unit: ${data.inputUnit} ";
    } else if (item.type == "time_history") {
      final data = item.data as TimeHistoryItem;
      subtitle = "Unit: ${data.inputUnit}";
    } else if (item.type == "mass_history") {
      final data = item.data as MassHistoryItem;
      subtitle = "Unit: ${data.inputUnit}";
    } else if (item.type == "pressure_history") {
      final data = item.data as PressureHistoryItem;
      subtitle = "Unit: ${data.inputUnit}";
    } else if (item.type == "frequency_history") {
      final data = item.data as FrequencyHistoryItem;
      subtitle = "Unit: ${data.inputUnit}";
    } else if (item.type == "angle_history") {
      final data = item.data as AngleHistoryItem;
      subtitle = "Unit: ${data.inputUnit}";
    } else if (item.type == "fuel_history") {
      final data = item.data as FuelHistoryItem;
      subtitle = "Unit: ${data.inputUnit}";
    } else if (item.type == "speed_history") {
      final data = item.data as SpeedHistoryItem;
      subtitle = "Unit: ${data.inputUnit}";
    } else if (item.type == "circle_history") {
      final data = item.data as CircleHistoryItem;
      subtitle = "Area: ${data.resultValue.toStringAsFixed(2)} ";
    } else if (item.type == "rectangle_history") {
      final data = item.data as RectangleHistoryItem;
      subtitle = "Area: ${data.area.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "lshape_history") {
      final data = item.data as LShapeHistoryItem;
      subtitle = "Area: ${data.area.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "hemisphere_history") {
      final data = item.data as HemisphereHistoryItem;
      subtitle =
          "Area: ${data.volume.toStringAsFixed(2)} ${data.unit}, Volume: ${data.volume.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "sector_history") {
      final data = item.data as SectorHistoryItem;
      subtitle = "Area: ${data.area.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "arch_history") {
      final data = item.data as ArchHistoryItem;
      subtitle =
          "Area: ${data.area.toStringAsFixed(2)} ${data.unit}, Perimeter: ${data.perimeter.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "rectangle_slot_history") {
      final data = item.data as RectangleWithSlotHistoryItem;
      subtitle = "Area: ${data.area.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "vertical_cylinder_history") {
      final data = item.data as VerticalCylinderHistoryItem;
      subtitle =
          "Total Volume: ${data.totalVolume.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "horizontal_cylinder_history") {
      final data = item.data as HorizontalCylinderItem;
      subtitle =
          "Total Volume: ${data.totalVolume.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "rectangular_prism_history") {
      final data = item.data as RectangularPrismItem;
      subtitle =
          "Total Volume: ${data.totalVolume.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "vertical_capsule_history") {
      final data = item.data as VerticalCapsuleItem;
      subtitle =
          "Total Volume: ${data.totalVolume.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "horizontal_capsule_history") {
      final data = item.data as HorizontalCapsuleItem;
      subtitle =
          "Total Volume: ${data.totalVolume.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "vertical_elliptical_history") {
      final data = item.data as VerticalEllipticalItem;
      subtitle =
          "Total Volume: ${data.totalVolume.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "horizontal_elliptical_history") {
      final data = item.data as HorizontalEllipticalHistoryItem;
      subtitle =
          "Total Volume: ${data.totalVolume.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "cone_bottom_history") {
      final data = item.data as ConeBottomHistoryItem;
      subtitle =
          "Total Volume: ${data.totalVolume.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "cone_top_history") {
      final data = item.data as ConeTopHistoryItem;
      subtitle =
          "Total Volume: ${data.totalVolume.toStringAsFixed(2)} ${data.unit}";
    } else if (item.type == "frustum_history") {
      final data = item.data as FrustumHistoryItem;
      subtitle =
          "Total Volume: ${data.totalVolume.toStringAsFixed(2)} ${data.unit}";
    }

    return Container(
      key: ValueKey(index),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 36,
                  height: 36,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cardTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      if (subtitle != null) const SizedBox(height: 4),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.orange,
                      ),
                      onPressed: () {
                        setState(() {
                          expandedCards[index] = !isExpanded;
                        });
                      },
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      onSelected: (value) {
                        if (value == "delete") {
                          _showDeleteSingleConfirmation(index);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: "delete", child: Text("Delete")),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasConstructionData)
                    _buildConstructionSection(
                      item.data as ConstructionCostHistoryItem,
                    ),
                  if (hasBrickData && !hasConstructionData)
                    _buildBrickSection(item.data as BrickHistoryItem),
                  if (hasCementData && !hasConstructionData && !hasBrickData)
                    _buildCementSection(item.data as CementHistoryItem),
                  if (hasPlasterData)
                    _buildPlasterSection(item.data as PlasterHistoryItem),
                  if (hasConcreteBlockData)
                    _buildConcreteBlockSection(
                      item.data as ConcreteBlockHistory,
                    ),
                  if (hasBoundaryWallData)
                    _buildBoundaryWallSection(item.data as BoundaryWallItem),
                  if (hasflooringData)
                    _buildFlooringSection(item.data as FlooringHistoryItem),
                  if (haskitchenData)
                    _buildKitchenSection(item.data as KitchenHistoryItem),
                  if (haswaterData)
                    _buildWaterSumpSection(item.data as WaterSumpHistoryItem),
                  if (hasacData) _buildAcSection(item.data as AirHistoryItem),
                  if (hassolorData)
                    _buildSolarSection(item.data as SolarHistoryItem),
                  if (hassolorwaterData)
                    _buildSolarWaterHeaterSection(
                      item.data as SolarWaterHistoryItem,
                    ),
                  if (haspaintData)
                    _buildPaintSection(item.data as PaintHistoryItem),
                  if (hasexcavationData)
                    _buildExcavationSection(item.data as ExcavationHistoryItem),
                  if (haswoodframeData)
                    _buildWoodFrameSection(item.data as WoodFrameHistoryItem),

                  if (hasplysheetData)
                    _buildPlywoodSection(item.data as PlywoodSheetItem),
                  if (hasantitermiteData)
                    _buildAntiTermiteSection(
                      item.data as AntiTermiteHistoryItem,
                    ),
                  if (hasroundcolumnData)
                    _buildRoundColumnSection(
                      item.data as RoundColumnHistoryItem,
                    ),
                  if (hasstairData)
                    _buildStairHistoryCard(item.data as StairHistoryItem),
                  if (hastopsoilData)
                    _buildTopSoilHistoryCard(item.data as TopSoilHistoryItem),
                  if (hastubeData)
                    _buildConcreteTubeHistoryCard(
                      item.data as ConcreteTubeHistoryItem,
                    ),
                  if (hasroofpitchData)
                    _buildRoofPitchHistoryCard(
                      item.data as RoofPitchHistoryItem,
                    ),
                  if (hascivilunitData)
                    _buildCivilUnitHistoryCard(item.data as ConversionHistory),
                  if (hasstealData)
                    _buildSteelWeightHistoryCard(
                      item.data as StealWeightHistory,
                    ),
                  if (hassteelData)
                    _buildSteelHistoryCard(item.data as StealHistoryItem),
                  if (hasbeamData)
                    _buildBeamSteelHistoryCard(
                      item.data as BeamStealHistoryItem,
                    ),
                  if (hasroundData)
                    _buildRoundSteelHistoryCard(
                      item.data as RoundStealHistoryItem,
                    ),
                  if (hassqbarData)
                    _buildSquareBarHistoryCard(
                      item.data as SquareBarHistoryItem,
                    ),
                  if (hasdistanceData)
                    _buildDistanceHistoryCard(item.data as DistanceHistoryItem),
                  if (hasAngleData)
                    _buildAngleHistoryCard(item.data as AngleHistoryItem),
                  if (hasFrequencyData)
                    _buildFrequencyHistoryCard(
                      item.data as FrequencyHistoryItem,
                    ),

                  if (hasTimeData)
                    _buildTimeHistoryCard(item.data as TimeHistoryItem),

                  if (hasMassData)
                    _buildMassHistoryCard(item.data as MassHistoryItem),

                  if (hasPressureData)
                    _buildPressureHistoryCard(item.data as PressureHistoryItem),

                  if (hasFuelData)
                    _buildFuelHistoryCard(item.data as FuelHistoryItem),
                  if (hasspeedData)
                    _buildSpeedHistoryCard(item.data as SpeedHistoryItem),
                  if (hascircledata)
                    _buildCircleHistorySection(item.data as CircleHistoryItem),
                  if (hasRectangleData)
                    _buildRectangleHistorySection(
                      item.data as RectangleHistoryItem,
                    ),
                  if (hasLShapeData)
                    _buildLShapeHistorySection(item.data as LShapeHistoryItem),

                  if (hasHemisphereData)
                    _buildHemisphereHistorySection(
                      item.data as HemisphereHistoryItem,
                    ),
                  if (hasSectorData)
                    _buildSectorHistorySection(item.data as SectorHistoryItem),
                  if (hasArchData)
                    _buildArchHistorySection(item.data as ArchHistoryItem),
                  if (hasRectangleSlotData)
                    _buildRectangleSlotHistorySection(
                      item.data as RectangleWithSlotHistoryItem,
                    ),
                  if (hasverticalData)
                    _buildVerticalCylinderHistorySection(
                      item.data as VerticalCylinderHistoryItem,
                    ),
                  if (hasHorizontalCylinderData)
                    _buildHorizontalCylinderHistorySection(
                      item.data as HorizontalCylinderItem,
                    ),
                  if (hasRectangularPrismData)
                    _buildRectangularPrismHistorySection(
                      item.data as RectangularPrismItem,
                    ),
                  if (hasVerticalCapsuleData)
                    _buildVerticalCapsuleHistorySection(
                      item.data as VerticalCapsuleItem,
                    ),
                  if (hasHorizontalCapsuleData)
                    _buildHorizontalCapsuleHistorySection(
                      item.data as HorizontalCapsuleItem,
                    ),
                  if (hasVerticalEllipticalData)
                    _buildVerticalEllipticalHistorySection(
                      item.data as VerticalEllipticalItem,
                    ),
                  if (hasHorizontalEllipticalData)
                    _buildHorizontalEllipticalHistorySection(
                      item.data as HorizontalEllipticalHistoryItem,
                    ),
                  if (hasConeBottomData)
                    _buildConeBottomHistorySection(
                      item.data as ConeBottomHistoryItem,
                    ),
                  if (hasConeTopData)
                    _buildConeTopHistorySection(
                      item.data as ConeTopHistoryItem,
                    ),
                  if (hasFrustumData)
                    _buildFrustumHistorySection(
                      item.data as FrustumHistoryItem,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // 1. Horizontal Cylinder
  Widget _buildHorizontalCylinderHistorySection(HorizontalCylinderItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Diameter =',
        'value': "${item.diameter.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Length =',
        'value': "${item.length.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Filled Height =',
        'value': "${item.filledHeight.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Total Volume =', 'value': item.totalVolume.toStringAsFixed(3)},
      {
        'label': 'Filled Volume =',
        'value': item.filledVolume.toStringAsFixed(3),
      },
    ];

    List<Map<String, dynamic>> data = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Result', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: data,
      mainHeading: 'Horizontal Cylinder History',
    );
  }

  // 2. Rectangular Prism
  Widget _buildRectangularPrismHistorySection(RectangularPrismItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Length =',
        'value': "${item.length.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Width =',
        'value': "${item.width.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Height =',
        'value': "${item.height.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Filled Height =',
        'value': "${item.filledHeight.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Total Volume =', 'value': item.totalVolume.toStringAsFixed(3)},
      {
        'label': 'Filled Volume =',
        'value': item.filledVolume.toStringAsFixed(3),
      },
    ];

    return _buildSection(
      contentSections: [
        {'heading': 'Inputs', 'data': inputRows},
        {'heading': 'Result', 'data': resultRows},
      ],
      mainHeading: 'Rectangular Prism History',
    );
  }

  // 3. Vertical Capsule
  Widget _buildVerticalCapsuleHistorySection(VerticalCapsuleItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Diameter =',
        'value': "${item.diameter.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Cylinder Height =',
        'value': "${item.cylinderHeight.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Filled Height =',
        'value': "${item.filledHeight.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Total Volume =', 'value': item.totalVolume.toStringAsFixed(3)},
      {
        'label': 'Filled Volume =',
        'value': item.filledVolume.toStringAsFixed(3),
      },
    ];

    return _buildSection(
      contentSections: [
        {'heading': 'Inputs', 'data': inputRows},
        {'heading': 'Result', 'data': resultRows},
      ],
      mainHeading: 'Vertical Capsule History',
    );
  }

  // 4. Horizontal Capsule
  Widget _buildHorizontalCapsuleHistorySection(HorizontalCapsuleItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Diameter =',
        'value': "${item.diameter.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Cylinder Length =',
        'value': "${item.cylinderLength.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Filled Length =',
        'value': "${item.filledLength.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Total Volume =', 'value': item.totalVolume.toStringAsFixed(3)},
      {
        'label': 'Filled Volume =',
        'value': item.filledVolume.toStringAsFixed(3),
      },
    ];

    return _buildSection(
      contentSections: [
        {'heading': 'Inputs', 'data': inputRows},
        {'heading': 'Result', 'data': resultRows},
      ],
      mainHeading: 'Horizontal Capsule History',
    );
  }

  // 5. Vertical Elliptical
  Widget _buildVerticalEllipticalHistorySection(VerticalEllipticalItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Length =',
        'value': "${item.length.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Width =',
        'value': "${item.width.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Height =',
        'value': "${item.height.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Filled Height =',
        'value': "${item.filledHeight.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Total Volume =', 'value': item.totalVolume.toStringAsFixed(3)},
      {
        'label': 'Filled Volume =',
        'value': item.filledVolume.toStringAsFixed(3),
      },
    ];

    return _buildSection(
      contentSections: [
        {'heading': 'Inputs', 'data': inputRows},
        {'heading': 'Result', 'data': resultRows},
      ],
      mainHeading: 'Vertical Elliptical History',
    );
  }

  // 6. Horizontal Elliptical
  Widget _buildHorizontalEllipticalHistorySection(
    HorizontalEllipticalHistoryItem item,
  ) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Length =',
        'value': "${item.length.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Width =',
        'value': "${item.width.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Height =',
        'value': "${item.height.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Filled =',
        'value': "${item.filled.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Total Volume =', 'value': item.totalVolume.toStringAsFixed(3)},
      {
        'label': 'Filled Volume =',
        'value': item.filledVolume.toStringAsFixed(3),
      },
    ];

    return _buildSection(
      contentSections: [
        {'heading': 'Inputs', 'data': inputRows},
        {'heading': 'Result', 'data': resultRows},
      ],
      mainHeading: 'Horizontal Elliptical History',
    );
  }

  // 7. Cone Bottom
  Widget _buildConeBottomHistorySection(ConeBottomHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Top Diameter =',
        'value': "${item.topDiameter.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Bottom Diameter =',
        'value': "${item.bottomDiameter.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Cylinder Height =',
        'value': "${item.cylinderHeight.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Cone Height =',
        'value': "${item.coneHeight.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Filled Height =',
        'value': "${item.filledHeight.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Total Volume =', 'value': item.totalVolume.toStringAsFixed(3)},
      {
        'label': 'Filled Volume =',
        'value': item.filledVolume.toStringAsFixed(3),
      },
    ];

    return _buildSection(
      contentSections: [
        {'heading': 'Inputs', 'data': inputRows},
        {'heading': 'Result', 'data': resultRows},
      ],
      mainHeading: 'Cone Bottom History',
    );
  }

  // 8. Cone Top
  Widget _buildConeTopHistorySection(ConeTopHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Top Diameter =',
        'value': "${item.topDiameter.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Bottom Diameter =',
        'value': "${item.bottomDiameter.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Cylinder Height =',
        'value': "${item.cylinderHeight.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Cone Height =',
        'value': "${item.coneHeight.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Filled Height =',
        'value': "${item.filledHeight.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Total Volume =', 'value': item.totalVolume.toStringAsFixed(3)},
      {
        'label': 'Filled Volume =',
        'value': item.filledVolume.toStringAsFixed(3),
      },
    ];

    return _buildSection(
      contentSections: [
        {'heading': 'Inputs', 'data': inputRows},
        {'heading': 'Result', 'data': resultRows},
      ],
      mainHeading: 'Cone Top History',
    );
  }

  // 9. Frustum
  Widget _buildFrustumHistorySection(FrustumHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Top Diameter =',
        'value': "${item.topDiameter.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Bottom Diameter =',
        'value': "${item.bottomDiameter.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Height =',
        'value': "${item.height.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Filled Height =',
        'value': "${item.filledHeight.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Total Volume =', 'value': item.totalVolume.toStringAsFixed(3)},
      {
        'label': 'Filled Volume =',
        'value': item.filledVolume.toStringAsFixed(3),
      },
    ];

    return _buildSection(
      contentSections: [
        {'heading': 'Inputs', 'data': inputRows},
        {'heading': 'Result', 'data': resultRows},
      ],
      mainHeading: 'Frustum History',
    );
  }

  Widget _buildVerticalCylinderHistorySection(
    VerticalCylinderHistoryItem item,
  ) {
    // Input rows
    List<Map<String, String>> inputRows = [
      {
        'label': 'Diameter =',
        'value': "${item.diameter.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Height =',
        'value': "${item.height.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Filled Height =',
        'value': "${item.filled.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    // Result rows
    List<Map<String, String>> resultRows = [
      {'label': 'Total Volume =', 'value': item.totalVolume.toStringAsFixed(3)},
      {
        'label': 'Filled Volume =',
        'value': item.filledVolume.toStringAsFixed(3),
      },
    ];

    // Merge into sections
    List<Map<String, dynamic>> data = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Result', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: data,
      mainHeading: 'Vertical Cylinder History',
    );
  }

  Widget _buildArchHistorySection(ArchHistoryItem item) {
    // Input rows
    List<Map<String, String>> inputRows = [
      {
        'label': 'Length =',
        'value': "${item.length.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Height =',
        'value': "${item.height.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    // Result rows
    List<Map<String, String>> resultRows = [
      {'label': 'Area =', 'value': item.area.toStringAsFixed(3)},
      {'label': 'Perimeter =', 'value': item.perimeter.toStringAsFixed(3)},
    ];

    // Merge into sections
    List<Map<String, dynamic>> data = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Result', 'data': resultRows},
    ];

    return _buildSection(contentSections: data, mainHeading: 'Arch History');
  }

  Widget _buildRectangleSlotHistorySection(RectangleWithSlotHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {'label': 'A =', 'value': "${item.a.toStringAsFixed(2)} ${item.unit}"},
      {'label': 'B =', 'value': "${item.b.toStringAsFixed(2)} ${item.unit}"},
      {'label': 'C =', 'value': "${item.c.toStringAsFixed(2)} ${item.unit}"},
      {'label': 'D =', 'value': "${item.d.toStringAsFixed(2)} ${item.unit}"},
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Area =', 'value': item.area.toStringAsFixed(3)},
      {'label': 'Perimeter =', 'value': item.perimeter.toStringAsFixed(3)},
    ];

    List<Map<String, dynamic>> data = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Result', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: data,
      mainHeading: 'Rectangle with Slot History',
    );
  }

  Widget _buildSectorHistorySection(SectorHistoryItem item) {
    // Input rows
    List<Map<String, String>> inputRows = [
      {
        'label': 'Radius =',
        'value': "${item.radius.toStringAsFixed(2)} ${item.unit}",
      },
      {'label': 'Angle =', 'value': "${item.angle.toStringAsFixed(2)} °"},
    ];

    // Result rows
    List<Map<String, String>> resultRows = [
      {'label': 'Area =', 'value': item.area.toStringAsFixed(3)},
    ];

    // Merge into sections
    List<Map<String, dynamic>> data = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Result', 'data': resultRows},
    ];

    return _buildSection(contentSections: data, mainHeading: 'Sector History');
  }

  Widget _buildHemisphereHistorySection(HemisphereHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Radius =',
        'value': "${item.radius.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Surface Area =', 'value': item.surfaceArea.toStringAsFixed(3)},
      {'label': 'Volume =', 'value': item.volume.toStringAsFixed(3)},
    ];

    List<Map<String, dynamic>> data = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Result', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: data,
      mainHeading: 'Hemisphere History',
    );
  }

  Widget _buildLShapeHistorySection(LShapeHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {'label': 'L1 =', 'value': "${item.l1.toStringAsFixed(2)} ${item.unit}"},
      {'label': 'W1 =', 'value': "${item.w1.toStringAsFixed(2)} ${item.unit}"},
      {'label': 'L2 =', 'value': "${item.l2.toStringAsFixed(2)} ${item.unit}"},
      {'label': 'W2 =', 'value': "${item.w2.toStringAsFixed(2)} ${item.unit}"},
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Area =', 'value': item.area.toStringAsFixed(3)},
      {'label': 'Perimeter =', 'value': item.perimeter.toStringAsFixed(3)},
    ];

    List<Map<String, dynamic>> data = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Result', 'data': resultRows},
    ];

    return _buildSection(contentSections: data, mainHeading: 'L-Shape History');
  }

  Widget _buildRectangleHistorySection(RectangleHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Length =',
        'value': "${item.length.toStringAsFixed(2)} ${item.unit}",
      },
      {
        'label': 'Width =',
        'value': "${item.width.toStringAsFixed(2)} ${item.unit}",
      },
    ];

    List<Map<String, String>> resultRows = [
      {'label': 'Area =', 'value': item.area.toStringAsFixed(3)},
      {'label': 'Perimeter =', 'value': item.perimeter.toStringAsFixed(3)},
    ];

    List<Map<String, dynamic>> data = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Result', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: data,
      mainHeading: 'Rectangle History',
    );
  }

  Widget _buildCircleHistorySection(CircleHistoryItem item) {
    // ✅ Input rows
    List<Map<String, String>> inputRows = [
      {
        'label': 'Input Value =',
        'value': "${item.inputValue.toStringAsFixed(2)} ${item.inputUnit}",
      },
    ];

    // ✅ Result rows
    List<Map<String, String>> resultRows = [
      {
        'label': "${item.resultType} =",
        'value': item.resultValue.toStringAsFixed(3),
      },
    ];

    // ✅ Merge into sections
    List<Map<String, dynamic>> circleData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Result', 'data': resultRows},
    ];

    // ✅ Call your common section builder
    return _buildSection(
      contentSections: circleData,
      mainHeading: 'Circle History',
    );
  }

  Widget _buildSpeedHistoryCard(SpeedHistoryItem item) {
    // ✅ Input rows from model
    List<Map<String, String>> inputRows = [
      {
        'label': 'Input Value =',
        'value': "${item.inputValue.toStringAsFixed(2)} ${item.inputUnit}",
      },
    ];

    // ✅ Converted result rows from model
    List<Map<String, String>> resultRows = item.convertedValues.entries
        .map(
          (entry) => {
            'label': '${entry.key} =',
            'value': entry.value.toStringAsFixed(3),
          },
        )
        .toList();

    // ✅ Merge into sections
    List<Map<String, dynamic>> speedData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Converted Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: speedData,
      mainHeading: 'Speed History',
    );
  }

  Widget _buildFuelHistoryCard(FuelHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Input Value =',
        'value': "${item.inputValue.toStringAsFixed(2)} ${item.inputUnit}",
      },
    ];

    List<Map<String, String>> resultRows = item.convertedValues.entries
        .map(
          (entry) => {
            'label': '${entry.key} =',
            'value': entry.value.toStringAsFixed(3),
          },
        )
        .toList();

    List<Map<String, dynamic>> fuelData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Converted Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: fuelData,
      mainHeading: 'Fuel History',
    );
  }

  Widget _buildAngleHistoryCard(AngleHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Input Value =',
        'value': "${item.inputValue.toStringAsFixed(2)} ${item.inputUnit}",
      },
    ];

    List<Map<String, String>> resultRows = item.convertedValues.entries
        .map(
          (entry) => {
            'label': '${entry.key} =',
            'value': entry.value.toStringAsFixed(3),
          },
        )
        .toList();

    List<Map<String, dynamic>> angleData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Converted Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: angleData,
      mainHeading: 'Angle History',
    );
  }

  Widget _buildFrequencyHistoryCard(FrequencyHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Input Value =',
        'value': "${item.inputValue.toStringAsFixed(2)} ${item.inputUnit}",
      },
    ];

    List<Map<String, String>> resultRows = item.convertedValues.entries
        .map(
          (entry) => {
            'label': '${entry.key} =',
            'value': entry.value.toStringAsFixed(3),
          },
        )
        .toList();

    List<Map<String, dynamic>> freqData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Converted Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: freqData,
      mainHeading: 'Frequency History',
    );
  }

  Widget _buildPressureHistoryCard(PressureHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Input Value =',
        'value': "${item.inputValue.toStringAsFixed(2)} ${item.inputUnit}",
      },
    ];

    List<Map<String, String>> resultRows = item.convertedValues.entries
        .map(
          (entry) => {
            'label': '${entry.key} =',
            'value': entry.value.toStringAsFixed(3),
          },
        )
        .toList();

    List<Map<String, dynamic>> pressureData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Converted Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: pressureData,
      mainHeading: 'Pressure History',
    );
  }

  Widget _buildMassHistoryCard(MassHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Input Value =',
        'value': "${item.inputValue.toStringAsFixed(2)} ${item.inputUnit}",
      },
    ];

    List<Map<String, String>> resultRows = item.convertedValues.entries
        .map(
          (entry) => {
            'label': '${entry.key} =',
            'value': entry.value.toStringAsFixed(3),
          },
        )
        .toList();

    List<Map<String, dynamic>> massData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Converted Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: massData,
      mainHeading: 'Mass History',
    );
  }

  Widget _buildTimeHistoryCard(TimeHistoryItem item) {
    List<Map<String, String>> inputRows = [
      {
        'label': 'Input Value =',
        'value': "${item.inputValue.toStringAsFixed(2)} ${item.inputUnit}",
      },
    ];

    List<Map<String, String>> resultRows = item.convertedValues.entries
        .map(
          (entry) => {
            'label': '${entry.key} =',
            'value': entry.value.toStringAsFixed(3),
          },
        )
        .toList();

    List<Map<String, dynamic>> timeData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Converted Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: timeData,
      mainHeading: 'Time History',
    );
  }

  Widget _buildDistanceHistoryCard(DistanceHistoryItem item) {
    // ✅ Input rows from model
    List<Map<String, String>> inputRows = [
      {
        'label': 'Input Value =',
        'value': "${item.inputValue.toStringAsFixed(2)} ${item.inputUnit}",
      },
    ];

    // ✅ Converted result rows from model
    List<Map<String, String>> resultRows = item.convertedValues.entries
        .map(
          (entry) => {
            'label': '${entry.key} =',
            'value': entry.value.toStringAsFixed(3),
          },
        )
        .toList();

    // ✅ Merge into sections
    List<Map<String, dynamic>> distanceData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Converted Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: distanceData,
      mainHeading: 'Distance History',
    );
  }

  Widget _buildSquareBarHistoryCard(SquareBarHistoryItem item) {
    // ✅ Input rows from model
    List<Map<String, String>> inputRows = [
      {'label': 'Material =', 'value': item.material},
      {
        'label': 'Side =',
        'value': item.side.toStringAsFixed(2) + " ${item.lengthUnit}",
      },
      {
        'label': 'Length =',
        'value': item.length.toStringAsFixed(2) + " ${item.lengthUnit}",
      },
      {'label': 'Pieces =', 'value': item.pieces.toString()},
      {'label': 'Cost per kg =', 'value': item.costPerKg.toStringAsFixed(2)},
    ];

    // ✅ Result rows from model
    List<Map<String, String>> resultRows = [
      {'label': 'Weight (kg) =', 'value': item.weightKg.toStringAsFixed(2)},
      {'label': 'Weight (tons) =', 'value': item.weightTons.toStringAsFixed(2)},
      {'label': 'Total Cost =', 'value': item.totalCost.toStringAsFixed(2)},
    ];

    // ✅ Merge into sections
    List<Map<String, dynamic>> squareBarData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: squareBarData,
      mainHeading: 'Square Bar History',
    );
  }

  Widget _buildRoundSteelHistoryCard(RoundStealHistoryItem item) {
    // ✅ Input rows from model
    List<Map<String, String>> inputRows = [
      {'label': 'Material =', 'value': item.material},
      {
        'label': 'Diameter =',
        'value': item.diameter.toStringAsFixed(2) + " ${item.lengthUnit}",
      },
      {
        'label': 'Length =',
        'value': item.length.toStringAsFixed(2) + " ${item.lengthUnit}",
      },
      {'label': 'Pieces =', 'value': item.pieces.toString()},
      {'label': 'Cost per kg =', 'value': item.costPerKg.toStringAsFixed(2)},
    ];

    // ✅ Result rows from model
    List<Map<String, String>> resultRows = [
      {'label': 'Weight (kg) =', 'value': item.weightKg.toStringAsFixed(2)},
      {'label': 'Weight (tons) =', 'value': item.weightTons.toStringAsFixed(2)},
      {'label': 'Total Cost =', 'value': item.totalCost.toStringAsFixed(2)},
    ];

    // ✅ Merge into sections
    List<Map<String, dynamic>> roundData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: roundData,
      mainHeading: 'Round Steel History',
    );
  }

  Widget _buildBeamSteelHistoryCard(BeamStealHistoryItem item) {
    // ✅ Input rows from model
    List<Map<String, String>> inputRows = [
      {'label': 'Material =', 'value': item.material},
      {
        'label': 'Size A =',
        'value': item.sizeA.toStringAsFixed(2) + " ${item.lengthUnit}",
      },
      {
        'label': 'Size B =',
        'value': item.sizeB.toStringAsFixed(2) + " ${item.lengthUnit}",
      },
      {
        'label': 'Size T =',
        'value': item.sizeT.toStringAsFixed(2) + " ${item.lengthUnit}",
      },
      {
        'label': 'Size S =',
        'value': item.sizeS.toStringAsFixed(2) + " ${item.lengthUnit}",
      },
      {
        'label': 'Length =',
        'value': item.length.toStringAsFixed(2) + " ${item.lengthUnit}",
      },
      {'label': 'Pieces =', 'value': item.pieces.toString()},
      {'label': 'Cost per kg =', 'value': item.costPerKg.toStringAsFixed(2)},
    ];

    // ✅ Result rows from model
    List<Map<String, String>> resultRows = [
      {'label': 'Weight (kg) =', 'value': item.weightKg.toStringAsFixed(2)},
      {'label': 'Weight (tons) =', 'value': item.weightTons.toStringAsFixed(2)},
      {'label': 'Total Cost =', 'value': item.totalCost.toStringAsFixed(2)},
    ];

    // ✅ Merge into sections
    List<Map<String, dynamic>> beamData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: beamData,
      mainHeading: 'Beam Steel History',
    );
  }

  Widget _buildSteelHistoryCard(StealHistoryItem item) {
    // Input rows
    List<Map<String, String>> inputRows = [
      {'label': 'Diameter (mm) =', 'value': item.diameter.toStringAsFixed(2)},
      {'label': 'Length (m) =', 'value': item.length.toStringAsFixed(2)},
      {'label': 'Quantity =', 'value': item.quantity.toString()},
    ];

    // Result rows
    List<Map<String, String>> resultRows = [
      {
        'label': 'Calculated Weight (kg) =',
        'value': item.volume.toStringAsFixed(2),
      },
    ];

    // Sections for _buildSection
    List<Map<String, dynamic>> steelData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: steelData,
      mainHeading: 'Steel Weight History',
    );
  }

  Widget _buildSteelWeightHistoryCard(StealWeightHistory item) {
    // Input rows
    List<Map<String, String>> inputRows = [
      {'label': 'Input Volume (m³) =', 'value': item.inputVolume},
      {'label': 'Steel Type =', 'value': item.steelType},
    ];

    // Result rows
    List<Map<String, String>> resultRows = [
      {
        'label': 'Calculated Weight =',
        'value': double.parse(item.calculatedWeight).toStringAsFixed(0),
      },
    ];

    // Sections for _buildSection
    List<Map<String, dynamic>> steelData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: steelData,
      mainHeading: 'Steel Weight Calculation',
    );
  }

  Widget _buildCivilUnitHistoryCard(ConversionHistory item) {
    // Inputs rows
    List<Map<String, String>> inputRows = [
      {'label': 'Input Value =', 'value': item.inputValue},
      {'label': 'From Unit =', 'value': item.fromUnit},
      // {'label': 'Unit =', 'value': item.unit},
    ];

    // Results rows
    List<Map<String, String>> resultRows = [
      {'label': 'Result Value =', 'value': item.resultValue},
      {'label': 'Slope (%) =', 'value': item.toUnit},
    ];

    // Sections for _buildSection
    List<Map<String, dynamic>> roofData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: roofData,
      mainHeading: 'Civil-unit Conversion',
    );
  }

  Widget _buildRoofPitchHistoryCard(RoofPitchHistoryItem item) {
    // Inputs rows
    List<Map<String, String>> inputRows = [
      {'label': 'Height (M) =', 'value': item.heightM},
      {'label': 'Height (CM) =', 'value': item.heightCM},
      {'label': 'Height (FT) =', 'value': item.heightFT},
      {'label': 'Height (IN) =', 'value': item.heightIN},
      {'label': 'Width (M) =', 'value': item.widthM},
      {'label': 'Width (CM) =', 'value': item.widthCM},
      {'label': 'Width (FT) =', 'value': item.widthFT},
      {'label': 'Width (IN) =', 'value': item.widthIN},
      {'label': 'Unit =', 'value': item.unit},
    ];

    // Results rows
    List<Map<String, String>> resultRows = [
      {
        'label': 'Roof Pitch (rise/run) =',
        'value': item.roofPitch.toStringAsFixed(3),
      },
      {'label': 'Slope (%) =', 'value': item.roofSlope.toStringAsFixed(2)},
      {'label': 'Angle (°) =', 'value': item.roofAngle.toStringAsFixed(2)},
    ];

    // Sections for _buildSection
    List<Map<String, dynamic>> roofData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: roofData,
      mainHeading: 'Roof Pitch Calculation',
    );
  }

  Widget _buildConcreteTubeHistoryCard(ConcreteTubeHistoryItem item) {
    // 🟠 Input rows (user entered values)
    List<Map<String, String>> inputRows = [
      {
        'label': 'Inner Diameter =',
        'value':
            '${item.innerM} m ${item.innerCM} ${item.innerFT} ft ${item.innerIN}',
      },
      {
        'label': 'Outer Diameter =',
        'value':
            '${item.outerM} m ${item.outerCM} ${item.outerFT} ft ${item.outerIN}',
      },
      {
        'label': 'Height =',
        'value':
            '${item.heightM} m ${item.heightCM} ${item.heightFT} ft ${item.heightIN}',
      },
      {'label': 'No. of Tubes =', 'value': item.noOfTubes},
      {'label': 'Concrete Grade =', 'value': item.grade},
      {'label': 'Unit =', 'value': item.unit},
    ];

    // 🟢 Result rows (calculated values)
    List<Map<String, String>> resultRows = [
      {
        'label': 'Concrete Volume =',
        'value': '${item.concreteVolume.toStringAsFixed(2)} ',
      },
      {
        'label': 'Cement Bags =',
        'value': '${item.cementBags.toStringAsFixed(2)} Bags',
      },
      {'label': 'Sand =', 'value': '${item.sandCft.toStringAsFixed(2)} Ton'},
      {
        'label': 'Aggregate =',
        'value': '${item.aggregateCft.toStringAsFixed(2)} Ton',
      },
    ];

    // 🏗 Structure for _buildSection
    List<Map<String, dynamic>> concreteTubeData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: concreteTubeData,
      mainHeading: 'Concrete Tube Calculation',
    );
  }

  Widget _buildTopSoilHistoryCard(TopSoilHistoryItem item) {
    // 🟠 Input rows (user entered values)
    List<Map<String, String>> inputRows = [
      {'label': 'Length =', 'value': '${item.length.toStringAsFixed(2)} m'},
      {'label': 'Width =', 'value': '${item.width.toStringAsFixed(2)} m'},
      {'label': 'Depth =', 'value': '${item.depth.toStringAsFixed(2)} m'},
    ];

    // 🟢 Result rows (calculated values)
    List<Map<String, String>> resultRows = [
      {
        'label': 'Total Volume =',
        'value': '${item.volume.toStringAsFixed(3)} m³',
      },
      {
        'label': 'Approx.Capacity in Liters =',
        'value': '${(item.volume * 1000).toStringAsFixed(1)} L',
      },
      {
        'label': 'Approx.Capacity in ft³ =',
        'value': '${(item.volume * 35.3147).toStringAsFixed(1)} ft³',
      },
    ];

    // 🏗 Structure for _buildSection
    List<Map<String, dynamic>> topSoilData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: topSoilData,
      mainHeading: 'Top Soil Calculation',
    );
  }

  Widget _buildStairHistoryCard(StairHistoryItem item) {
    // 🟠 Input rows (user entered values)
    List<Map<String, String>> inputRows = [
      {'label': 'Riser =', 'value': '${item.riserFT} ft ${item.riserIN} in'},
      {'label': 'Tread =', 'value': '${item.treadFT} ft ${item.treadIN} in'},
      {'label': 'Width of Stair =', 'value': '${item.stairWidthFT} ft'},
      {'label': 'Height of Stair =', 'value': '${item.stairHeightFT} ft'},
      {'label': 'Waist Slab Thickness =', 'value': '${item.waistSlabIN} in'},
      {'label': 'Grade =', 'value': item.grade},
    ];

    // 🟢 Result rows (calculated values)
    List<Map<String, String>> resultRows = [
      {
        'label': 'Concrete Volume =',
        'value': '${item.volume.toStringAsFixed(2)} ft³',
      },
      {
        'label': 'Cement Required =',
        'value': '${item.cementBags.toStringAsFixed(2)} Bags',
      },
      {
        'label': 'Sand Required =',
        'value': '${item.sand.toStringAsFixed(2)} ft³',
      },
      {
        'label': 'Aggregate Required =',
        'value': '${item.aggregate.toStringAsFixed(2)} ft³',
      },
    ];

    // 🏗 Structure for _buildSection
    List<Map<String, dynamic>> stairData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: stairData,
      mainHeading: 'Stair Case Calculation',
    );
  }

  Widget _buildRoundColumnSection(RoundColumnHistoryItem item) {
    // 🟠 Input rows (user entered values)
    List<Map<String, String>> inputRows = [
      {
        'label': 'Diameter =',
        'value': item.unit == "Feet/Inch"
            ? '${item.diFT} ft ${item.diIN} in'
            : '${item.diM} m ${item.diCM} cm',
      },
      {
        'label': 'Height =',
        'value': item.unit == "Feet/Inch"
            ? '${item.htFT} ft ${item.htIN} in'
            : '${item.htM} m ${item.htCM} cm',
      },
      {'label': 'No. of Columns =', 'value': item.noOfColumns},
      {'label': 'Grade =', 'value': item.grade},
    ];

    // 🟢 Result rows (calculated values)
    List<Map<String, String>> resultRows = [
      {
        'label': 'Total Volume =',
        'value': '${item.volume.toStringAsFixed(2)} m³',
      },
      {
        'label': 'Cement Required =',
        'value': '${item.cementBags.toStringAsFixed(2)} Bags',
      },
      {
        'label': 'Sand Required =',
        'value': '${item.sandCft.toStringAsFixed(2)} cft',
      },
      {
        'label': 'Aggregate Required =',
        'value': '${item.aggregateCft.toStringAsFixed(2)} cft',
      },
    ];

    // 🏗 Structure for _buildSection
    List<Map<String, dynamic>> columnData = [
      {'heading': 'Inputs', 'data': inputRows},
      {'heading': 'Results', 'data': resultRows},
    ];

    return _buildSection(
      contentSections: columnData,
      mainHeading: 'Round Column Calculation',
    );
  }

  Widget _buildAntiTermiteSection(AntiTermiteHistoryItem item) {
    // Unit label (m² or ft²)
    final unitArea = item.unit == "Feet/Inch" ? "ft²" : "m²";

    // Rows to display
    List<Map<String, String>> rows = [
      {
        'label': 'Length',
        'value':
            '${item.lenM.isNotEmpty ? item.lenM : item.lenFT} ${item.unit == "Feet/Inch" ? "ft" : "m"}',
      },
      {
        'label': 'Width',
        'value':
            '${item.widthM.isNotEmpty ? item.widthM : item.widthFT} ${item.unit == "Feet/Inch" ? "ft" : "m"}',
      },
      {
        'label': 'Total Area',
        'value': '${item.area.toStringAsFixed(2)} $unitArea',
      },
      {
        'label': 'Chemical Required',
        'value': '${item.chemicalQuantity.toStringAsFixed(2)} mL',
      },
    ];

    // Data structure (same style as plywood/woodframe)
    List<Map<String, dynamic>> antiTermiteData = [
      {'heading': null, 'data': rows},
    ];

    return _buildSection(
      contentSections: antiTermiteData,
      mainHeading: 'Anti-Termite Treatment Calculation Result',
    );
  }

  Widget _buildPlywoodSection(PlywoodSheetItem item) {
    // Unit label (meter or feet)
    final unit = item.selectedUnit == "Feet/Inch" ? "ft" : "m";
    final unitArea = item.selectedUnit == "Feet/Inch" ? "ft²" : "m²";

    // Rows to display
    List<Map<String, String>> rows = [
      {
        'label': 'Room Length',
        'value': '${item.roomLength.toStringAsFixed(2)} $unit',
      },
      {
        'label': 'Room Width',
        'value': '${item.roomWidth.toStringAsFixed(2)} $unit',
      },
      {
        'label': 'Room Area',
        'value': '${item.roomArea.toStringAsFixed(2)} $unitArea',
      },
      {
        'label': 'Plywood Length',
        'value': '${item.plyLength.toStringAsFixed(2)} $unit',
      },
      {
        'label': 'Plywood Width',
        'value': '${item.plyWidth.toStringAsFixed(2)} $unit',
      },
      {
        'label': 'Plywood Cover',
        'value': '${item.plywoodCover.toStringAsFixed(2)} $unitArea',
      },
      {'label': 'Total Sheets', 'value': '${item.totalSheets}'},
    ];

    // Data structure similar to Solar/Paint/Woodframe sections
    List<Map<String, dynamic>> plywoodData = [
      {'heading': null, 'data': rows},
    ];

    return _buildSection(
      contentSections: plywoodData,
      mainHeading: 'Plywood Sheet Calculation Result',
    );
  }

  Widget _buildWoodFrameSection(WoodFrameHistoryItem item) {
    // Rows to display
    List<Map<String, String>> rows = [
      {
        'label': 'Length',
        'value':
            '${item.length.toStringAsFixed(2)} ${item.unit == "Feet/Inch" ? "ft" : "m"}',
      },
      {
        'label': 'Width',
        'value':
            '${item.width.toStringAsFixed(2)} ${item.unit == "Feet/Inch" ? "ft" : "m"}',
      },
      {
        'label': 'Depth',
        'value':
            '${item.depth.toStringAsFixed(2)} ${item.unit == "Feet/Inch" ? "ft" : "m"}',
      },
      {
        'label': 'Total Volume',
        'value':
            '${item.volume.toStringAsFixed(2)} ${item.unit == "Feet/Inch" ? "ft³" : "m³"}',
      },
    ];

    // Data structure similar to Solar/Paint sections
    List<Map<String, dynamic>> woodFramingData = [
      {'heading': null, 'data': rows},
    ];

    return _buildSection(
      contentSections: woodFramingData,
      mainHeading: 'Wood Framing Calculation Result',
    );
  }

  Widget _buildExcavationSection(ExcavationHistoryItem item) {
    // Rows to display
    List<Map<String, String>> rows = [
      {
        'label': 'Length',
        'value':
            '${item.length.toStringAsFixed(2)} ${item.unit == "Feet/Inch" ? "ft" : "m"}',
      },
      {
        'label': 'Width',
        'value':
            '${item.width.toStringAsFixed(2)} ${item.unit == "Feet/Inch" ? "ft" : "m"}',
      },
      {
        'label': 'Depth',
        'value':
            '${item.depth.toStringAsFixed(2)} ${item.unit == "Feet/Inch" ? "ft" : "m"}',
      },
      {
        'label': 'Total Volume',
        'value':
            '${item.volume.toStringAsFixed(2)} ${item.unit == "Feet/Inch" ? "ft³" : "m³"}',
      },
    ];

    // Data structure similar to your Solar/ Paint sections
    List<Map<String, dynamic>> excavationData = [
      {'heading': null, 'data': rows},
    ];

    return _buildSection(
      contentSections: excavationData,
      mainHeading: 'Excavation Calculation Result',
    );
  }

  Widget _buildPaintSection(PaintHistoryItem item) {
    // Rows to display
    List<Map<String, String>> rows = [
      {
        'label': 'Total Paint Area',
        'value':
            '${item.paintArea.toStringAsFixed(2)} ${item.unit == "Feet" ? "ft²" : "m²"}',
      },
      {
        'label': 'Paint Quantity',
        'value': '${item.paintQuantity.toStringAsFixed(2)} liters',
      },
      {
        'label': 'Primer Quantity',
        'value': '${item.primerQuantity.toStringAsFixed(2)} liters',
      },
      {
        'label': 'Putty Quantity',
        'value': '${item.puttyQuantity.toStringAsFixed(2)} kgs',
      },
    ];

    // Data structure like your Solar section
    List<Map<String, dynamic>> paintData = [
      {'heading': null, 'data': rows},
    ];

    return _buildSection(
      contentSections: paintData,
      mainHeading: 'Paint Calculation Result',
    );
  }

  Widget _buildSolarWaterHeaterSection(SolarWaterHistoryItem item) {
    List<Map<String, dynamic>> solarData = [];

    List<Map<String, String>> rows = [];

    // Inputs
    rows.add({
      'label': 'Input Consumption =',
      'value': '${item.inputConsumption} Units',
    });
    rows.add({'label': 'Total Capacity =', 'value': '${item.totalCapacity}'});

    solarData.add({'heading': null, 'data': rows});

    return _buildSection(
      contentSections: solarData,
      mainHeading: 'Solar Water Heater Calculation',
    );
  }

  Widget _buildSolarSection(SolarHistoryItem item) {
    List<Map<String, dynamic>> solarData = [];

    List<Map<String, String>> rows = [];

    // Inputs
    rows.add({'label': 'Consumption Type =', 'value': item.consumptionType});
    rows.add({
      'label': 'Input Consumption =',
      'value': '${item.inputConsumption} Units',
    });

    // Results
    rows.add({
      'label': 'Daily Unit =',
      'value': '${item.dailyUnit.toStringAsFixed(2)} Units/day',
    });
    rows.add({
      'label': 'System Capacity =',
      'value': '${item.kwSystem.toStringAsFixed(2)} kW',
    });
    rows.add({
      'label': 'Total Plates =',
      'value': '${item.totalPanels.toStringAsFixed(0)} Plates',
    });
    rows.add({
      'label': 'Rooftop Area =',
      'value':
          '${item.rooftopAreaSqFt.toStringAsFixed(1)} Sqft/${item.rooftopAreaSqM.toStringAsFixed(1)} Sqm',
    });

    solarData.add({'heading': null, 'data': rows});

    return _buildSection(
      contentSections: solarData,
      mainHeading: 'Solar Rooftop Calculation',
    );
  }

  Widget _buildAcSection(AirHistoryItem item) {
    List<Map<String, dynamic>> acData = [];

    List<Map<String, String>> rows = [];

    // Room dimensions
    rows.add({
      'label': 'Length =',
      'value': '${item.lengthFt} ft ${item.lengthIn} in',
    });
    rows.add({
      'label': 'Breadth =',
      'value': '${item.breadthFt} ft ${item.breadthIn} in',
    });
    rows.add({
      'label': 'Height =',
      'value': '${item.heightFt} ft ${item.heightIn} in',
    });

    // Inputs
    rows.add({'label': 'Persons =', 'value': '${item.persons}'});
    rows.add({'label': 'Max Temp =', 'value': '${item.maxTempC} °C'});

    // Results
    rows.add({
      'label': 'AC Size =',
      'value': '${item.tons.toStringAsFixed(2)} Tons',
    });

    acData.add({'heading': null, 'data': rows});

    return _buildSection(
      contentSections: acData,
      mainHeading: 'Air Conditioner Calculation',
    );
  }

  // Water Sump Section
  Widget _buildWaterSumpSection(WaterSumpHistoryItem item) {
    List<Map<String, dynamic>> waterSumpData = [];

    List<Map<String, String>> rows = [];
    rows.add({'label': 'Length =', 'value': '${item.length} m'});
    rows.add({'label': 'Width =', 'value': '${item.width} m'});
    rows.add({'label': 'Depth =', 'value': '${item.depth} m'});
    rows.add({
      'label': 'Volume =',
      'value': '${item.volume.toStringAsFixed(3)} m³',
    });
    rows.add({
      'label': 'Capacity =',
      'value': '${item.capacityInLiters.toStringAsFixed(2)} liters',
    });
    rows.add({
      'label': 'Capacity (Feet) =',
      'value': '${item.capacityInCubicFeet.toStringAsFixed(2)} ft³',
    });

    waterSumpData.add({'heading': null, 'data': rows});

    return _buildSection(
      contentSections: waterSumpData,
      mainHeading: 'Water Sump Calculation',
    );
  }

  Widget _buildKitchenSection(KitchenHistoryItem item) {
    List<Map<String, dynamic>> contentSections = [];

    // User Inputs
    List<Map<String, String>> inputRows = [
      {'label': 'Unit Type', 'value': item.selectedUnit},
      {'label': 'Shape', 'value': item.shape},
      {'label': 'Height (m)', 'value': item.height.toStringAsFixed(2)},
      if (item.width != null)
        {'label': 'Width (m)', 'value': item.width!.toStringAsFixed(2)},
      {'label': 'Depth (m)', 'value': item.depth.toStringAsFixed(2)},
    ];

    if (inputRows.isNotEmpty) {
      contentSections.add({'heading': 'User Inputs', 'data': inputRows});
    }

    // Calculated Results
    List<Map<String, String>> resultRows = [
      {'label': 'Counter Area (m²) :', 'value': item.area.toStringAsFixed(3)},
      //{'label': 'Saved At', 'value': item.savedAt.toStringAsFixed(3)()},
    ];

    if (resultRows.isNotEmpty) {
      contentSections.add({
        'heading': 'Calculated Results',
        'data': resultRows,
      });
    }

    return _buildSection(
      contentSections: contentSections,
      mainHeading: 'Kitchen Counter Details',
    );
  }

  Widget _buildFlooringSection(FlooringHistoryItem item) {
    List<Map<String, dynamic>> contentSections = [];

    // User Inputs
    List<Map<String, String>> inputRows = [
      {'label': 'Unit Type', 'value': item.selectedUnit},
      {
        'label': 'Floor Length (m)',
        'value': item.floorLength.toStringAsFixed(2),
      },
      {'label': 'Floor Width (m)', 'value': item.floorWidth.toStringAsFixed(2)},
      {
        'label': 'Tile Length (ft)',
        'value': item.tileLength.toStringAsFixed(2),
      },
      {'label': 'Tile Width (ft)', 'value': item.tileWidth.toStringAsFixed(2)},
    ];

    if (inputRows.isNotEmpty) {
      contentSections.add({'heading': 'User Inputs', 'data': inputRows});
    }

    // Calculated Results
    List<Map<String, String>> resultRows = [
      {'label': 'Total Tiles', 'value': item.totalTiles.toString()},
      {
        'label': 'Mortar Volume (m³)',
        'value': item.mortarVolume.toStringAsFixed(3),
      },
      {'label': 'Cement Bags', 'value': item.cementBags.toStringAsFixed(2)},
      {'label': 'Sand (Tons)', 'value': item.sandTons.toStringAsFixed(3)},
    ];

    if (resultRows.isNotEmpty) {
      contentSections.add({
        'heading': 'Calculated Results',
        'data': resultRows,
      });
    }

    return _buildSection(
      contentSections: contentSections,
      mainHeading: 'Flooring Details',
    );
  }

  Widget _buildBoundaryWallSection(BoundaryWallItem item) {
    List<Map<String, dynamic>> contentSections = [];

    // User Inputs
    List<Map<String, String>> inputRows = [
      {'label': 'Unit Type', 'value': item.selectedUnit},
      {'label': 'Area Length', 'value': item.areaLength.toStringAsFixed(2)},
      {'label': 'Area Height', 'value': item.areaHeight.toStringAsFixed(2)},
      {'label': 'Bar Length', 'value': item.barLength.toStringAsFixed(2)},
      {'label': 'Bar Height', 'value': item.barHeight.toStringAsFixed(2)},
    ];

    if (inputRows.isNotEmpty) {
      contentSections.add({'heading': 'User Inputs', 'data': inputRows});
    }

    // Calculated Results
    List<Map<String, String>> resultRows = [
      {
        'label': 'Total Horizontal Bars',
        'value': item.totalHorizontalBars.toString(),
      },
      {
        'label': 'Total Vertical Bars',
        'value': item.totalVerticalBars.toString(),
      },
      {'label': 'Total Panels', 'value': item.totalPanels.toString()},
    ];

    if (resultRows.isNotEmpty) {
      contentSections.add({
        'heading': 'Calculated Results',
        'data': resultRows,
      });
    }

    return _buildSection(
      contentSections: contentSections,
      mainHeading: 'Boundary Wall Details',
    );
  }

  Widget _buildConcreteBlockSection(ConcreteBlockHistory item) {
    List<Map<String, dynamic>> contentSections = [];

    // User Inputs
    List<Map<String, String>> inputRows = [
      {'label': 'Length', 'value': "${item.length} m"},
      {'label': 'Height', 'value': "${item.height} m"},
      {'label': 'Thickness', 'value': "${item.thickness} m"},
      {'label': 'Mortar Ratio', 'value': "${item.mortarRatio}:1"},
      {
        'label': 'Block Dimensions',
        'value':
            "${item.blockLength} x ${item.blockWidth} x ${item.blockHeight} m",
      },
      {'label': 'Unit Type', 'value': item.unitType},
    ];

    if (inputRows.isNotEmpty) {
      contentSections.add({'heading': 'User Inputs', 'data': inputRows});
    }

    // Calculated Results
    List<Map<String, String>> resultRows = [
      {'label': 'Total Blocks', 'value': "${item.totalBlocks} Blocks"},
      {
        'label': 'Masonry Volume',
        'value': "${item.masonryVolume.toStringAsFixed(2)} m³",
      },
      {'label': 'Cement', 'value': "${item.cementBags} Bags"},
      {'label': 'Sand', 'value': "${item.sandTons} Tons"},
    ];

    if (resultRows.isNotEmpty) {
      contentSections.add({
        'heading': 'Calculated Results',
        'data': resultRows,
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentSections.map((section) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section['heading'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 4),
              ...List<Widget>.from(
                (section['data'] as List<Map<String, String>>).map((row) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            row['label']!,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          flex: 3,
                          child: Text(
                            row['value']!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 🔹 Plaster Section with inputs + results
  Widget _buildPlasterSection(PlasterHistoryItem item) {
    List<Map<String, dynamic>> contentSections = [];

    /// User Inputs
    List<Map<String, String>> inputRows = [];
    inputRows.add({
      'label': 'Length:',
      'value':
          "${item.lenM} m (${item.lenFT} ft, ${item.lenCM} cm, ${item.lenIN} in)",
    });
    inputRows.add({
      'label': 'Width:',
      'value':
          "${item.widthM} m (${item.widthFT} ft, ${item.widthCM} cm, ${item.widthIN} in)",
    });
    inputRows.add({'label': 'Grade:', 'value': item.grade});

    if (inputRows.isNotEmpty) {
      contentSections.add({'heading': 'User Inputs:', 'data': inputRows});
    }

    /// Results
    List<Map<String, String>> resultRows = [];
    resultRows.add({
      'label': 'Area:',
      'value': "${item.area.toStringAsFixed(2)} ${item.unit}",
    });
    resultRows.add({'label': 'Cement:', 'value': "${item.cementBags} Bags"});
    resultRows.add({'label': 'Sand:', 'value': "${item.sandCft} CFT"});

    if (resultRows.isNotEmpty) {
      contentSections.add({
        'heading': 'Calculated Results:',
        'data': resultRows,
      });
    }

    return _buildSection(contentSections: contentSections);
  }

  // Construction Section
  Widget _buildConstructionSection(ConstructionCostHistoryItem item) {
    Theme.of(context);
    List<Map<String, dynamic>> contentSections = [];

    List<Map<String, String>> detailRows = [];
    if (item.area != null) {
      detailRows.add({'label': 'Area :', 'value': "${item.area}"});
    }
    if (item.costInput != null) {
      detailRows.add({
        'label': 'Cost Input :',
        'value': "${item.costPerSqFt} ${item.unit ?? ''}",
      });
    }
    if (detailRows.isNotEmpty) {
      contentSections.add({'heading': 'Basic Details:', 'data': detailRows});
    }

    List<Map<String, String>> costRows = [];
    if (item.cementCost != null) {
      costRows.add({
        'label': 'Cement =',
        'value': "${item.cementCost} ${item.unit ?? ''}",
      });
    }
    if (item.sandCost != null) {
      costRows.add({
        'label': 'Sand =',
        'value': "${item.sandCost} ${item.unit ?? ''}",
      });
    }
    if (item.aggregateCost != null) {
      costRows.add({
        'label': 'Aggregate =',
        'value': "${item.aggregateCost} ${item.unit ?? ''}",
      });
    }
    if (item.streetCost != null) {
      costRows.add({
        'label': 'Steel =',
        'value': "${item.streetCost} ${item.unit ?? ''}",
      });
    }
    if (item.finishersCost != null) {
      costRows.add({
        'label': 'Finishers =',
        'value': "${item.finishersCost} ${item.unit ?? ''}",
      });
    }
    if (item.fittingsCost != null) {
      costRows.add({
        'label': 'Fittings =',
        'value': "${item.fittingsCost} ${item.unit ?? ''}",
      });
    }
    if (item.totalCost != null) {
      costRows.add({
        'label': 'Total =',
        'value':
            "${item.totalCost?.toStringAsFixed(2) ?? 0} ${item.unit ?? ''}",
      });
    }
    if (costRows.isNotEmpty) {
      contentSections.add({
        'heading': 'Result(Approx. Cost Required):',
        'data': costRows,
      });
    }

    List<Map<String, String>> qtyRows = [];
    if (item.cementQty != null) {
      qtyRows.add({'label': 'Cement =', 'value': "${item.cementQty} Bags"});
    }
    if (item.sandQty != null) {
      qtyRows.add({'label': 'Sand =', 'value': "${item.sandQty} Ton"});
    }
    if (item.aggregateQty != null) {
      qtyRows.add({
        'label': 'Aggregate =',
        'value': "${item.aggregateQty} Ton",
      });
    }
    if (item.streetQty != null) {
      qtyRows.add({'label': 'Steel =', 'value': "${item.streetQty} Kg"});
    }
    if (item.paintQty != null) {
      qtyRows.add({'label': 'Paint =', 'value': "${item.paintQty} lt"});
    }
    if (qtyRows.isNotEmpty) {
      contentSections.add({
        'heading': 'Quantity of Material Required:',
        'data': qtyRows,
      });
    }

    return _buildSection(contentSections: contentSections);
  }

  // Brick Section
  Widget _buildBrickSection(BrickHistoryItem item) {
    List<Map<String, dynamic>> brickData = [];

    String wallLength = "";
    String wallHeight = "";
    String brickSize = "";

    if (item.lenM != null && item.lenCM != null) {
      wallLength = "${item.lenM}m ${item.lenCM}cm";
    } else if (item.lenFT != null && item.lenIN != null) {
      wallLength = "${item.lenFT}ft ${item.lenIN}in";
    }

    if (item.htM != null && item.htCM != null) {
      wallHeight = "${item.htM}m ${item.htCM}cm";
    } else if (item.htFT != null && item.htIN != null) {
      wallHeight = "${item.htFT}ft ${item.htIN}in";
    }

    if (item.brickLcm != null &&
        item.brickWcm != null &&
        item.brickHcm != null) {
      brickSize = "${item.brickLcm}x${item.brickWcm}x${item.brickHcm} cm";
    }

    List<Map<String, String>> rows = [];
    if (wallLength.isNotEmpty) {
      rows.add({'label': 'Length =', 'value': wallLength});
    }
    if (wallHeight.isNotEmpty) {
      rows.add({'label': 'Height =', 'value': wallHeight});
    }
    if (item.thickness != null) {
      rows.add({'label': 'Wall Thickness =', 'value': item.thickness!});
    }
    if (item.mortarX != null) {
      rows.add({'label': 'Mortar Ratio =', 'value': "${item.mortarX}"});
    }
    if (brickSize.isNotEmpty) {
      rows.add({'label': 'Brick Size =', 'value': brickSize});
    }
    if (item.bricksQty != null) {
      rows.add({
        'label': 'Total Bricks =',
        'value': "${item.bricksQty?.toInt()}",
      });
    }

    brickData.add({'heading': null, 'data': rows});

    return _buildSection(
      contentSections: brickData,
      mainHeading: 'Brick Calculation',
    );
  }

  // Cement Section
  Widget _buildCementSection(CementHistoryItem item) {
    List<Map<String, dynamic>> cementData = [];

    List<Map<String, String>> rows = [];
    rows.add({'label': 'Length =', 'value': "${item.lenM}m ${item.lenCM}cm"});
    rows.add({'label': 'Height =', 'value': "${item.htM}m ${item.htCM}cm"});
    rows.add({'label': 'Depth =', 'value': "${item.depthCM}cm"});
    rows.add({'label': 'Grade =', 'value': item.grade});
    rows.add({
      'label': 'Volume =',
      'value': "${item.volume.toStringAsFixed(3)} m³",
    });
    rows.add({
      'label': 'Cement Bags =',
      'value': item.cementBags.toStringAsFixed(3),
    });
    rows.add({'label': 'Sand  =', 'value': item.sandCft.toStringAsFixed(2)});
    rows.add({
      'label': 'Aggregate =',
      'value': item.aggregateCft.toStringAsFixed(2),
    });
    rows.add({'label': 'Unit =', 'value': item.unit});

    cementData.add({'heading': null, 'data': rows});

    return _buildSection(
      contentSections: cementData,
      mainHeading: 'Cement Calculation',
    );
  }

  // Flexible Section Builder
  Widget _buildSection({
    required List<Map<String, dynamic>> contentSections,
    String? mainHeading,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mainHeading != null && mainHeading.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              mainHeading,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF9C00),
              ),
            ),
          ),
        ...contentSections.map((section) {
          final heading = section['heading'] as String?;
          final data = section['data'] as List<Map<String, String>>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (heading != null && heading.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    heading,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ...data.map(
                (row) => _buildDetailRow(row['label']!, row['value']!),
              ),
              if ((heading != null && heading.isNotEmpty) || data.isNotEmpty)
                const SizedBox(height: 8),
            ],
          );
          // ignore: unnecessary_to_list_in_spreads
        }).toList(),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.orange : theme.colorScheme.onSurface,
              fontSize: isTotal ? 16 : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllConfirmation(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            Text(
              "Are you sure?",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          "Do you really want to delete all history?",
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              ref.read(unifiedHistoryProvider.notifier).clearAll();
            },
            child: const Text("Yes, Delete"),
          ),
        ],
      ),
    );
  }

  void _showDeleteSingleConfirmation(int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            Text(
              "Are you sure?",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          "Do you want to delete this history entry?",
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              ref.read(unifiedHistoryProvider.notifier).deleteHistory(index);
            },
            child: const Text("Yes, Delete"),
          ),
        ],
      ),
    );
  }
}
