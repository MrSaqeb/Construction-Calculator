// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steal_weight_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StealWeightHistoryAdapter extends TypeAdapter<StealWeightHistory> {
  @override
  final int typeId = 24;

  @override
  StealWeightHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StealWeightHistory(
      inputVolume: fields[0] as String,
      steelType: fields[1] as String,
      calculatedWeight: fields[2] as String,
      savedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StealWeightHistory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.inputVolume)
      ..writeByte(1)
      ..write(obj.steelType)
      ..writeByte(2)
      ..write(obj.calculatedWeight)
      ..writeByte(3)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StealWeightHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
