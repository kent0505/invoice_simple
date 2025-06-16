import 'package:hive/hive.dart';

part 'item_model.g.dart';

@HiveType(typeId: 1)
class ItemModel extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? details;

  @HiveField(2)
  bool saveToCatalog;

  @HiveField(3)
  double? unitPrice;

  @HiveField(4)
  int? quantity;

  @HiveField(5)
  String? unitType;

  @HiveField(6)
  double? discount;

  @HiveField(7)
  bool discountActive;

  @HiveField(8)
  bool taxable;

  @HiveField(9)
  double? taxableAmount;

  ItemModel({
    this.name,
    this.details,
    this.saveToCatalog = false,
    this.unitPrice,
    this.quantity,
    this.unitType,
    this.discount,
    this.discountActive = false,
    this.taxable = false,
    this.taxableAmount,
  });
}
