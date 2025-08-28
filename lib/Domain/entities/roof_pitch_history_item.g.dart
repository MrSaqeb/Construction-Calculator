// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roof_pitch_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoofPitchHistoryItemAdapter extends TypeAdapter<RoofPitchHistoryItem> {
  @override
  final int typeId = 22;

  @override
  RoofPitchHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoofPitchHistoryItem(
      heightM: fields[0] as String,
      heightCM: fields[1] as String,
      heightFT: fields[2] as String,
      heightIN: fields[3] as String,
      widthM: fields[4] as String,
      widthCM: fields[5] as String,
      widthFT: fields[6] as String,
      widthIN: fields[7] as String,
      unit: fields[8] as String,
      roofPitch: fields[9] as double,
      roofSlope: fields[10] as double,
      roofAngle: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RoofPitchHistoryItem obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.heightM)
      ..writeByte(1)
      ..write(obj.heightCM)
      ..writeByte(2)
      ..write(obj.heightFT)
      ..writeByte(3)
      ..write(obj.heightIN)
      ..writeByte(4)
      ..write(obj.widthM)
      ..writeByte(5)
      ..write(obj.widthCM)
      ..writeByte(6)
      ..write(obj.widthFT)
      ..writeByte(7)
      ..write(obj.widthIN)
      ..writeByte(8)
      ..write(obj.unit)
      ..writeByte(9)
      ..write(obj.roofPitch)
      ..writeByte(10)
      ..write(obj.roofSlope)
      ..writeByte(11)
      ..write(obj.roofAngle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoofPitchHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
