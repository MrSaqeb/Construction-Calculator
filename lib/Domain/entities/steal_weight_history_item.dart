import 'package:hive/hive.dart';

part 'steal_weight_history_item.g.dart';

@HiveType(typeId: 24)
class StealWeightHistory extends HiveObject {
  @HiveField(0)
  final String inputVolume;

  @HiveField(1)
  final String steelType;

  @HiveField(2)
  final String calculatedWeight;

  @HiveField(3)
  final DateTime savedAt;

  StealWeightHistory({
    required this.inputVolume,
    required this.steelType,
    required this.calculatedWeight,
    required this.savedAt,
  });
}
