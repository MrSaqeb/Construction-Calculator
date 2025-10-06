// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vertical_capsule_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VerticalCapsuleItemAdapter extends TypeAdapter<VerticalCapsuleItem> {
  @override
  final int typeId = 47;

  @override
  VerticalCapsuleItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VerticalCapsuleItem(
      diameter: fields[0] as double,
      cylinderHeight: fields[1] as double,
      filledHeight: fields[2] as double,
      unit: fields[3] as String,
      totalVolume: fields[4] as double,
      filledVolume: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, VerticalCapsuleItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.diameter)
      ..writeByte(1)
      ..write(obj.cylinderHeight)
      ..writeByte(2)
      ..write(obj.filledHeight)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.totalVolume)
      ..writeByte(5)
      ..write(obj.filledVolume);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerticalCapsuleItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
