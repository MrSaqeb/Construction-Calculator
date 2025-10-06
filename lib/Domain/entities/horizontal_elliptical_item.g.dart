// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horizontal_elliptical_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HorizontalEllipticalHistoryItemAdapter
    extends TypeAdapter<HorizontalEllipticalHistoryItem> {
  @override
  final int typeId = 50;

  @override
  HorizontalEllipticalHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HorizontalEllipticalHistoryItem(
      length: fields[0] as double,
      width: fields[1] as double,
      height: fields[2] as double,
      filled: fields[3] as double,
      unit: fields[4] as String,
      totalVolume: fields[5] as double,
      filledVolume: fields[6] as double,
      savedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HorizontalEllipticalHistoryItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.length)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.filled)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.totalVolume)
      ..writeByte(6)
      ..write(obj.filledVolume)
      ..writeByte(7)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HorizontalEllipticalHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
