import 'dart:convert';

import 'package:manemo/enum.dart';

OneTimeReceipt receiptFromJson(String str) {
  final jsonData = json.decode(str);
  return OneTimeReceipt.fromMap(jsonData);
}

String receiptToJson(OneTimeReceipt data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Receipt {
  int id;
  int utime;
  String description;
  int price;
  int continuationType;
  int balanceType;
  int moneyType;

  Receipt({
    this.id,
    this.utime,
    this.description,
    this.price,
    this.continuationType,
    this.balanceType,
    this.moneyType,
  });

  @override
  String toString() {
    return super.toString();
  }
}

class OneTimeReceipt {
  int id;
  int utime;
  String description;
  int price;
  int balanceType;
  int moneyType;

  OneTimeReceipt({
    this.id,
    this.utime,
    this.description,
    this.price,
    this.balanceType,
    this.moneyType,
  });

  factory OneTimeReceipt.fromMap(Map<String, dynamic> m) => new OneTimeReceipt(
        id: m["id"],
        utime: m["utime"],
        description: m["description"],
        price: m["price"],
        balanceType: m["balance_type"],
        moneyType: m["money_type"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "utime": utime,
        "description": description,
        "price": price,
        "balance_type": balanceType,
        "money_type": moneyType,
      };

  Receipt toReceipt() => new Receipt(
        id: id,
        utime: utime,
        description: description,
        continuationType: ContinuationType.onetime.index,
        price: price,
        balanceType: balanceType,
        moneyType: moneyType,
      );

  @override
  String toString() {
    return super.toString();
  }
}

RegularReceipt regularReceiptFromJson(String str) {
  final jsonData = json.decode(str);
  return RegularReceipt.fromMap(jsonData);
}

String regularReceiptToJson(RegularReceipt data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class RegularReceipt {
  int id;
  int utimeMonthFrom;
  int utimeMonthTo;
  int dayOfMonth;
  String description;
  int price;
  int balanceType;
  int moneyType;

  RegularReceipt({
    this.id,
    this.utimeMonthFrom,
    this.utimeMonthTo,
    this.dayOfMonth,
    this.description,
    this.price,
    this.balanceType,
    this.moneyType,
  });

  factory RegularReceipt.fromMap(Map<String, dynamic> m) => new RegularReceipt(
        id: m["id"],
        utimeMonthFrom: m["utime_month_from"],
        utimeMonthTo: m["utime_month_to"],
        dayOfMonth: m["day_of_month"],
        description: m["description"],
        price: m["price"],
        balanceType: m["balance_type"],
        moneyType: m["money_type"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "utime_month_from": utimeMonthFrom,
        "utime_month_to": utimeMonthTo,
        "day_of_month": dayOfMonth,
        "description": description,
        "price": price,
        "balance_type": balanceType,
        "money_type": moneyType,
      };

  Receipt toReceipt(int year, int month) => new Receipt(
        id: id,
        utime: DateTime(year, month, dayOfMonth).millisecondsSinceEpoch,
        description: description,
        continuationType: ContinuationType.regularly.index,
        price: price,
        balanceType: balanceType,
        moneyType: moneyType,
      );

  @override
  String toString() {
    return super.toString();
  }
}
