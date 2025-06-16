import 'package:hive/hive.dart';

part 'business_user_model.g.dart';

@HiveType(typeId: 0)
class BusinessUserModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String? phone;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? address;
  @HiveField(4)
  final String currency;
  @HiveField(5)
  final String? imageLogo;
  @HiveField(6)
  final String? imageSignature;

  BusinessUserModel({
    required this.name,
    this.phone,
    this.email,
    this.address,
    required this.currency,
    this.imageLogo,
    this.imageSignature,
  });
}
