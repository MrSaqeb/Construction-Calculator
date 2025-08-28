// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_steal_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoundStealHistoryItemAdapter extends TypeAdapter<RoundStealHistoryItem> {
  @override
  final int typeId = 27;

  @override
  RoundStealHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoundStealHistoryItem(
      diameter: fields[0] as double,
      length: fields[1] as double,
      pieces: fields[2] as int,
      material: fields[3] as String,
      lengthUnit: fields[4] as String,
      weightUnit: fields[5] as String,
      costPerKg: fields[6] as double,
      weightKg: fields[7] as double,
      weightTons: fields[8] as double,
      totalCost: fields[9] as double,
      savedAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RoundStealHistoryItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.diameter)
      ..writeByte(1)
      ..write(obj.length)
      ..writeByte(2)
      ..write(obj.pieces)
      ..writeByte(3)
      ..write(obj.material)
      ..writeByte(4)
      ..write(obj.lengthUnit)
      ..writeByte(5)
      ..write(obj.weightUnit)
      ..writeByte(6)
      ..write(obj.costPerKg)
      ..writeByte(7)
      ..write(obj.weightKg)
      ..writeByte(8)
      ..write(obj.weightTons)
      ..writeByte(9)
      ..write(obj.totalCost)
      ..writeByte(10)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoundStealHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
