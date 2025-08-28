// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_sump_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WaterSumpHistoryItemAdapter extends TypeAdapter<WaterSumpHistoryItem> {
  @override
  final int typeId = 9;

  @override
  WaterSumpHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterSumpHistoryItem(
      length: fields[0] as double,
      width: fields[1] as double,
      depth: fields[2] as double,
      volume: fields[3] as double,
      capacityInLiters: fields[4] as double,
      capacityInCubicFeet: fields[5] as double,
      savedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WaterSumpHistoryItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.length)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.depth)
      ..writeByte(3)
      ..write(obj.volume)
      ..writeByte(4)
      ..write(obj.capacityInLiters)
      ..writeByte(5)
      ..write(obj.capacityInCubicFeet)
      ..writeByte(6)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterSumpHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
