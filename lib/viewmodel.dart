import 'package:manemo/enum.dart' show PaymentType, BalanceType;
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
        switch (BalanceType.values[receipt.balanceType]) {
          case BalanceType.incomes:
            result.sumOfCashPayment += receipt.price;
            break;
          case BalanceType.expenses:
            result.sumOfCashPayment -= receipt.price;
            break;
        }
        break;
      case PaymentType.charge:
        switch (BalanceType.values[receipt.balanceType]) {
          case BalanceType.incomes:
            result.sumOfCashPayment += receipt.price;
            break;
          case BalanceType.expenses:
            result.sumOfCashPayment -= receipt.price;
            break;
        }
        break;
    }
  }
  return result;
}
