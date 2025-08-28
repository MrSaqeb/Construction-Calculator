// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitchen_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KitchenHistoryItemAdapter extends TypeAdapter<KitchenHistoryItem> {
  @override
  final int typeId = 8;

  @override
  KitchenHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KitchenHistoryItem(
      selectedUnit: fields[0] as String,
      shape: fields[1] as String,
      height: fields[2] as double,
      width: fields[3] as double?,
      depth: fields[4] as double,
      area: fields[5] as double,
      savedAt: fields[6] as DateTime,
      placeholder: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, KitchenHistoryItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.selectedUnit)
      ..writeByte(1)
      ..write(obj.shape)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.width)
      ..writeByte(4)
      ..write(obj.depth)
      ..writeByte(5)
      ..write(obj.area)
      ..writeByte(6)
      ..write(obj.savedAt)
      ..writeByte(7)
      ..write(obj.placeholder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KitchenHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
