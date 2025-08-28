// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pressure_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PressureHistoryItemAdapter extends TypeAdapter<PressureHistoryItem> {
  @override
  final int typeId = 33;

  @override
  PressureHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PressureHistoryItem(
      inputValue: fields[0] as double,
      inputUnit: fields[1] as String,
      convertedValues: (fields[2] as Map).cast<String, double>(),
      savedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PressureHistoryItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.inputValue)
      ..writeByte(1)
      ..write(obj.inputUnit)
      ..writeByte(2)
      ..write(obj.convertedValues)
      ..writeByte(3)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PressureHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
