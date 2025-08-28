// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plaster_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlasterHistoryItemAdapter extends TypeAdapter<PlasterHistoryItem> {
  @override
  final int typeId = 4;

  @override
  PlasterHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlasterHistoryItem(
      lenM: fields[0] as String,
      lenCM: fields[1] as String,
      lenFT: fields[2] as String,
      lenIN: fields[3] as String,
      widthM: fields[4] as String,
      widthCM: fields[5] as String,
      widthFT: fields[6] as String,
      widthIN: fields[7] as String,
      grade: fields[8] as String,
      area: fields[9] as double,
      cementBags: fields[10] as double,
      sandCft: fields[11] as double,
      unit: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlasterHistoryItem obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.lenM)
      ..writeByte(1)
      ..write(obj.lenCM)
      ..writeByte(2)
      ..write(obj.lenFT)
      ..writeByte(3)
      ..write(obj.lenIN)
      ..writeByte(4)
      ..write(obj.widthM)
      ..writeByte(5)
      ..write(obj.widthCM)
      ..writeByte(6)
      ..write(obj.widthFT)
      ..writeByte(7)
      ..write(obj.widthIN)
      ..writeByte(8)
      ..write(obj.grade)
      ..writeByte(9)
      ..write(obj.area)
      ..writeByte(10)
      ..write(obj.cementBags)
      ..writeByte(11)
      ..write(obj.sandCft)
      ..writeByte(12)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlasterHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
