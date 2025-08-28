import 'package:hive/hive.dart';

part 'concrete_tube_history_item.g.dart';

@HiveType(typeId: 21)
class ConcreteTubeHistoryItem extends HiveObject {
  // Inner diameters
  @HiveField(0)
  final String innerM;
  @HiveField(1)
  final String innerCM;
  @HiveField(2)
  final String innerFT;
  @HiveField(3)
  final String innerIN;

  // Outer diameters
  @HiveField(4)
  final String outerM;
  @HiveField(5)
  final String outerCM;
  @HiveField(6)
  final String outerFT;
  @HiveField(7)
  final String outerIN;

  // Heights
  @HiveField(8)
  final String heightM;
  @HiveField(9)
  final String heightCM;
  @HiveField(10)
  final String heightFT;
  @HiveField(11)
  final String heightIN;

  // Number of tubes
  @HiveField(12)
  final String noOfTubes;

  // Concrete grade and unit
  @HiveField(13)
  final String grade;
  @HiveField(14)
  final String unit;

  // Calculation results
  @HiveField(15)
  final double concreteVolume;
  @HiveField(16)
  final double cementBags;
  @HiveField(17)
  final double sandCft;
  @HiveField(18)
  final double aggregateCft;

  ConcreteTubeHistoryItem({
    required this.innerM,
    required this.innerCM,
    required this.innerFT,
    required this.innerIN,
    required this.outerM,
    required this.outerCM,
    required this.outerFT,
    required this.outerIN,
    required this.heightM,
    required this.heightCM,
    required this.heightFT,
    required this.heightIN,
    required this.noOfTubes,
    required this.grade,
    required this.unit,
    required this.concreteVolume,
    required this.cementBags,
    required this.sandCft,
    required this.aggregateCft,
  });
}
