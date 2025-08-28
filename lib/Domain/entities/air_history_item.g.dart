// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AirHistoryItemAdapter extends TypeAdapter<AirHistoryItem> {
  @override
  final int typeId = 10;

  @override
  AirHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AirHistoryItem(
      lengthFt: fields[0] as double,
      lengthIn: fields[1] as double,
      breadthFt: fields[2] as double,
      breadthIn: fields[3] as double,
      heightFt: fields[4] as double,
      heightIn: fields[5] as double,
      persons: fields[6] as int,
      maxTempC: fields[7] as double,
      tons: fields[8] as double,
      savedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AirHistoryItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.lengthFt)
      ..writeByte(1)
      ..write(obj.lengthIn)
      ..writeByte(2)
      ..write(obj.breadthFt)
      ..writeByte(3)
      ..write(obj.breadthIn)
      ..writeByte(4)
      ..write(obj.heightFt)
      ..writeByte(5)
      ..write(obj.heightIn)
      ..writeByte(6)
      ..write(obj.persons)
      ..writeByte(7)
      ..write(obj.maxTempC)
      ..writeByte(8)
      ..write(obj.tons)
      ..writeByte(9)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AirHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
