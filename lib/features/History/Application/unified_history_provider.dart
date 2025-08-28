import 'package:construction_calculator/Domain/entities/air_history_item.dart';
import 'package:construction_calculator/Domain/entities/angle_history_item.dart';
import 'package:construction_calculator/Domain/entities/anti_termite_history_item.dart';
import 'package:construction_calculator/Domain/entities/beam_steal_history_item.dart';
import 'package:construction_calculator/Domain/entities/boundary_wall_history_item.dart';
import 'package:construction_calculator/Domain/entities/civilunitconversion_history_item.dart';
import 'package:construction_calculator/Domain/entities/concrete_tube_history_item.dart';
import 'package:construction_calculator/Domain/entities/concreteblock_history_item.dart';
import 'package:construction_calculator/Domain/entities/distance_history_item.dart';
import 'package:construction_calculator/Domain/entities/excavation_history_item.dart';
import 'package:construction_calculator/Domain/entities/flooring_history_item.dart';
import 'package:construction_calculator/Domain/entities/frequency_history_item.dart';
import 'package:construction_calculator/Domain/entities/fuel_history_item.dart';
import 'package:construction_calculator/Domain/entities/kitchen_history_item.dart';
import 'package:construction_calculator/Domain/entities/mass_history_item.dart';
import 'package:construction_calculator/Domain/entities/paint_history_item.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/brick_history_item.dart';
import 'package:construction_calculator/Domain/entities/construction_cost_history_item.dart';
import 'package:construction_calculator/Domain/entities/cement_history_item.dart';
import 'package:construction_calculator/Domain/entities/plaster_history_item.dart';

/// A unified history item to store any type of history in one list
class HistoryItem {
  final String type;
  final dynamic data; // History entity
  final DateTime timestamp;

  HistoryItem({
    required this.type,
    required this.data,
    required this.timestamp,
  });
}

/// Unified notifier
class UnifiedHistoryNotifier extends StateNotifier<List<HistoryItem>> {
  final Box<BrickHistoryItem> brickBox;
  final Box<ConstructionCostHistoryItem> constructionBox;
  final Box<CementHistoryItem> cementBox;
  final Box<PlasterHistoryItem> plasterBox;
  final Box<ConcreteBlockHistory> concreteBlockBox;
  final Box<BoundaryWallItem> boundaryWallBox;
  final Box<FlooringHistoryItem> flooringBox;
  final Box<KitchenHistoryItem> kitchenBox;
  final Box<WaterSumpHistoryItem> waterBox;
  final Box<AirHistoryItem> airBox;
  final Box<SolarHistoryItem> solorBox;
  final Box<SolarWaterHistoryItem> solorwaterheaterBox;
  final Box<PaintHistoryItem> paintBox;
  final Box<ExcavationHistoryItem> excavationBox;
  final Box<WoodFrameHistoryItem> woodframeBox;
  final Box<PlywoodSheetItem> plywoodsheetBox;
  final Box<AntiTermiteHistoryItem> antitermiteBox;
  final Box<RoundColumnHistoryItem> roundcolumnBox;
  final Box<StairHistoryItem> stairBox;
  final Box<TopSoilHistoryItem> topsoilBox;
  final Box<ConcreteTubeHistoryItem> concreteTubeBox;
  final Box<RoofPitchHistoryItem> roofBox;
  final Box<ConversionHistory> civilunitBox;
  final Box<StealWeightHistory> stealweightBox;
  final Box<StealHistoryItem> stealBox;
  final Box<BeamStealHistoryItem> beamBox;
  final Box<RoundStealHistoryItem> roundBox;
  final Box<SquareBarHistoryItem> sqbarBox;
  final Box<DistanceHistoryItem> distanceBox;

  final Box<AngleHistoryItem> angleBox;
  final Box<FrequencyHistoryItem> frequencyBox;
  final Box<FuelHistoryItem> fuelBox;
  final Box<SpeedHistoryItem> speedBox;
  final Box<PressureHistoryItem> pressureBox;
  final Box<MassHistoryItem> massBox;
  final Box<TimeHistoryItem> timeBox;
  final int maxHistoryItems;

  UnifiedHistoryNotifier({
    required this.angleBox,
    required this.frequencyBox,
    required this.fuelBox,
    required this.speedBox,
    required this.massBox,
    required this.pressureBox,
    required this.timeBox,
    required this.distanceBox,
    required this.sqbarBox,
    required this.roundBox,
    required this.beamBox,
    required this.stealBox,
    required this.stealweightBox,
    required this.civilunitBox,
    required this.roofBox,
    required this.concreteTubeBox,
    required this.topsoilBox,
    required this.stairBox,
    required this.roundcolumnBox,
    required this.antitermiteBox,
    required this.plywoodsheetBox,
    required this.woodframeBox,
    required this.excavationBox,
    required this.airBox,
    required this.brickBox,
    required this.constructionBox,
    required this.cementBox,
    required this.plasterBox,
    required this.concreteBlockBox,
    required this.boundaryWallBox,
    required this.flooringBox,
    required this.kitchenBox,
    required this.waterBox,
    required this.solorBox,
    required this.solorwaterheaterBox,
    required this.paintBox,
    this.maxHistoryItems = 50,
  }) : super([]) {
    _loadInitialHistory();
  }

