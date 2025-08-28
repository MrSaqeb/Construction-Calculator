// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beam_steal_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BeamStealHistoryItemAdapter extends TypeAdapter<BeamStealHistoryItem> {
  @override
  final int typeId = 26;

  @override
  BeamStealHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BeamStealHistoryItem(
      sizeA: fields[0] as double,
      sizeB: fields[1] as double,
      sizeT: fields[2] as double,
      sizeS: fields[3] as double,
      length: fields[4] as double,
      pieces: fields[5] as int,
      material: fields[6] as String,
      lengthUnit: fields[7] as String,
      weightUnit: fields[8] as String,
      costPerKg: fields[9] as double,
      weightKg: fields[10] as double,
      weightTons: fields[11] as double,
      totalCost: fields[12] as double,
      savedAt: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BeamStealHistoryItem obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.sizeA)
      ..writeByte(1)
      ..write(obj.sizeB)
      ..writeByte(2)
      ..write(obj.sizeT)
      ..writeByte(3)
      ..write(obj.sizeS)
      ..writeByte(4)
      ..write(obj.length)
      ..writeByte(5)
      ..write(obj.pieces)
      ..writeByte(6)
      ..write(obj.material)
      ..writeByte(7)
      ..write(obj.lengthUnit)
      ..writeByte(8)
      ..write(obj.weightUnit)
      ..writeByte(9)
      ..write(obj.costPerKg)
      ..writeByte(10)
      ..write(obj.weightKg)
      ..writeByte(11)
      ..write(obj.weightTons)
      ..writeByte(12)
      ..write(obj.totalCost)
      ..writeByte(13)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeamStealHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
