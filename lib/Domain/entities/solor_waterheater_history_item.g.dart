// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solor_waterheater_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SolarWaterHistoryItemAdapter extends TypeAdapter<SolarWaterHistoryItem> {
  @override
  final int typeId = 12;

  @override
  SolarWaterHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SolarWaterHistoryItem(
      inputConsumption: fields[0] as double,
      totalCapacity: fields[1] as double,
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SolarWaterHistoryItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.inputConsumption)
      ..writeByte(1)
      ..write(obj.totalCapacity)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SolarWaterHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
