// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectangular_prism_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RectangularPrismItemAdapter extends TypeAdapter<RectangularPrismItem> {
  @override
  final int typeId = 46;

  @override
  RectangularPrismItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RectangularPrismItem(
      length: fields[0] as double,
      width: fields[1] as double,
      height: fields[2] as double,
      filledHeight: fields[3] as double,
      unit: fields[4] as String,
      totalVolume: fields[5] as double,
      filledVolume: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RectangularPrismItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.length)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.filledHeight)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.totalVolume)
      ..writeByte(6)
      ..write(obj.filledVolume);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RectangularPrismItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
