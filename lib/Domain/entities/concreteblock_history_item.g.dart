// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concreteblock_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConcreteBlockHistoryAdapter extends TypeAdapter<ConcreteBlockHistory> {
  @override
  final int typeId = 5;

  @override
  ConcreteBlockHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConcreteBlockHistory(
      dateTime: fields[0] as DateTime,
      unitType: fields[1] as String,
      length: fields[2] as double,
      height: fields[3] as double,
      thickness: fields[4] as double,
      mortarRatio: fields[5] as int,
      blockLength: fields[6] as double,
      blockWidth: fields[7] as double,
      blockHeight: fields[8] as double,
      totalBlocks: fields[9] as int,
      masonryVolume: fields[10] as double,
      cementBags: fields[11] as double,
      sandTons: fields[12] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ConcreteBlockHistory obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.unitType)
      ..writeByte(2)
      ..write(obj.length)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.thickness)
      ..writeByte(5)
      ..write(obj.mortarRatio)
      ..writeByte(6)
      ..write(obj.blockLength)
      ..writeByte(7)
      ..write(obj.blockWidth)
      ..writeByte(8)
      ..write(obj.blockHeight)
      ..writeByte(9)
      ..write(obj.totalBlocks)
      ..writeByte(10)
      ..write(obj.masonryVolume)
      ..writeByte(11)
      ..write(obj.cementBags)
      ..writeByte(12)
      ..write(obj.sandTons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConcreteBlockHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
