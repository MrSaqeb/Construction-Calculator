import 'package:construction_calculator/Core/Hive/hive_box.dart';
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
    Hive.registerAdapter(CircleHistoryItemAdapter());
    Hive.registerAdapter(RectangleHistoryItemAdapter());
    Hive.registerAdapter(LShapeHistoryItemAdapter());
    Hive.registerAdapter(HemisphereHistoryItemAdapter());
    Hive.registerAdapter(SectorHistoryItemAdapter());
    Hive.registerAdapter(ArchHistoryItemAdapter());
    Hive.registerAdapter(RectangleWithSlotHistoryItemAdapter());

    Hive.registerAdapter(VerticalCylinderHistoryItemAdapter());

    Hive.registerAdapter(HorizontalCylinderItemAdapter());

    Hive.registerAdapter(RectangularPrismItemAdapter());
    Hive.registerAdapter(VerticalCapsuleItemAdapter());
    Hive.registerAdapter(HorizontalCapsuleItemAdapter());
    Hive.registerAdapter(VerticalEllipticalItemAdapter());
    Hive.registerAdapter(HorizontalEllipticalHistoryItemAdapter());
    Hive.registerAdapter(ConeBottomHistoryItemAdapter());
    Hive.registerAdapter(ConeTopHistoryItemAdapter());
    Hive.registerAdapter(FrustumHistoryItemAdapter());
  }

  static Future<void> _openBoxes() async {
    // Open the box

    await Hive.openBox<HorizontalCapsuleItem>(
      HiveBoxes.horizontalCapsuleHistory,
    );

    await Hive.openBox<VerticalEllipticalItem>(
      HiveBoxes.verticalEllipticalHistory,
    );

    await Hive.openBox<HorizontalEllipticalHistoryItem>(
      HiveBoxes.horizontalEllipticalHistory,
    );

    await Hive.openBox<ConeBottomHistoryItem>(HiveBoxes.coneBottomHistory);

    await Hive.openBox<ConeTopHistoryItem>(HiveBoxes.coneTopHistory);

    await Hive.openBox<FrustumHistoryItem>(HiveBoxes.frustumHistory);

    await Hive.openBox<VerticalCapsuleItem>(HiveBoxes.verticalCapsuleHistory);

    await Hive.openBox<RectangularPrismItem>(HiveBoxes.rectangularPrismHistory);

    await Hive.openBox<HorizontalCylinderItem>(
      HiveBoxes.horizontalCylinderHistory,
    );

    await Hive.openBox<VerticalCylinderHistoryItem>(HiveBoxes.verticalHistory);

    await Hive.openBox<RectangleHistoryItem>(HiveBoxes.rectangleHistory);
    await Hive.openBox<LShapeHistoryItem>(HiveBoxes.lShapeHistory);
    await Hive.openBox<HemisphereHistoryItem>(HiveBoxes.hemisphereHistory);
    await Hive.openBox<SectorHistoryItem>(HiveBoxes.sectorHistory);
    await Hive.openBox<ArchHistoryItem>(HiveBoxes.archHistory);
    await Hive.openBox<RectangleWithSlotHistoryItem>(
      HiveBoxes.rectangleWithSlotHistory,
    );

    await Hive.openBox<CircleHistoryItem>(HiveBoxes.circleHistory);
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
