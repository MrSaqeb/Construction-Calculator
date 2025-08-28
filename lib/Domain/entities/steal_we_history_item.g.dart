// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steal_we_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StealHistoryItemAdapter extends TypeAdapter<StealHistoryItem> {
  @override
  final int typeId = 25;

  @override
  StealHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StealHistoryItem(
      diameter: fields[0] as double,
      length: fields[1] as double,
      quantity: fields[2] as int,
      volume: fields[3] as double,
      savedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StealHistoryItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.diameter)
      ..writeByte(1)
      ..write(obj.length)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.volume)
      ..writeByte(4)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StealHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
