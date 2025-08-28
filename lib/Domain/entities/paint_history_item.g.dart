// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paint_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaintHistoryItemAdapter extends TypeAdapter<PaintHistoryItem> {
  @override
  final int typeId = 13;

  @override
  PaintHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaintHistoryItem(
      paintArea: fields[0] as double,
      paintQuantity: fields[1] as double,
      primerQuantity: fields[2] as double,
      puttyQuantity: fields[3] as double,
      unit: fields[4] as String,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PaintHistoryItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.paintArea)
      ..writeByte(1)
      ..write(obj.paintQuantity)
      ..writeByte(2)
      ..write(obj.primerQuantity)
      ..writeByte(3)
      ..write(obj.puttyQuantity)
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
      other is PaintHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
