// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hemisphere_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HemisphereHistoryItemAdapter extends TypeAdapter<HemisphereHistoryItem> {
  @override
  final int typeId = 40;

  @override
  HemisphereHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HemisphereHistoryItem(
      radius: fields[0] as double,
      unit: fields[1] as String,
      surfaceArea: fields[2] as double,
      volume: fields[3] as double,
      savedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HemisphereHistoryItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.radius)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.surfaceArea)
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
      other is HemisphereHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
