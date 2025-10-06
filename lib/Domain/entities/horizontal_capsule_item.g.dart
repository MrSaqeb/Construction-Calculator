// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horizontal_capsule_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HorizontalCapsuleItemAdapter extends TypeAdapter<HorizontalCapsuleItem> {
  @override
  final int typeId = 48;

  @override
  HorizontalCapsuleItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HorizontalCapsuleItem(
      diameter: fields[0] as double,
      cylinderLength: fields[1] as double,
      filledLength: fields[2] as double,
      unit: fields[3] as String,
      totalVolume: fields[4] as double,
      filledVolume: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HorizontalCapsuleItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.diameter)
      ..writeByte(1)
      ..write(obj.cylinderLength)
      ..writeByte(2)
      ..write(obj.filledLength)
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
      other is HorizontalCapsuleItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
