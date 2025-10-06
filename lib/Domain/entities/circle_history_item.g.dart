// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CircleHistoryItemAdapter extends TypeAdapter<CircleHistoryItem> {
  @override
  final int typeId = 36;

  @override
  CircleHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CircleHistoryItem(
      inputValue: fields[0] as double,
      inputUnit: fields[1] as String,
      resultType: fields[2] as String,
      resultValue: fields[3] as double,
      savedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CircleHistoryItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.inputValue)
      ..writeByte(1)
      ..write(obj.inputUnit)
      ..writeByte(2)
      ..write(obj.resultType)
      ..writeByte(3)
      ..write(obj.resultValue)
      ..writeByte(4)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CircleHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
