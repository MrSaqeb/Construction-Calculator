// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arch_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArchHistoryItemAdapter extends TypeAdapter<ArchHistoryItem> {
  @override
  final int typeId = 42;

  @override
  ArchHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArchHistoryItem(
      length: fields[0] as double,
      height: fields[1] as double,
      unit: fields[2] as String,
      area: fields[3] as double,
      perimeter: fields[4] as double,
      savedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ArchHistoryItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.length)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.area)
      ..writeByte(4)
      ..write(obj.perimeter)
      ..writeByte(5)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArchHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
