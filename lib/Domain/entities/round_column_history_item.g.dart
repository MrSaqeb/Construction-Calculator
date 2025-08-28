// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_column_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoundColumnHistoryItemAdapter
    extends TypeAdapter<RoundColumnHistoryItem> {
  @override
  final int typeId = 18;

  @override
  RoundColumnHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoundColumnHistoryItem(
      diM: fields[0] as String,
      diCM: fields[1] as String,
      diFT: fields[2] as String,
      diIN: fields[3] as String,
      htM: fields[4] as String,
      htCM: fields[5] as String,
      htFT: fields[6] as String,
      htIN: fields[7] as String,
      noOfColumns: fields[8] as String,
      grade: fields[9] as String,
      unit: fields[10] as String,
      volume: fields[11] as double,
      cementBags: fields[12] as double,
      sandCft: fields[13] as double,
      aggregateCft: fields[14] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RoundColumnHistoryItem obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.diM)
      ..writeByte(1)
      ..write(obj.diCM)
      ..writeByte(2)
      ..write(obj.diFT)
      ..writeByte(3)
      ..write(obj.diIN)
      ..writeByte(4)
      ..write(obj.htM)
      ..writeByte(5)
      ..write(obj.htCM)
      ..writeByte(6)
      ..write(obj.htFT)
      ..writeByte(7)
      ..write(obj.htIN)
      ..writeByte(8)
      ..write(obj.noOfColumns)
      ..writeByte(9)
      ..write(obj.grade)
      ..writeByte(10)
      ..write(obj.unit)
      ..writeByte(11)
      ..write(obj.volume)
      ..writeByte(12)
      ..write(obj.cementBags)
      ..writeByte(13)
      ..write(obj.sandCft)
      ..writeByte(14)
      ..write(obj.aggregateCft);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoundColumnHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
