import 'package:invoice_simple/features/dashboard/ui/widgets/invoice_header_section.dart';

PaymentMethod? paymentMethodFromString(String? value) {
  switch (value) {
    case "Cash":
      return PaymentMethod.cash;
    case "Check":
      return PaymentMethod.check;
    case "Bank":
      return PaymentMethod.bank;
    case "PayPal":
      return PaymentMethod.paypal;
    default:
      return null;
  }
}
