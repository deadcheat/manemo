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
  int continuationType;
  int paymentType;

  Receipt({
    this.id,
    this.utime,
    this.description,
    this.price,
    this.continuationType,
    this.paymentType,
  });

  factory Receipt.fromMap(Map<String, dynamic> m) => new Receipt(
        id: m["id"],
        utime: m["utime"],
        description: m["description"],
        price: m["price"],
        continuationType: m["continuation_type"],
        paymentType: m["payment_type"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "utime": utime,
        "description": description,
        "price": price,
        "continuation_type": continuationType,
        "payment_type": paymentType,
      };
}
