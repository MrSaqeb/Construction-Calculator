// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plywood_sheet_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlywoodSheetItemAdapter extends TypeAdapter<PlywoodSheetItem> {
  @override
  final int typeId = 16;

  @override
  PlywoodSheetItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlywoodSheetItem(
      selectedUnit: fields[0] as String,
      roomLength: fields[1] as double,
      roomWidth: fields[2] as double,
      plyLength: fields[3] as double,
      plyWidth: fields[4] as double,
      totalSheets: fields[5] as int,
      roomArea: fields[6] as double,
      plywoodCover: fields[7] as double,
      savedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PlywoodSheetItem obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.selectedUnit)
      ..writeByte(1)
      ..write(obj.roomLength)
      ..writeByte(2)
      ..write(obj.roomWidth)
      ..writeByte(3)
      ..write(obj.plyLength)
      ..writeByte(4)
      ..write(obj.plyWidth)
      ..writeByte(5)
      ..write(obj.totalSheets)
      ..writeByte(6)
      ..write(obj.roomArea)
      ..writeByte(7)
      ..write(obj.plywoodCover)
      ..writeByte(8)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlywoodSheetItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
