// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anti_termite_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AntiTermiteHistoryItemAdapter
    extends TypeAdapter<AntiTermiteHistoryItem> {
  @override
  final int typeId = 17;

  @override
  AntiTermiteHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AntiTermiteHistoryItem(
      lenM: fields[0] as String,
      lenCM: fields[1] as String,
      lenFT: fields[2] as String,
      lenIN: fields[3] as String,
      widthM: fields[4] as String,
      widthCM: fields[5] as String,
      widthFT: fields[6] as String,
      widthIN: fields[7] as String,
      area: fields[8] as double,
      chemicalQuantity: fields[9] as double,
      unit: fields[10] as String,
      savedAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AntiTermiteHistoryItem obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.lenM)
      ..writeByte(1)
      ..write(obj.lenCM)
      ..writeByte(2)
      ..write(obj.lenFT)
      ..writeByte(3)
      ..write(obj.lenIN)
      ..writeByte(4)
      ..write(obj.widthM)
      ..writeByte(5)
      ..write(obj.widthCM)
      ..writeByte(6)
      ..write(obj.widthFT)
      ..writeByte(7)
      ..write(obj.widthIN)
      ..writeByte(8)
      ..write(obj.area)
      ..writeByte(9)
      ..write(obj.chemicalQuantity)
      ..writeByte(10)
      ..write(obj.unit)
      ..writeByte(11)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AntiTermiteHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