  void _loadInitialHistory() {
    final allItems = <HistoryItem>[];

    for (var item in brickBox.values) {
      allItems.add(
        HistoryItem(type: "brick", data: item, timestamp: DateTime.now()),
      );
    }
    for (var item in constructionBox.values) {
      allItems.add(
        HistoryItem(
          type: "construction",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in cementBox.values) {
      allItems.add(
        HistoryItem(type: "cement", data: item, timestamp: DateTime.now()),
      );
    }
    for (var item in plasterBox.values) {
      allItems.add(
        HistoryItem(type: "plaster", data: item, timestamp: DateTime.now()),
      );
    }
    for (var item in concreteBlockBox.values) {
      allItems.add(
        HistoryItem(
          type: "concreteBlock",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in boundaryWallBox.values) {
      allItems.add(
        HistoryItem(
          type: "boundaryWall",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in flooringBox.values) {
      allItems.add(
        HistoryItem(type: "flooring", data: item, timestamp: DateTime.now()),
      );
    }
    for (var item in kitchenBox.values) {
      allItems.add(
        HistoryItem(type: "kitchen", data: item, timestamp: DateTime.now()),
      );
    }
    for (var item in waterBox.values) {
      allItems.add(
        HistoryItem(
          type: "water_sump_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in airBox.values) {
      allItems.add(
        HistoryItem(type: "air_history", data: item, timestamp: DateTime.now()),
      );
    }
    for (var item in solorBox.values) {
      allItems.add(
        HistoryItem(
          type: "solar_rooftop_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in solorwaterheaterBox.values) {
      allItems.add(
        HistoryItem(
          type: "solar_waterheater_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in paintBox.values) {
      allItems.add(
        HistoryItem(
          type: "paint_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in excavationBox.values) {
      allItems.add(
        HistoryItem(
          type: "excavation_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in woodframeBox.values) {
      allItems.add(
        HistoryItem(
          type: "wood_frame_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in plywoodsheetBox.values) {
      allItems.add(
        HistoryItem(
          type: "plywood_sheet_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in antitermiteBox.values) {
      allItems.add(
        HistoryItem(
          type: "anti_termite_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in roundcolumnBox.values) {
      allItems.add(
        HistoryItem(
          type: "round_column_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in stairBox.values) {
      allItems.add(
        HistoryItem(
          type: "stair_case_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in topsoilBox.values) {
      allItems.add(
        HistoryItem(
          type: "topsoil_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in concreteTubeBox.values) {
      allItems.add(
        HistoryItem(
          type: "concrete_tube_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in roofBox.values) {
      allItems.add(
        HistoryItem(
          type: "roof_pitch_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in civilunitBox.values) {
      allItems.add(
        HistoryItem(
          type: "civil_unit_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in stealweightBox.values) {
      allItems.add(
        HistoryItem(
          type: "steal_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in stealBox.values) {
      allItems.add(
        HistoryItem(
          type: "steal_weight_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in beamBox.values) {
      allItems.add(
        HistoryItem(
          type: "beam_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in roundBox.values) {
      allItems.add(
        HistoryItem(
          type: "round_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }
    for (var item in sqbarBox.values) {
      allItems.add(
        HistoryItem(
          type: "square_bar_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }

    for (var item in distanceBox.values) {
      allItems.add(
        HistoryItem(
          type: "distance_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }

    // ✅ Time Converter
    for (var item in timeBox.values) {
      allItems.add(
        HistoryItem(
          type: "time_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }

    // ✅ Mass Converter
    for (var item in massBox.values) {
      allItems.add(
        HistoryItem(
          type: "mass_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }

    // ✅ Pressure Converter
    for (var item in pressureBox.values) {
      allItems.add(
        HistoryItem(
          type: "pressure_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }

    // ✅ Speed Converter
    for (var item in speedBox.values) {
      allItems.add(
        HistoryItem(
          type: "speed_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }

    // ✅ Fuel Converter
    for (var item in fuelBox.values) {
      allItems.add(
        HistoryItem(
          type: "fuel_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }

    // ✅ Frequency Converter
    for (var item in frequencyBox.values) {
      allItems.add(
        HistoryItem(
          type: "frequency_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }

    // ✅ Angle Converter
    for (var item in angleBox.values) {
      allItems.add(
        HistoryItem(
          type: "angle_history",
          data: item,
          timestamp: DateTime.now(),
        ),
      );
    }

    state = allItems;
  }

  void addAngle(AngleHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'angle_history',
      data: item,
      timestamp: DateTime.now(),
    );

    final exists = state.any((h) {
      if (h.type != 'angle_history') return false;
      final existing = h.data as AngleHistoryItem;
      return existing.inputValue == item.inputValue &&
          existing.inputUnit == item.inputUnit &&
          mapEquals(existing.convertedValues, item.convertedValues);
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addFrequency(FrequencyHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'frequency_history',
      data: item,
      timestamp: DateTime.now(),
    );

    final exists = state.any((h) {
      if (h.type != 'frequency_history') return false;
      final existing = h.data as FrequencyHistoryItem;
      return existing.inputValue == item.inputValue &&
          existing.inputUnit == item.inputUnit &&
          mapEquals(existing.convertedValues, item.convertedValues);
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addFuel(FuelHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'fuel_history',
      data: item,
      timestamp: DateTime.now(),
    );

    final exists = state.any((h) {
      if (h.type != 'fuel_history') return false;
      final existing = h.data as FuelHistoryItem;
      return existing.inputValue == item.inputValue &&
          existing.inputUnit == item.inputUnit &&
          mapEquals(existing.convertedValues, item.convertedValues);
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addSpeed(SpeedHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'speed_history',
      data: item,
      timestamp: DateTime.now(),
    );

    final exists = state.any((h) {
      if (h.type != 'speed_history') return false;
      final existing = h.data as SpeedHistoryItem;
      return existing.inputValue == item.inputValue &&
          existing.inputUnit == item.inputUnit &&
          mapEquals(existing.convertedValues, item.convertedValues);
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addPressure(PressureHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'pressure_history',
      data: item,
      timestamp: DateTime.now(),
    );

    final exists = state.any((h) {
      if (h.type != 'pressure_history') return false;
      final existing = h.data as PressureHistoryItem;
      return existing.inputValue == item.inputValue &&
          existing.inputUnit == item.inputUnit &&
          mapEquals(existing.convertedValues, item.convertedValues);
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addMass(MassHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'mass_history',
      data: item,
      timestamp: DateTime.now(),
    );

    final exists = state.any((h) {
      if (h.type != 'mass_history') return false;
      final existing = h.data as MassHistoryItem;
      return existing.inputValue == item.inputValue &&
          existing.inputUnit == item.inputUnit &&
          mapEquals(existing.convertedValues, item.convertedValues);
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addTime(TimeHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'time_history',
      data: item,
      timestamp: DateTime.now(),
    );

    final exists = state.any((h) {
      if (h.type != 'time_history') return false;
      final existing = h.data as TimeHistoryItem;
      return existing.inputValue == item.inputValue &&
          existing.inputUnit == item.inputUnit &&
          mapEquals(existing.convertedValues, item.convertedValues);
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addDistance(DistanceHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'distance_history',
      data: item,
      timestamp: DateTime.now(),
    );

    // Duplicate check
    final exists = state.any((h) {
      if (h.type != 'distance_history') return false;
      final existing = h.data as DistanceHistoryItem;
      return existing.inputValue == item.inputValue &&
          existing.inputUnit == item.inputUnit &&
          mapEquals(existing.convertedValues, item.convertedValues);
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addSquareBar(SquareBarHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'square_bar_history',
      data: item,
      timestamp: DateTime.now(),
    );

    // Duplicate check
    final exists = state.any((h) {
      if (h.type != 'square_bar_history') return false;
      final existing = h.data as SquareBarHistoryItem;
      return existing.side == item.side &&
          existing.length == item.length &&
          existing.pieces == item.pieces &&
          existing.material == item.material &&
          existing.lengthUnit == item.lengthUnit &&
          existing.weightUnit == item.weightUnit &&
          existing.costPerKg == item.costPerKg &&
          existing.weightKg == item.weightKg &&
          existing.weightTons == item.weightTons &&
          existing.totalCost == item.totalCost;
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addRoundSteel(RoundStealHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'round_history',
      data: item,
      timestamp: DateTime.now(),
    );

    // Duplicate check
    final exists = state.any((h) {
      if (h.type != 'round_history') return false;
      final existing = h.data as RoundStealHistoryItem;
      return existing.diameter == item.diameter &&
          existing.length == item.length &&
          existing.pieces == item.pieces &&
          existing.material == item.material &&
          existing.lengthUnit == item.lengthUnit &&
          existing.weightUnit == item.weightUnit &&
          existing.costPerKg == item.costPerKg &&
          existing.weightKg == item.weightKg &&
          existing.weightTons == item.weightTons &&
          existing.totalCost == item.totalCost;
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addBeamSteel(BeamStealHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'beam_history',
      data: item,
      timestamp: DateTime.now(),
    );

    // Duplicate check
    final exists = state.any((h) {
      if (h.type != 'beam_history') return false;
      final existing = h.data as BeamStealHistoryItem;
      return existing.sizeA == item.sizeA &&
          existing.sizeB == item.sizeB &&
          existing.sizeT == item.sizeT &&
          existing.sizeS == item.sizeS &&
          existing.length == item.length &&
          existing.pieces == item.pieces &&
          existing.material == item.material &&
          existing.lengthUnit == item.lengthUnit &&
          existing.weightUnit == item.weightUnit &&
          existing.costPerKg == item.costPerKg &&
          existing.weightKg == item.weightKg &&
          existing.weightTons == item.weightTons &&
          existing.totalCost == item.totalCost;
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addSteelWeight(StealHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'steal_weight_history',
      data: item,
      timestamp: DateTime.now(),
    );

    // Duplicate check
    final exists = state.any((h) {
      if (h.type != 'steal_weight_history') return false;
      final existing = h.data as StealHistoryItem;
      return existing.diameter == item.diameter &&
          existing.length == item.length &&
          existing.quantity == item.quantity &&
          existing.volume == item.volume;
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addCivilUnit(ConversionHistory item) {
    final newHistoryItem = HistoryItem(
      type: 'civil_unit_history',
      data: item,
      timestamp: DateTime.now(),
    );

    // Duplicate check (optional)
    final exists = state.any((h) {
      if (h.type != 'civil_unit_history') return false;
      final existing = h.data as ConversionHistory;
      return existing.inputValue == item.inputValue &&
          existing.fromUnit == item.fromUnit &&
          existing.toUnit == item.toUnit &&
          existing.resultValue == item.resultValue;
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  void addSteelWeightHistory(StealWeightHistory item) {
    final newHistoryItem = HistoryItem(
      type: 'steal_history',
      data: item,
      timestamp: DateTime.now(),
    );

    // Optional: duplicate check
    final exists = state.any((h) {
      if (h.type != 'steal_history') return false;
      final existing = h.data as StealWeightHistory;
      return existing.inputVolume == item.inputVolume &&
          existing.steelType == item.steelType &&
          existing.calculatedWeight == item.calculatedWeight;
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  // Roof pitch history add karne ka function
  void addRoofPitchHistory(RoofPitchHistoryItem item) {
    final newHistoryItem = HistoryItem(
      type: 'roof_pitch_history',
      data: item,
      timestamp: DateTime.now(),
    );

    // Duplicate check (optional)
    final exists = state.any((h) {
      if (h.type != 'roof_pitch_history') return false;
      final existing = h.data as RoofPitchHistoryItem;
      return existing.heightM == item.heightM &&
          existing.heightCM == item.heightCM &&
          existing.heightFT == item.heightFT &&
          existing.heightIN == item.heightIN &&
          existing.widthM == item.widthM &&
          existing.widthCM == item.widthCM &&
          existing.widthFT == item.widthFT &&
          existing.widthIN == item.widthIN &&
          existing.unit == item.unit;
    });

    if (!exists) {
      state = [...state, newHistoryItem];
    }
  }

  Future<void> addConcreteTubeHistory(ConcreteTubeHistoryItem item) async {
    // 1️⃣ Open Hive box
    final box = await Hive.openBox<ConcreteTubeHistoryItem>(
      HiveBoxes.concreteTubeHistory, // Make sure you defined this constant
    );

    // 2️⃣ Duplicate check (based on inner/outer diameters, height, and number of tubes)
    final exists = box.values.any(
      (e) =>
          e.innerM == item.innerM &&
          e.innerCM == item.innerCM &&
          e.outerM == item.outerM &&
          e.outerCM == item.outerCM &&
          e.heightM == item.heightM &&
          e.heightCM == item.heightCM &&
          e.noOfTubes == item.noOfTubes &&
          e.grade == item.grade &&
          e.unit == item.unit,
    );

    // 3️⃣ Add only if not duplicate
    if (!exists) {
      final key = await box.add(item);
      final savedItem = box.get(key);

      if (savedItem != null) {
        // 4️⃣ Push into unified history provider state
        _addToState(
          HistoryItem(
            type: "concrete_tube_history",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<void> addTopSoilHistory(TopSoilHistoryItem item) async {
    // 1️⃣ Open Hive box
    final box = await Hive.openBox<TopSoilHistoryItem>(
      HiveBoxes.topSoilHistory, // ✅ HiveBoxes me constant define karna
    );

    // 2️⃣ Duplicate check (based on inputs and result)
    final exists = box.values.any(
      (e) =>
          e.length == item.length &&
          e.width == item.width &&
          e.depth == item.depth &&
          e.volume == item.volume,
    );

    // 3️⃣ Add only if not duplicate
    if (!exists) {
      final key = await box.add(item);
      final savedItem = box.get(key);

      if (savedItem != null) {
        // 4️⃣ Push into unified history
        _addToState(
          HistoryItem(
            type: "topsoil_history",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<void> addStairHistory(StairHistoryItem item) async {
    // 1️⃣ Open Hive box
    final box = await Hive.openBox<StairHistoryItem>(
      HiveBoxes.stairCaseHistory, // ✅ HiveBoxes me constant define karna
    );

    // 2️⃣ Duplicate check (riser, tread, width, height, waist, grade, results ke basis par)
    final exists = box.values.any(
      (e) =>
          e.riserFT == item.riserFT &&
          e.riserIN == item.riserIN &&
          e.treadFT == item.treadFT &&
          e.treadIN == item.treadIN &&
          e.stairWidthFT == item.stairWidthFT &&
          e.stairHeightFT == item.stairHeightFT &&
          e.waistSlabIN == item.waistSlabIN &&
          e.grade == item.grade &&
          e.volume == item.volume &&
          e.cementBags == item.cementBags &&
          e.sand == item.sand &&
          e.aggregate == item.aggregate,
    );

    // 3️⃣ Add only if not duplicate
    if (!exists) {
      final key = await box.add(item);
      final savedItem = box.get(key);

      if (savedItem != null) {
        // 4️⃣ Push into unified history
        _addToState(
          HistoryItem(
            type: "stair_case_history",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<void> addRoundColumn(RoundColumnHistoryItem item) async {
    // 1️⃣ Open Hive box
    final box = await Hive.openBox<RoundColumnHistoryItem>(
      HiveBoxes.roundColumnHistory, // ✅ HiveBoxes me constant add karna hoga
    );

    // 2️⃣ Duplicate check (diameter + height + noOfColumns + grade + volume ke base par)
    final exists = box.values.any(
      (e) =>
          e.diM == item.diM &&
          e.diCM == item.diCM &&
          e.diFT == item.diFT &&
          e.diIN == item.diIN &&
          e.htM == item.htM &&
          e.htCM == item.htCM &&
          e.htFT == item.htFT &&
          e.htIN == item.htIN &&
          e.noOfColumns == item.noOfColumns &&
          e.grade == item.grade &&
          e.unit == item.unit &&
          e.volume == item.volume &&
          e.cementBags == item.cementBags &&
          e.sandCft == item.sandCft &&
          e.aggregateCft == item.aggregateCft,
    );

    // 3️⃣ Add only if not duplicate
    if (!exists) {
      final key = await box.add(item);
      final savedItem = box.get(key);

      if (savedItem != null) {
        // 4️⃣ Push into unified history
        _addToState(
          HistoryItem(
            type: "round_column_history",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<void> addAntiTermite(AntiTermiteHistoryItem item) async {
    // 1️⃣ Open Hive box
    final box = await Hive.openBox<AntiTermiteHistoryItem>(
      HiveBoxes.antiTermiteHistory, // ✅ isko HiveBoxes me add karna hoga
    );

    // 2️⃣ Duplicate check (length, width, unit aur area + chemical ke base par)
    final exists = box.values.any(
      (e) =>
          e.lenM == item.lenM &&
          e.lenCM == item.lenCM &&
          e.lenFT == item.lenFT &&
          e.lenIN == item.lenIN &&
          e.widthM == item.widthM &&
          e.widthCM == item.widthCM &&
          e.widthFT == item.widthFT &&
          e.widthIN == item.widthIN &&
          e.area == item.area &&
          e.chemicalQuantity == item.chemicalQuantity &&
          e.unit == item.unit,
    );

    // 3️⃣ Add only if not duplicate
    if (!exists) {
      final key = await box.add(item);
      final savedItem = box.get(key);

      if (savedItem != null) {
        // 4️⃣ Push into unified history
        _addToState(
          HistoryItem(
            type: "anti_termite_history",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<void> addPlywoodSheetHistory(PlywoodSheetItem item) async {
    // 1️⃣ Open Hive box
    final box = await Hive.openBox<PlywoodSheetItem>(
      HiveBoxes.plywoodSheetHistory, // ⚡ isko HiveBoxes me define karna hoga
    );

    // 2️⃣ Duplicate check (length, width, ply length, ply width, total sheets, unit, date)
    final exists = box.values.any(
      (e) =>
          e.roomLength == item.roomLength &&
          e.roomWidth == item.roomWidth &&
          e.plyLength == item.plyLength &&
          e.plyWidth == item.plyWidth &&
          e.totalSheets == item.totalSheets &&
          e.selectedUnit == item.selectedUnit &&
          e.savedAt == item.savedAt,
    );

    // 3️⃣ Add only if not duplicate
    if (!exists) {
      final key = await box.add(item);
      final savedItem = box.get(key);

      if (savedItem != null) {
        // 4️⃣ Update UnifiedHistoryNotifier
        _addToState(
          HistoryItem(
            type:
                "plywood_sheet_history", // 🔑 unique identifier for this history
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<void> addWoodFrameHistory(WoodFrameHistoryItem item) async {
    // 1️⃣ Open Hive box
    final box = await Hive.openBox<WoodFrameHistoryItem>(
      HiveBoxes.woodFrameHistory, // make sure you add this key in HiveBoxes
    );

    // 2️⃣ Duplicate check based on length, width, depth, volume, unit, date
    final exists = box.values.any(
      (e) =>
          e.length == item.length &&
          e.width == item.width &&
          e.depth == item.depth &&
          e.volume == item.volume &&
          e.unit == item.unit &&
          e.date == item.date,
    );

    // 3️⃣ Add only if not duplicate
    if (!exists) {
      final key = await box.add(item);
      final savedItem = box.get(key);

      if (savedItem != null) {
        // 4️⃣ Update UnifiedHistoryNotifier
        _addToState(
          HistoryItem(
            type: "wood_frame_history",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<void> addExcavationHistory(ExcavationHistoryItem item) async {
    // 1️⃣ Open Hive box
    final box = await Hive.openBox<ExcavationHistoryItem>(
      HiveBoxes.excavationHistory,
    );

    // 2️⃣ Duplicate check based on length, width, depth, volume, unit, date
    final exists = box.values.any(
      (e) =>
          e.length == item.length &&
          e.width == item.width &&
          e.depth == item.depth &&
          e.volume == item.volume &&
          e.unit == item.unit &&
          e.date == item.date,
    );

    // 3️⃣ Add only if not duplicate
    if (!exists) {
      final key = await box.add(item);
      final savedItem = box.get(key);

      if (savedItem != null) {
        // 4️⃣ Update UnifiedHistoryNotifier
        _addToState(
          HistoryItem(
            type: "excavation_history",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<void> addPaintHistory(PaintHistoryItem item) async {
    // Open Hive box
    final box = await Hive.openBox<PaintHistoryItem>('paint_history');

    // Duplicate check based on paintArea, paintQuantity, primerQuantity, puttyQuantity, unit, date
    final exists = box.values.any(
      (e) =>
          e.paintArea == item.paintArea &&
          e.paintQuantity == item.paintQuantity &&
          e.primerQuantity == item.primerQuantity &&
          e.puttyQuantity == item.puttyQuantity &&
          e.unit == item.unit &&
          e.date == item.date, // optional: timestamp check
    );

    if (!exists) {
      final key = await box.add(item);
      final savedItem = box.get(key);

      if (savedItem != null) {
        _addToState(
          HistoryItem(
            type: "paint_history",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  // Function to add SolarWaterHistoryItem
  Future<void> addSolarWaterHeaterHistory(SolarWaterHistoryItem item) async {
    // Open Hive box
    final box = await Hive.openBox<SolarWaterHistoryItem>(
      'solar_waterheater_history',
    );

    // Duplicate check based on inputConsumption and totalCapacity
    final exists = box.values.any(
      (e) =>
          e.inputConsumption == item.inputConsumption &&
          e.totalCapacity == item.totalCapacity &&
          e.timestamp ==
              item.timestamp, // optional: ya aap timestamp ignore kar sakte ho
    );

    if (!exists) {
      final key = await box.add(item);
      final savedItem = box.get(key);

      if (savedItem != null) {
        _addToState(
          HistoryItem(
            type: "solar_waterheater_history",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<void> addSolarHistory(SolarHistoryItem item) async {
    final box = await Hive.openBox<SolarHistoryItem>('solar_rooftop_history');

    // 1️⃣ Check for duplicate
    final exists = box.values.any(
      (e) =>
          e.consumptionType == item.consumptionType &&
          e.inputConsumption == item.inputConsumption &&
          e.dailyUnit == item.dailyUnit &&
          e.kwSystem == item.kwSystem &&
          e.totalPanels == item.totalPanels &&
          e.rooftopAreaSqFt == item.rooftopAreaSqFt &&
          e.rooftopAreaSqM == item.rooftopAreaSqM,
    );

    // 2️⃣ Save only if not exists
    if (!exists) {
      final key = await box.add(item);
      final savedItem = box.get(key);

      if (savedItem != null) {
        // 3️⃣ Update local Riverpod state
        _addToState(
          HistoryItem(
            type: HiveBoxes.solarHistory, // aapka box name
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  /// ✅ Add AirConditioner history
  Future<void> addAc(AirHistoryItem item) async {
    final exists = airBox.values.any(
      (e) =>
          e.lengthFt == item.lengthFt &&
          e.breadthFt == item.breadthFt &&
          e.heightFt == item.heightFt &&
          e.persons == item.persons &&
          e.maxTempC == item.maxTempC &&
          e.tons == item.tons,
    );

    if (!exists) {
      final key = await airBox.add(item);
      final savedItem = airBox.get(key);

      if (savedItem != null) {
        _addToState(
          HistoryItem(
            type: HiveBoxes.acHistory,
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  /// Add Water Sump
  Future<void> addWaterSump(WaterSumpHistoryItem item) async {
    final exists = waterBox.values.any(
      (e) =>
          e.length == item.length &&
          e.width == item.width &&
          e.depth == item.depth &&
          e.volume == item.volume &&
          e.capacityInLiters == item.capacityInLiters &&
          e.capacityInCubicFeet == item.capacityInCubicFeet,
    );

    if (!exists) {
      final key = await waterBox.add(item);
      final savedItem = waterBox.get(key);

      if (savedItem != null) {
        _addToState(
          HistoryItem(
            type: "water_sump_history",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  /// Add Kitchen
  Future<void> addKitchen(KitchenHistoryItem item) async {
    final exists = kitchenBox.values.any(
      (e) =>
          e.selectedUnit == item.selectedUnit &&
          e.shape == item.shape &&
          e.height == item.height &&
          e.width == item.width &&
          e.depth == item.depth &&
          e.area == item.area,
    );

    if (!exists) {
      final key = await kitchenBox.add(item);
      final savedItem = kitchenBox.get(key);

      if (savedItem != null) {
        _addToState(
          HistoryItem(
            type: "kitchen",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  /// Add Flooring
  Future<void> addFlooring(FlooringHistoryItem item) async {
    final exists = flooringBox.values.any(
      (e) =>
          e.selectedUnit == item.selectedUnit &&
          e.floorLength == item.floorLength &&
          e.floorWidth == item.floorWidth,
    );

    if (!exists) {
      final key = await flooringBox.add(item);
      final savedItem = flooringBox.get(key);

      if (savedItem != null) {
        _addToState(
          HistoryItem(
            type: "flooring",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  /// Add Boundary Wall
  Future<void> addBoundaryWall(BoundaryWallItem item) async {
    final exists = boundaryWallBox.values.any(
      (e) =>
          e.selectedUnit == item.selectedUnit &&
          e.areaLength == item.areaLength &&
          e.areaHeight == item.areaHeight &&
          e.barLength == item.barLength &&
          e.barHeight == item.barHeight,
    );

    if (!exists) {
      final key = await boundaryWallBox.add(item);
      final savedItem = boundaryWallBox.get(key);

      if (savedItem != null) {
        _addToState(
          HistoryItem(
            type: "boundaryWall",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  /// Add Concrete Block
  Future<void> addConcreteBlock(ConcreteBlockHistory item) async {
    final exists = concreteBlockBox.values.any(
      (e) =>
          e.unitType == item.unitType &&
          e.length == item.length &&
          e.height == item.height &&
          e.thickness == item.thickness,
    );

    if (!exists) {
      final key = await concreteBlockBox.add(item);
      final savedItem = concreteBlockBox.get(key);

      if (savedItem != null) {
        _addToState(
          HistoryItem(
            type: "concreteBlock",
            data: savedItem,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  void addBrick(BrickHistoryItem item) {
    brickBox.add(item);
    _addToState(
      HistoryItem(type: "brick", data: item, timestamp: DateTime.now()),
    );
  }

  void addCement(CementHistoryItem item) {
    cementBox.add(item);
    _addToState(
      HistoryItem(type: "cement", data: item, timestamp: DateTime.now()),
    );
  }

  void addPlaster(PlasterHistoryItem item) {
    plasterBox.add(item);
    _addToState(
      HistoryItem(type: "plaster", data: item, timestamp: DateTime.now()),
    );
  }

  void addConstruction(ConstructionCostHistoryItem item) {
    constructionBox.add(item);
    _addToState(
      HistoryItem(type: "construction", data: item, timestamp: DateTime.now()),
    );
  }

  /// Private helper to add item to state and maintain max items
  void _addToState(HistoryItem item) {
    final updated = [...state, item];
    if (updated.length > maxHistoryItems) {
      state = updated.sublist(updated.length - maxHistoryItems);
    } else {
      state = updated;
    }
  }

  /// Delete history by index
  void deleteHistory(int index) {
    if (index < 0 || index >= state.length) return;

    final item = state[index];

    dynamic key;

    if (item.type == "brick") {
      key = brickBox.keys.firstWhere(
        (k) => brickBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) brickBox.delete(key);
    } else if (item.type == "construction") {
      key = constructionBox.keys.firstWhere(
        (k) => constructionBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) constructionBox.delete(key);
    } else if (item.type == "cement") {
      key = cementBox.keys.firstWhere(
        (k) => cementBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) cementBox.delete(key);
    } else if (item.type == "plaster") {
      key = plasterBox.keys.firstWhere(
        (k) => plasterBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) plasterBox.delete(key);
    } else if (item.type == "concreteBlock") {
      key = concreteBlockBox.keys.firstWhere(
        (k) => concreteBlockBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) concreteBlockBox.delete(key);
    } else if (item.type == "boundaryWall") {
      key = boundaryWallBox.keys.firstWhere(
        (k) => boundaryWallBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) boundaryWallBox.delete(key);
    } else if (item.type == "flooring") {
      key = flooringBox.keys.firstWhere(
        (k) => flooringBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) flooringBox.delete(key);
    } else if (item.type == "kitchen") {
      key = kitchenBox.keys.firstWhere(
        (k) => kitchenBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) kitchenBox.delete(key);
    } else if (item.type == "water_sump_history") {
      key = waterBox.keys.firstWhere(
        (k) => waterBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) waterBox.delete(key);
    } else if (item.type == "air_history") {
      key = airBox.keys.firstWhere(
        (k) => airBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) airBox.delete(key);
    } else if (item.type == "solar_rooftop_history") {
      key = solorBox.keys.firstWhere(
        (k) => solorBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) solorwaterheaterBox.delete(key);
    } else if (item.type == "solar_waterheater_history") {
      key = solorwaterheaterBox.keys.firstWhere(
        (k) => solorwaterheaterBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) solorwaterheaterBox.delete(key);
    } else if (item.type == "paint_history") {
      key = paintBox.keys.firstWhere(
        (k) => paintBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) paintBox.delete(key);
    } else if (item.type == "excavation_history") {
      key = excavationBox.keys.firstWhere(
        (k) => excavationBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) woodframeBox.delete(key);
    } else if (item.type == "wood_frame_history") {
      key = woodframeBox.keys.firstWhere(
        (k) => woodframeBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) woodframeBox.delete(key);
    } else if (item.type == "plywood_sheet_history") {
      key = plywoodsheetBox.keys.firstWhere(
        (k) => plywoodsheetBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) antitermiteBox.delete(key);
    } else if (item.type == "anti_termite_history") {
      key = antitermiteBox.keys.firstWhere(
        (k) => antitermiteBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) antitermiteBox.delete(key);
    } else if (item.type == "round_column_history") {
      key = roundcolumnBox.keys.firstWhere(
        (k) => roundcolumnBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) roundcolumnBox.delete(key);
    } else if (item.type == "stair_case_history") {
      key = stairBox.keys.firstWhere(
        (k) => stairBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) stairBox.delete(key);
    } else if (item.type == "topsoil_history") {
      key = topsoilBox.keys.firstWhere(
        (k) => topsoilBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) topsoilBox.delete(key);
    } else if (item.type == "concrete_tube_history") {
      key = concreteTubeBox.keys.firstWhere(
        (k) => concreteTubeBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) concreteTubeBox.delete(key);
    } else if (item.type == "roof_pitch_history") {
      key = roofBox.keys.firstWhere(
        (k) => roofBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) roofBox.delete(key);
    } else if (item.type == "civil_unit_history") {
      key = civilunitBox.keys.firstWhere(
        (k) => civilunitBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) civilunitBox.delete(key);
    } else if (item.type == "steal_history") {
      key = stealweightBox.keys.firstWhere(
        (k) => stealweightBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) stealweightBox.delete(key);
    } else if (item.type == "steal_weight_history") {
      key = stealBox.keys.firstWhere(
        (k) => stealBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) stealBox.delete(key);
    } else if (item.type == "beam_history") {
      key = beamBox.keys.firstWhere(
        (k) => beamBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) beamBox.delete(key);
    } else if (item.type == "round_history") {
      key = roundBox.keys.firstWhere(
        (k) => roundBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) beamBox.delete(key);
    } else if (item.type == "square_bar_history") {
      key = sqbarBox.keys.firstWhere(
        (k) => sqbarBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) sqbarBox.delete(key);
    } else if (item.type == "distance_history") {
      key = distanceBox.keys.firstWhere(
        (k) => distanceBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) distanceBox.delete(key);
    } else if (item.type == "time_history") {
      key = timeBox.keys.firstWhere(
        (k) => timeBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) timeBox.delete(key);
    } else if (item.type == "mass_history") {
      key = massBox.keys.firstWhere(
        (k) => massBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) massBox.delete(key);
    } else if (item.type == "pressure_history") {
      key = pressureBox.keys.firstWhere(
        (k) => pressureBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) pressureBox.delete(key);
    } else if (item.type == "speed_history") {
      key = speedBox.keys.firstWhere(
        (k) => speedBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) speedBox.delete(key);
    } else if (item.type == "fuel_history") {
      key = fuelBox.keys.firstWhere(
        (k) => fuelBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) fuelBox.delete(key);
    } else if (item.type == "frequency_history") {
      key = frequencyBox.keys.firstWhere(
        (k) => frequencyBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) frequencyBox.delete(key);
    } else if (item.type == "angle_history") {
      key = angleBox.keys.firstWhere(
        (k) => angleBox.get(k) == item.data,
        orElse: () => -1,
      );
      if (key != -1) angleBox.delete(key);
    }

    state = state.where((e) => e != item).toList();
  }

  /// Clear all history
  void clearAll() {
    pressureBox.clear();
    angleBox.clear();
    frequencyBox.clear();
    fuelBox.clear();
    plasterBox.clear();
    speedBox.clear();
    massBox.clear();
    timeBox.clear();
    distanceBox.clear();
    sqbarBox.clear();
    roundBox.clear();
    beamBox.clear();
    stealBox.clear();
    stealweightBox.clear();
    civilunitBox.clear();
    roofBox.clear();
    concreteTubeBox.clear();
    topsoilBox.clear();
    stairBox.clear();
    roundcolumnBox.clear();
    antitermiteBox.clear();
    plywoodsheetBox.clear();
    woodframeBox.clear();
    brickBox.clear();
    constructionBox.clear();
    cementBox.clear();
    plasterBox.clear();
    concreteBlockBox.clear();
    boundaryWallBox.clear();
    flooringBox.clear();
    kitchenBox.clear();
    waterBox.clear();
    airBox.clear();
    solorBox.clear();
    solorwaterheaterBox.clear();
    paintBox.clear();
    excavationBox.clear();
    state = [];
  }
}

/// Provider
final unifiedHistoryProvider =
    StateNotifierProvider<UnifiedHistoryNotifier, List<HistoryItem>>((ref) {
      final brickBox = Hive.box<BrickHistoryItem>(HiveBoxes.brickHistory);
      final constructionBox = Hive.box<ConstructionCostHistoryItem>(
        HiveBoxes.constructionCostHistory,
      );
      final cementBox = Hive.box<CementHistoryItem>(HiveBoxes.cementHistory);
      final plasterBox = Hive.box<PlasterHistoryItem>(HiveBoxes.plasterHistory);
      final concreteBlockBox = Hive.box<ConcreteBlockHistory>(
        HiveBoxes.concreteBlockHistory,
      );
      final boundaryWallBox = Hive.box<BoundaryWallItem>(
        HiveBoxes.boundaryWallHistory,
      );
      final flooringBox = Hive.box<FlooringHistoryItem>(
        HiveBoxes.flooringHistory,
      );
      final kitchenBox = Hive.box<KitchenHistoryItem>(HiveBoxes.kitchenHistory);
      final waterBox = Hive.box<WaterSumpHistoryItem>(
        HiveBoxes.waterSumpHistory,
      );
      final airBox = Hive.box<AirHistoryItem>(HiveBoxes.acHistory);

      final solorBox = Hive.box<SolarHistoryItem>(HiveBoxes.solarHistory);
      final solorwaterheaterBox = Hive.box<SolarWaterHistoryItem>(
        HiveBoxes.solarWaterHeaterHistory,
      );
      final paintBox = Hive.box<PaintHistoryItem>(HiveBoxes.paintHistory);
      final excavationBox = Hive.box<ExcavationHistoryItem>(
        HiveBoxes.excavationHistory,
      );

      final woodframeBox = Hive.box<WoodFrameHistoryItem>(
        HiveBoxes.woodFrameHistory,
      );

      final plywoodsheetBox = Hive.box<PlywoodSheetItem>(
        HiveBoxes.plywoodSheetHistory,
      );

      final antitermiteBox = Hive.box<AntiTermiteHistoryItem>(
        HiveBoxes.antiTermiteHistory,
      );

      final roundcolumnBox = Hive.box<RoundColumnHistoryItem>(
        HiveBoxes.roundColumnHistory,
      );

      final stairBox = Hive.box<StairHistoryItem>(HiveBoxes.stairCaseHistory);

      final topsoilBox = Hive.box<TopSoilHistoryItem>(HiveBoxes.topSoilHistory);

      final concreteTubeBox = Hive.box<ConcreteTubeHistoryItem>(
        HiveBoxes.concreteTubeHistory,
      );

      final roofBox = Hive.box<RoofPitchHistoryItem>(
        HiveBoxes.roofPitchHistory,
      );

      final civilunitBox = Hive.box<ConversionHistory>(
        HiveBoxes.civilUnitHistory,
      );

      final stealweightBox = Hive.box<StealWeightHistory>(
        HiveBoxes.stealWeightHistory,
      );

      final stealBox = Hive.box<StealHistoryItem>(HiveBoxes.stealHistory);

      final beamBox = Hive.box<BeamStealHistoryItem>(HiveBoxes.beamHistory);

      final roundBox = Hive.box<RoundStealHistoryItem>(HiveBoxes.roundHistory);

      final sqbarBox = Hive.box<SquareBarHistoryItem>(
        HiveBoxes.squareBarHistory,
      );

      final distanceBox = Hive.box<DistanceHistoryItem>(
        HiveBoxes.distanceHistory,
      );

      final timeBox = Hive.box<TimeHistoryItem>(HiveBoxes.timeHistory);
      final frequencybox = Hive.box<FrequencyHistoryItem>(
        HiveBoxes.frequencyHistory,
      );
      final angleBox = Hive.box<AngleHistoryItem>(HiveBoxes.angleHistory);
      final massBox = Hive.box<MassHistoryItem>(HiveBoxes.massHistory);
      final fuelBox = Hive.box<FuelHistoryItem>(HiveBoxes.fuelHistory);
      final speedBox = Hive.box<SpeedHistoryItem>(HiveBoxes.speedHistory);
      final pressureBox = Hive.box<PressureHistoryItem>(
        HiveBoxes.pressureHistory,
      );

      return UnifiedHistoryNotifier(
        fuelBox: fuelBox,
        speedBox: speedBox,
        timeBox: timeBox,
        angleBox: angleBox,
        massBox: massBox,
        pressureBox: pressureBox,
        frequencyBox: frequencybox,
        distanceBox: distanceBox,
        sqbarBox: sqbarBox,
        roundBox: roundBox,
        beamBox: beamBox,
        stealBox: stealBox,
        stealweightBox: stealweightBox,
        civilunitBox: civilunitBox,
        roofBox: roofBox,
        concreteTubeBox: concreteTubeBox,
        topsoilBox: topsoilBox,
        stairBox: stairBox,
        roundcolumnBox: roundcolumnBox,
        antitermiteBox: antitermiteBox,
        plywoodsheetBox: plywoodsheetBox,
        woodframeBox: woodframeBox,
        paintBox: paintBox,
        brickBox: brickBox,
        constructionBox: constructionBox,
        cementBox: cementBox,
        plasterBox: plasterBox,
        concreteBlockBox: concreteBlockBox,
        boundaryWallBox: boundaryWallBox,
        flooringBox: flooringBox,
        kitchenBox: kitchenBox,
        waterBox: waterBox,
        airBox: airBox,
        solorBox: solorBox,
        solorwaterheaterBox: solorwaterheaterBox,
        excavationBox: excavationBox,
        maxHistoryItems: 50,
      );
    });
