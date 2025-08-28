import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/air_history_item.dart';
import 'package:construction_calculator/Domain/entities/angle_history_item.dart';
import 'package:construction_calculator/Domain/entities/anti_termite_history_item.dart';
import 'package:construction_calculator/Domain/entities/beam_steal_history_item.dart';
import 'package:construction_calculator/Domain/entities/boundary_wall_history_item.dart';
import 'package:construction_calculator/Domain/entities/brick_history_item.dart';
import 'package:construction_calculator/Domain/entities/cement_history_item.dart';
import 'package:construction_calculator/Domain/entities/civilunitconversion_history_item.dart';
import 'package:construction_calculator/Domain/entities/concrete_tube_history_item.dart';
import 'package:construction_calculator/Domain/entities/concreteblock_history_item.dart';
import 'package:construction_calculator/Domain/entities/construction_cost_history_item.dart';
import 'package:construction_calculator/Domain/entities/distance_history_item.dart';
import 'package:construction_calculator/Domain/entities/excavation_history_item.dart';
import 'package:construction_calculator/Domain/entities/flooring_history_item.dart';
import 'package:construction_calculator/Domain/entities/frequency_history_item.dart';
import 'package:construction_calculator/Domain/entities/fuel_history_item.dart';
import 'package:construction_calculator/Domain/entities/kitchen_history_item.dart';
import 'package:construction_calculator/Domain/entities/mass_history_item.dart';
import 'package:construction_calculator/Domain/entities/paint_history_item.dart';
import 'package:construction_calculator/Domain/entities/plaster_history_item.dart';
import 'package:construction_calculator/Domain/entities/plywood_sheet_history_item.dart';
import 'package:construction_calculator/Domain/entities/pressure_history_item.dart';
import 'package:construction_calculator/Domain/entities/roof_pitch_history_item.dart';
import 'package:construction_calculator/Domain/entities/round_column_history_item.dart';
import 'package:construction_calculator/Domain/entities/round_steal_history_item.dart';
import 'package:construction_calculator/Domain/entities/solar_roofttop_history_item.dart';
import 'package:construction_calculator/Domain/entities/solor_waterheater_history_item.dart';
import 'package:construction_calculator/Domain/entities/speed_history_item.dart';
import 'package:construction_calculator/Domain/entities/square_bar_history_item.dart';
import 'package:construction_calculator/Domain/entities/stair_history_item.dart';
import 'package:construction_calculator/Domain/entities/steal_we_history_item.dart';
import 'package:construction_calculator/Domain/entities/steal_weight_history_item.dart';
import 'package:construction_calculator/Domain/entities/time_history_item.dart';
import 'package:construction_calculator/Domain/entities/topsoil_history_item.dart';
import 'package:construction_calculator/Domain/entities/water_sump_history_item.dart';
import 'package:construction_calculator/Domain/entities/wood_frame_history_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveSetup {
  static Future<void> init() async {
    await Hive.initFlutter();

    // ✅ Register all adapters
    _registerAdapters();

    // ✅ Open all boxes
    await _openBoxes();
  }

  static void _registerAdapters() {
    Hive.registerAdapter(ConstructionCostHistoryItemAdapter());
    Hive.registerAdapter(BrickHistoryItemAdapter());
    Hive.registerAdapter(CementHistoryItemAdapter());
    Hive.registerAdapter(PlasterHistoryItemAdapter());
    Hive.registerAdapter(ConcreteBlockHistoryAdapter());
    Hive.registerAdapter(BoundaryWallItemAdapter()); // ye sahi hai
    Hive.registerAdapter(FlooringHistoryItemAdapter());
    Hive.registerAdapter(KitchenHistoryItemAdapter());
    Hive.registerAdapter(WaterSumpHistoryItemAdapter());
    Hive.registerAdapter(AirHistoryItemAdapter());
    Hive.registerAdapter(SolarHistoryItemAdapter());
    Hive.registerAdapter(SolarWaterHistoryItemAdapter());
    Hive.registerAdapter(PaintHistoryItemAdapter());
    Hive.registerAdapter(ExcavationHistoryItemAdapter());
    Hive.registerAdapter(WoodFrameHistoryItemAdapter());
    Hive.registerAdapter(PlywoodSheetItemAdapter());
    Hive.registerAdapter(AntiTermiteHistoryItemAdapter());
    Hive.registerAdapter(RoundColumnHistoryItemAdapter());
    Hive.registerAdapter(StairHistoryItemAdapter());
    Hive.registerAdapter(TopSoilHistoryItemAdapter());
    Hive.registerAdapter(ConcreteTubeHistoryItemAdapter());
    Hive.registerAdapter(RoofPitchHistoryItemAdapter());
    Hive.registerAdapter(ConversionHistoryAdapter());
    Hive.registerAdapter(StealWeightHistoryAdapter());
    Hive.registerAdapter(StealHistoryItemAdapter());
    Hive.registerAdapter(BeamStealHistoryItemAdapter());
    Hive.registerAdapter(RoundStealHistoryItemAdapter());
    Hive.registerAdapter(DistanceHistoryItemAdapter());

    Hive.registerAdapter(AngleHistoryItemAdapter());
    Hive.registerAdapter(FrequencyHistoryItemAdapter());
    Hive.registerAdapter(FuelHistoryItemAdapter());
    Hive.registerAdapter(SpeedHistoryItemAdapter());
    Hive.registerAdapter(PressureHistoryItemAdapter());
    Hive.registerAdapter(MassHistoryItemAdapter());
    Hive.registerAdapter(TimeHistoryItemAdapter());
  }

  static Future<void> _openBoxes() async {
    // Open the box

    await Hive.openBox<AngleHistoryItem>(HiveBoxes.angleHistory);
    await Hive.openBox<FrequencyHistoryItem>(HiveBoxes.frequencyHistory);
    await Hive.openBox<FuelHistoryItem>(HiveBoxes.fuelHistory);
    await Hive.openBox<SpeedHistoryItem>(HiveBoxes.speedHistory);
    await Hive.openBox<PressureHistoryItem>(HiveBoxes.pressureHistory);
    await Hive.openBox<MassHistoryItem>(HiveBoxes.massHistory);
    await Hive.openBox<TimeHistoryItem>(HiveBoxes.timeHistory);

    await Hive.openBox<DistanceHistoryItem>(HiveBoxes.distanceHistory);
    await Hive.openBox<SquareBarHistoryItem>(HiveBoxes.squareBarHistory);
    await Hive.openBox<RoundStealHistoryItem>(HiveBoxes.roundHistory);
    await Hive.openBox<BeamStealHistoryItem>(HiveBoxes.beamHistory);
    await Hive.openBox<StealHistoryItem>(HiveBoxes.stealHistory);
    await Hive.openBox<StealWeightHistory>(HiveBoxes.stealWeightHistory);
    await Hive.openBox<ConversionHistory>(HiveBoxes.civilUnitHistory);
    await Hive.openBox<RoofPitchHistoryItem>(HiveBoxes.roofPitchHistory);
    await Hive.openBox<ConcreteTubeHistoryItem>(HiveBoxes.concreteTubeHistory);
    await Hive.openBox<TopSoilHistoryItem>(HiveBoxes.topSoilHistory);
    await Hive.openBox<StairHistoryItem>(HiveBoxes.stairCaseHistory);
    await Hive.openBox<RoundColumnHistoryItem>(HiveBoxes.roundColumnHistory);
    await Hive.openBox<AntiTermiteHistoryItem>(HiveBoxes.antiTermiteHistory);
    await Hive.openBox<PlywoodSheetItem>(HiveBoxes.plywoodSheetHistory);
    await Hive.openBox<WoodFrameHistoryItem>(HiveBoxes.woodFrameHistory);
    await Hive.openBox<ExcavationHistoryItem>(HiveBoxes.excavationHistory);
    await Hive.openBox<PaintHistoryItem>(HiveBoxes.paintHistory);
    await Hive.openBox<SolarWaterHistoryItem>(
      HiveBoxes.solarWaterHeaterHistory,
    );
    await Hive.openBox<SolarHistoryItem>(HiveBoxes.solarHistory);
    await Hive.openBox<ConstructionCostHistoryItem>(
      HiveBoxes.constructionCostHistory,
    );
    await Hive.openBox<CementHistoryItem>(HiveBoxes.cementHistory);
    await Hive.openBox<BrickHistoryItem>(HiveBoxes.brickHistory);
    await Hive.openBox<PlasterHistoryItem>(HiveBoxes.plasterHistory);
    await Hive.openBox<ConcreteBlockHistory>(HiveBoxes.concreteBlockHistory);
    await Hive.openBox<BoundaryWallItem>(HiveBoxes.boundaryWallHistory);
    await Hive.openBox<FlooringHistoryItem>(HiveBoxes.flooringHistory);
    await Hive.openBox<KitchenHistoryItem>('kitchen_history');
    await Hive.openBox<WaterSumpHistoryItem>('water_sump_history');
    await Hive.openBox<AirHistoryItem>('air_history');
  }
}
