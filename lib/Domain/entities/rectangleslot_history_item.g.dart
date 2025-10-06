// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectangleslot_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RectangleWithSlotHistoryItemAdapter
    extends TypeAdapter<RectangleWithSlotHistoryItem> {
  @override
  final int typeId = 43;

  @override
  RectangleWithSlotHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RectangleWithSlotHistoryItem(
      a: fields[0] as double,
      b: fields[1] as double,
      c: fields[2] as double,
      d: fields[3] as double,
      unit: fields[4] as String,
      area: fields[5] as double,
      perimeter: fields[6] as double,
      savedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RectangleWithSlotHistoryItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.a)
      ..writeByte(1)
      ..write(obj.b)
      ..writeByte(2)
      ..write(obj.c)
      ..writeByte(3)
      ..write(obj.d)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.area)
      ..writeByte(6)
      ..write(obj.perimeter)
      ..writeByte(7)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RectangleWithSlotHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
