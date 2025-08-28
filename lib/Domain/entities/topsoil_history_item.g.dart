// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topsoil_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TopSoilHistoryItemAdapter extends TypeAdapter<TopSoilHistoryItem> {
  @override
  final int typeId = 20;

  @override
  TopSoilHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopSoilHistoryItem(
      length: fields[0] as double,
      width: fields[1] as double,
      depth: fields[2] as double,
      volume: fields[3] as double,
      savedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TopSoilHistoryItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.length)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.depth)
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
      other is TopSoilHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
