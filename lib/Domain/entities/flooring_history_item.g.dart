// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flooring_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlooringHistoryItemAdapter extends TypeAdapter<FlooringHistoryItem> {
  @override
  final int typeId = 7;

  @override
  FlooringHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlooringHistoryItem(
      selectedUnit: fields[0] as String,
      floorLength: fields[1] as double,
      floorWidth: fields[2] as double,
      tileLength: fields[3] as double,
      tileWidth: fields[4] as double,
      totalTiles: fields[5] as int,
      cementBags: fields[6] as double,
      sandTons: fields[7] as double,
      mortarVolume: fields[8] as double,
      savedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FlooringHistoryItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.selectedUnit)
      ..writeByte(1)
      ..write(obj.floorLength)
      ..writeByte(2)
      ..write(obj.floorWidth)
      ..writeByte(3)
      ..write(obj.tileLength)
      ..writeByte(4)
      ..write(obj.tileWidth)
      ..writeByte(5)
      ..write(obj.totalTiles)
      ..writeByte(6)
      ..write(obj.cementBags)
      ..writeByte(7)
      ..write(obj.sandTons)
      ..writeByte(8)
      ..write(obj.mortarVolume)
      ..writeByte(9)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlooringHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
