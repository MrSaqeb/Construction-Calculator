// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sector_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SectorHistoryItemAdapter extends TypeAdapter<SectorHistoryItem> {
  @override
  final int typeId = 41;

  @override
  SectorHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SectorHistoryItem(
      radius: fields[0] as double,
      angle: fields[1] as double,
      unit: fields[2] as String,
      area: fields[3] as double,
      savedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SectorHistoryItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.radius)
      ..writeByte(1)
      ..write(obj.angle)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.area)
      ..writeByte(4)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectorHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
