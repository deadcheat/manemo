import 'package:manemo/enum.dart' show PaymentType;
import 'package:manemo/model.dart' show Receipt;

class ReceiptViewModel {
  int sumOfCashPayment;
  int sumOfChargePayment;

  ReceiptViewModel() {
    this.sumOfCashPayment = 0;
    this.sumOfChargePayment = 0;
  }
}

ReceiptViewModel sumReceipts(List<Receipt> receipts) {
  var result = new ReceiptViewModel();
  if (receipts == null) {
    return result;
  }
  for (var receipt in receipts) {
    if (receipt == null) {
      continue;
    }
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
