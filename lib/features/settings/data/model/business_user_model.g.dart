part of 'business_user_model.dart';

class BusinessUserModelAdapter extends TypeAdapter<BusinessUserModel> {
  @override
  final int typeId = 0;

  @override
  BusinessUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessUserModel(
      name: fields[0] as String,
      phone: fields[1] as String?,
      email: fields[2] as String?,
      address: fields[3] as String?,
      currency: fields[4] as String,
      imageLogo: fields[5] as String?,
      imageSignature: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessUserModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.imageLogo)
      ..writeByte(6)
      ..write(obj.imageSignature);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
