part of 'item_model.dart';

class ItemModelAdapter extends TypeAdapter<ItemModel> {
  @override
  final int typeId = 1;

  @override
  ItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemModel(
      name: fields[0] as String?,
      details: fields[1] as String?,
      saveToCatalog: fields[2] as bool,
      unitPrice: fields[3] as double?,
      quantity: fields[4] as int?,
      unitType: fields[5] as String?,
      discount: fields[6] as double?,
      discountActive: fields[7] as bool,
      taxable: fields[8] as bool,
      taxableAmount: fields[9] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ItemModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.details)
      ..writeByte(2)
      ..write(obj.saveToCatalog)
      ..writeByte(3)
      ..write(obj.unitPrice)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.unitType)
      ..writeByte(6)
      ..write(obj.discount)
      ..writeByte(7)
      ..write(obj.discountActive)
      ..writeByte(8)
      ..write(obj.taxable)
      ..writeByte(9)
      ..write(obj.taxableAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
