import 'package:hive/hive.dart';

part 'client_model.g.dart';

@HiveType(typeId: 2)
class ClientModel extends HiveObject {
  @HiveField(0)
  String billTo;
  @HiveField(1)
  String clientName;
  @HiveField(2)
  String clientPhone;
  @HiveField(3)
  String clientAddress;
  @HiveField(4)
  String clientEmail;

  ClientModel({
    required this.billTo,
    required this.clientName,
    required this.clientPhone,
    required this.clientAddress,
    required this.clientEmail,
  });
}
