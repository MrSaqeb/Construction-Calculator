// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cement_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CementHistoryItemAdapter extends TypeAdapter<CementHistoryItem> {
  @override
  final int typeId = 3;

  @override
  CementHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CementHistoryItem(
      lenM: fields[0] as String,
      lenCM: fields[1] as String,
      lenFT: fields[2] as String,
      lenIN: fields[3] as String,
      htM: fields[4] as String,
      htCM: fields[5] as String,
      htFT: fields[6] as String,
      htIN: fields[7] as String,
      depthCM: fields[8] as String,
      depthIN: fields[9] as String,
      grade: fields[10] as String,
      volume: fields[11] as double,
      cementBags: fields[12] as double,
      sandCft: fields[13] as double,
      aggregateCft: fields[14] as double,
      unit: fields[15] as String,
      timestamp: fields[16] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CementHistoryItem obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.lenM)
      ..writeByte(1)
      ..write(obj.lenCM)
      ..writeByte(2)
      ..write(obj.lenFT)
      ..writeByte(3)
      ..write(obj.lenIN)
      ..writeByte(4)
      ..write(obj.htM)
      ..writeByte(5)
      ..write(obj.htCM)
      ..writeByte(6)
      ..write(obj.htFT)
      ..writeByte(7)
      ..write(obj.htIN)
      ..writeByte(8)
      ..write(obj.depthCM)
      ..writeByte(9)
      ..write(obj.depthIN)
      ..writeByte(10)
      ..write(obj.grade)
      ..writeByte(11)
      ..write(obj.volume)
      ..writeByte(12)
      ..write(obj.cementBags)
      ..writeByte(13)
      ..write(obj.sandCft)
      ..writeByte(14)
      ..write(obj.aggregateCft)
      ..writeByte(15)
      ..write(obj.unit)
      ..writeByte(16)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CementHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
