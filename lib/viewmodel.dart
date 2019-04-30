import 'package:manemo/enum.dart';
import 'package:manemo/model.dart';

class ReceiptViewModel {
  int sumOfCashPayment;
  int sumOfChargePayment;
}

ReceiptViewModel sumReceipts(List<Receipt> receipts) {
  var result = new ReceiptViewModel();
  for (var receipt in receipts) {
    switch (PaymentType.values[receipt.paymentType]) {
      case PaymentType.cash:
        result.sumOfCashPayment += receipt.price;
        break;
      case PaymentType.charge:
        result.sumOfChargePayment += receipt.price;
        break;
      default:
    }
  }
  return result;
}
