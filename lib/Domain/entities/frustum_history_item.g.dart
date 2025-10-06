// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frustum_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FrustumHistoryItemAdapter extends TypeAdapter<FrustumHistoryItem> {
  @override
  final int typeId = 53;

  @override
  FrustumHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FrustumHistoryItem(
      topDiameter: fields[0] as double,
      bottomDiameter: fields[1] as double,
      height: fields[2] as double,
      filledHeight: fields[3] as double,
      unit: fields[4] as String,
      totalVolume: fields[5] as double,
      filledVolume: fields[6] as double,
      savedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FrustumHistoryItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.topDiameter)
      ..writeByte(1)
      ..write(obj.bottomDiameter)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.filledHeight)
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
      other is FrustumHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
