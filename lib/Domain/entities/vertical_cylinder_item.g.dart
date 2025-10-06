// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vertical_cylinder_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VerticalCylinderHistoryItemAdapter
    extends TypeAdapter<VerticalCylinderHistoryItem> {
  @override
  final int typeId = 44;

  @override
  VerticalCylinderHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VerticalCylinderHistoryItem(
      diameter: fields[0] as double,
      height: fields[1] as double,
      filled: fields[2] as double,
      unit: fields[3] as String,
      totalVolume: fields[4] as double,
      filledVolume: fields[5] as double,
      savedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, VerticalCylinderHistoryItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.diameter)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.filled)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.totalVolume)
      ..writeByte(5)
      ..write(obj.filledVolume)
      ..writeByte(6)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerticalCylinderHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
