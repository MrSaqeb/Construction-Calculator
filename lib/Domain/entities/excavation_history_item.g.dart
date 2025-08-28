// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excavation_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExcavationHistoryItemAdapter extends TypeAdapter<ExcavationHistoryItem> {
  @override
  final int typeId = 14;

  @override
  ExcavationHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExcavationHistoryItem(
      length: fields[0] as double,
      width: fields[1] as double,
      depth: fields[2] as double,
      volume: fields[3] as double,
      unit: fields[4] as String,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ExcavationHistoryItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.length)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.depth)
      ..writeByte(3)
      ..write(obj.volume)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExcavationHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
