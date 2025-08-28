// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brick_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrickHistoryItemAdapter extends TypeAdapter<BrickHistoryItem> {
  @override
  final int typeId = 2;

  @override
  BrickHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrickHistoryItem(
      lenM: fields[0] as String?,
      lenCM: fields[1] as String?,
      lenFT: fields[2] as String?,
      lenIN: fields[3] as String?,
      htM: fields[4] as String?,
      htCM: fields[5] as String?,
      htFT: fields[6] as String?,
      htIN: fields[7] as String?,
      thickness: fields[8] as String?,
      brickLcm: fields[9] as String?,
      brickWcm: fields[10] as String?,
      brickHcm: fields[11] as String?,
      mortarX: fields[12] as int?,
      bricksQty: fields[13] as double?,
      unit: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BrickHistoryItem obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.lenM)
      ..writeByte(1)
      ..write(obj.lenCM)
      ..writeByte(2)
      ..write(obj.lenFT)
      ..writeByte(3)
      ..write(obj.lenIN)
      ..writeByte(4)
      ..write(obj.htM)
      ..writeByte(5)
      ..write(obj.htCM)
      ..writeByte(6)
      ..write(obj.htFT)
      ..writeByte(7)
      ..write(obj.htIN)
      ..writeByte(8)
      ..write(obj.thickness)
      ..writeByte(9)
      ..write(obj.brickLcm)
      ..writeByte(10)
      ..write(obj.brickWcm)
      ..writeByte(11)
      ..write(obj.brickHcm)
      ..writeByte(12)
      ..write(obj.mortarX)
      ..writeByte(13)
      ..write(obj.bricksQty)
      ..writeByte(14)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrickHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
