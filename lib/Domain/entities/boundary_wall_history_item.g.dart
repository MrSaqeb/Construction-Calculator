// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boundary_wall_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoundaryWallItemAdapter extends TypeAdapter<BoundaryWallItem> {
  @override
  final int typeId = 6;

  @override
  BoundaryWallItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoundaryWallItem(
      selectedUnit: fields[0] as String,
      areaLength: fields[1] as double,
      areaHeight: fields[2] as double,
      barLength: fields[3] as double,
      barHeight: fields[4] as double,
      totalHorizontalBars: fields[5] as int,
      totalVerticalBars: fields[6] as int,
      totalPanels: fields[7] as int,
      savedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BoundaryWallItem obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.selectedUnit)
      ..writeByte(1)
      ..write(obj.areaLength)
      ..writeByte(2)
      ..write(obj.areaHeight)
      ..writeByte(3)
      ..write(obj.barLength)
      ..writeByte(4)
      ..write(obj.barHeight)
      ..writeByte(5)
      ..write(obj.totalHorizontalBars)
      ..writeByte(6)
      ..write(obj.totalVerticalBars)
      ..writeByte(7)
      ..write(obj.totalPanels)
      ..writeByte(8)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoundaryWallItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
