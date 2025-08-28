// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stair_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StairHistoryItemAdapter extends TypeAdapter<StairHistoryItem> {
  @override
  final int typeId = 19;

  @override
  StairHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StairHistoryItem(
      riserFT: fields[0] as String,
      riserIN: fields[1] as String,
      treadFT: fields[2] as String,
      treadIN: fields[3] as String,
      stairWidthFT: fields[4] as String,
      stairHeightFT: fields[5] as String,
      waistSlabIN: fields[6] as String,
      grade: fields[7] as String,
      volume: fields[8] as double,
      cementBags: fields[9] as double,
      sand: fields[10] as double,
      aggregate: fields[11] as double,
      savedAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StairHistoryItem obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.riserFT)
      ..writeByte(1)
      ..write(obj.riserIN)
      ..writeByte(2)
      ..write(obj.treadFT)
      ..writeByte(3)
      ..write(obj.treadIN)
      ..writeByte(4)
      ..write(obj.stairWidthFT)
      ..writeByte(5)
      ..write(obj.stairHeightFT)
      ..writeByte(6)
      ..write(obj.waistSlabIN)
      ..writeByte(7)
      ..write(obj.grade)
      ..writeByte(8)
      ..write(obj.volume)
      ..writeByte(9)
      ..write(obj.cementBags)
      ..writeByte(10)
      ..write(obj.sand)
      ..writeByte(11)
      ..write(obj.aggregate)
      ..writeByte(12)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StairHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
