part of 'client_model.dart';

class ClientModelAdapter extends TypeAdapter<ClientModel> {
  @override
  final int typeId = 2;

  @override
  ClientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientModel(
      billTo: fields[0] as String,
      clientName: fields[1] as String,
      clientPhone: fields[2] as String,
      clientAddress: fields[3] as String,
      clientEmail: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClientModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.billTo)
      ..writeByte(1)
      ..write(obj.clientName)
      ..writeByte(2)
      ..write(obj.clientPhone)
      ..writeByte(3)
      ..write(obj.clientAddress)
      ..writeByte(4)
      ..write(obj.clientEmail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
