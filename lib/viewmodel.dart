import 'package:manemo/enum.dart' show MoneyType, BalanceType;
import 'package:manemo/model.dart' show Receipt;

class ReceiptViewModel {
  int sumOfCashPayment;
  int sumOfChargePayment;
  int sumOfDepositBalance;

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
    switch (MoneyType.values[receipt.moneyType]) {
      case MoneyType.cash:
        switch (BalanceType.values[receipt.balanceType]) {
          case BalanceType.incomes:
            result.sumOfCashPayment += receipt.price;
            break;
          case BalanceType.expenses:
            result.sumOfCashPayment -= receipt.price;
            break;
        }
        break;
      case MoneyType.charge:
        switch (BalanceType.values[receipt.balanceType]) {
          case BalanceType.incomes:
            result.sumOfChargePayment += receipt.price;
            break;
          case BalanceType.expenses:
            result.sumOfChargePayment -= receipt.price;
            break;
        }
        break;
      case MoneyType.deposit:
        switch (BalanceType.values[receipt.balanceType]) {
          case BalanceType.incomes:
            result.sumOfDepositBalance += receipt.price;
            break;
          case BalanceType.expenses:
            result.sumOfDepositBalance -= receipt.price;
            break;
        }
        break;
    }
  }
  return result;
}
