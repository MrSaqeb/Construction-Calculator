// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'construction_cost_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConstructionCostHistoryItemAdapter
    extends TypeAdapter<ConstructionCostHistoryItem> {
  @override
  final int typeId = 1;

  @override
  ConstructionCostHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConstructionCostHistoryItem(
      area: fields[1] as double?,
      costInput: fields[21] as double?,
      totalCost: fields[2] as double?,
      materialQuantity: fields[3] as double?,
      unit: fields[4] as String?,
      dateTime: fields[5] as DateTime?,
      cementCost: fields[6] as double?,
      sandCost: fields[7] as double?,
      aggregateCost: fields[8] as double?,
      streetCost: fields[9] as double?,
      finishersCost: fields[10] as double?,
      fittingsCost: fields[11] as double?,
      cementQty: fields[12] as double?,
      sandQty: fields[13] as double?,
      aggregateQty: fields[14] as double?,
      streetQty: fields[15] as double?,
      paintQty: fields[16] as double?,
      bricksQty: fields[17] as double?,
      costPerSqFt: fields[18] as double?,
      materialCosts: (fields[19] as Map?)?.cast<String, String>(),
      materialQuantities: (fields[20] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ConstructionCostHistoryItem obj) {
    writer
      ..writeByte(21)
      ..writeByte(1)
      ..write(obj.area)
      ..writeByte(2)
      ..write(obj.totalCost)
      ..writeByte(3)
      ..write(obj.materialQuantity)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.dateTime)
      ..writeByte(6)
      ..write(obj.cementCost)
      ..writeByte(7)
      ..write(obj.sandCost)
      ..writeByte(8)
      ..write(obj.aggregateCost)
      ..writeByte(9)
      ..write(obj.streetCost)
      ..writeByte(10)
      ..write(obj.finishersCost)
      ..writeByte(11)
      ..write(obj.fittingsCost)
      ..writeByte(12)
      ..write(obj.cementQty)
      ..writeByte(13)
      ..write(obj.sandQty)
      ..writeByte(14)
      ..write(obj.aggregateQty)
      ..writeByte(15)
      ..write(obj.streetQty)
      ..writeByte(16)
      ..write(obj.paintQty)
      ..writeByte(17)
      ..write(obj.bricksQty)
      ..writeByte(18)
      ..write(obj.costPerSqFt)
      ..writeByte(19)
      ..write(obj.materialCosts)
      ..writeByte(20)
      ..write(obj.materialQuantities)
      ..writeByte(21)
      ..write(obj.costInput);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConstructionCostHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
