import 'dart:convert';

Receipt receiptFromJson(String str) {
  final jsonData = json.decode(str);
  return Receipt.fromMap(jsonData);
}

String receiptToJson(Receipt data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Receipt {
  int id;
  int utime;
  String description;
  int price;
  int paymentType;

  Receipt({
    this.id,
    this.utime,
    this.description,
    this.price,
    this.paymentType,
  });

  factory Receipt.fromMap(Map<String, dynamic> m) => new Receipt(
        id: m["id"],
        utime: m["utime"],
        description: m["description"],
        price: m["price"],
        paymentType: m["payment_type"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "utime": utime,
        "description": description,
        "price": price,
        "payment_type": paymentType,
      };

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
  int paymentType;

  RegularReceipt({
    this.id,
    this.utimeMonthFrom,
    this.utimeMonthTo,
    this.dayOfMonth,
    this.description,
    this.price,
    this.paymentType,
  });

  factory RegularReceipt.fromMap(Map<String, dynamic> m) => new RegularReceipt(
        id: m["id"],
        utimeMonthFrom: m["utime_month_from"],
        utimeMonthTo: m["utime_month_to"],
        dayOfMonth: m["day_of_month"],
        description: m["description"],
        price: m["price"],
        paymentType: m["payment_type"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "utime_month_from": utimeMonthFrom,
        "utime_month_to": utimeMonthTo,
        "day_of_month": dayOfMonth,
        "description": description,
        "price": price,
        "payment_type": paymentType,
      };

  @override
  String toString() {
    return super.toString();
  }
}
