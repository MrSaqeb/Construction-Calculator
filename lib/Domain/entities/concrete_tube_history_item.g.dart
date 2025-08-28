// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concrete_tube_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConcreteTubeHistoryItemAdapter
    extends TypeAdapter<ConcreteTubeHistoryItem> {
  @override
  final int typeId = 21;

  @override
  ConcreteTubeHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConcreteTubeHistoryItem(
      innerM: fields[0] as String,
      innerCM: fields[1] as String,
      innerFT: fields[2] as String,
      innerIN: fields[3] as String,
      outerM: fields[4] as String,
      outerCM: fields[5] as String,
      outerFT: fields[6] as String,
      outerIN: fields[7] as String,
      heightM: fields[8] as String,
      heightCM: fields[9] as String,
      heightFT: fields[10] as String,
      heightIN: fields[11] as String,
      noOfTubes: fields[12] as String,
      grade: fields[13] as String,
      unit: fields[14] as String,
      concreteVolume: fields[15] as double,
      cementBags: fields[16] as double,
      sandCft: fields[17] as double,
      aggregateCft: fields[18] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ConcreteTubeHistoryItem obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.innerM)
      ..writeByte(1)
      ..write(obj.innerCM)
      ..writeByte(2)
      ..write(obj.innerFT)
      ..writeByte(3)
      ..write(obj.innerIN)
      ..writeByte(4)
      ..write(obj.outerM)
      ..writeByte(5)
      ..write(obj.outerCM)
      ..writeByte(6)
      ..write(obj.outerFT)
      ..writeByte(7)
      ..write(obj.outerIN)
      ..writeByte(8)
      ..write(obj.heightM)
      ..writeByte(9)
      ..write(obj.heightCM)
      ..writeByte(10)
      ..write(obj.heightFT)
      ..writeByte(11)
      ..write(obj.heightIN)
      ..writeByte(12)
      ..write(obj.noOfTubes)
      ..writeByte(13)
      ..write(obj.grade)
      ..writeByte(14)
      ..write(obj.unit)
      ..writeByte(15)
      ..write(obj.concreteVolume)
      ..writeByte(16)
      ..write(obj.cementBags)
      ..writeByte(17)
      ..write(obj.sandCft)
      ..writeByte(18)
      ..write(obj.aggregateCft);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConcreteTubeHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
