// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'civilunitconversion_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversionHistoryAdapter extends TypeAdapter<ConversionHistory> {
  @override
  final int typeId = 23;

  @override
  ConversionHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversionHistory(
      inputValue: fields[0] as String,
      fromUnit: fields[1] as String,
      toUnit: fields[2] as String,
      resultValue: fields[3] as String,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ConversionHistory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.inputValue)
      ..writeByte(1)
      ..write(obj.fromUnit)
      ..writeByte(2)
      ..write(obj.toUnit)
      ..writeByte(3)
      ..write(obj.resultValue)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversionHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
