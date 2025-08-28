// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solar_roofttop_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SolarHistoryItemAdapter extends TypeAdapter<SolarHistoryItem> {
  @override
  final int typeId = 11;

  @override
  SolarHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SolarHistoryItem(
      consumptionType: fields[0] as String,
      inputConsumption: fields[1] as double,
      dailyUnit: fields[2] as double,
      kwSystem: fields[3] as double,
      totalPanels: fields[4] as double,
      rooftopAreaSqFt: fields[5] as double,
      rooftopAreaSqM: fields[6] as double,
      timestamp: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SolarHistoryItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.consumptionType)
      ..writeByte(1)
      ..write(obj.inputConsumption)
      ..writeByte(2)
      ..write(obj.dailyUnit)
      ..writeByte(3)
      ..write(obj.kwSystem)
      ..writeByte(4)
      ..write(obj.totalPanels)
      ..writeByte(5)
      ..write(obj.rooftopAreaSqFt)
      ..writeByte(6)
      ..write(obj.rooftopAreaSqM)
      ..writeByte(7)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SolarHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
