// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cone_bottom_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConeBottomHistoryItemAdapter extends TypeAdapter<ConeBottomHistoryItem> {
  @override
  final int typeId = 51;

  @override
  ConeBottomHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConeBottomHistoryItem(
      topDiameter: fields[0] as double,
      bottomDiameter: fields[1] as double,
      cylinderHeight: fields[2] as double,
      coneHeight: fields[3] as double,
      filledHeight: fields[4] as double,
      unit: fields[5] as String,
      totalVolume: fields[6] as double,
      filledVolume: fields[7] as double,
      savedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ConeBottomHistoryItem obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.topDiameter)
      ..writeByte(1)
      ..write(obj.bottomDiameter)
      ..writeByte(2)
      ..write(obj.cylinderHeight)
      ..writeByte(3)
      ..write(obj.coneHeight)
      ..writeByte(4)
      ..write(obj.filledHeight)
      ..writeByte(5)
      ..write(obj.unit)
      ..writeByte(6)
      ..write(obj.totalVolume)
      ..writeByte(7)
      ..write(obj.filledVolume)
      ..writeByte(8)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConeBottomHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
