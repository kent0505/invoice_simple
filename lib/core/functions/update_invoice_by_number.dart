import 'package:hive/hive.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';

Future<void> updateInvoiceByNumber({
  required int invoiceNumber,
  required InvoiceModel updatedInvoice,
}) async {
  final box = await Hive.openBox<InvoiceModel>(AppConstants.hiveInvoiceBox);

  final invoiceKey = box.keys.firstWhere(
    (key) => box.get(key)?.invoiceNumber == invoiceNumber,
    orElse: () => null,
  );

  if (invoiceKey != null) {
    await box.put(invoiceKey, updatedInvoice);
  } else {}
}

Future<void> deleteInvoiceByNumber({
  required int invoiceNumber,
}) async {
  final box = await Hive.openBox<InvoiceModel>(AppConstants.hiveInvoiceBox);

  final invoiceKey = box.keys.firstWhere(
    (key) => box.get(key)?.invoiceNumber == invoiceNumber,
    orElse: () => null,
  );

  if (invoiceKey != null) {
    await box.delete(invoiceKey);
  } else {}
}
