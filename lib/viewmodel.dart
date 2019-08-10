import 'package:manemo/enum.dart' show MoneyType, BalanceType;
import 'package:manemo/model.dart' show Receipt;

class ReceiptViewModel {
  int sumOfCashPayment;
  int sumOfChargePayment;
  int sumOfAccountBalance;

  ReceiptViewModel() {
    this.sumOfCashPayment = 0;
    this.sumOfChargePayment = 0;
    this.sumOfAccountBalance = 0;
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
      case MoneyType.account:
        switch (BalanceType.values[receipt.balanceType]) {
          case BalanceType.incomes:
            result.sumOfAccountBalance += receipt.price;
            break;
          case BalanceType.expenses:
            result.sumOfAccountBalance -= receipt.price;
            break;
        }
        break;
    }
  }
  return result;
}
