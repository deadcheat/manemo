import 'dart:convert';

Receipt receiptFromJson(String str) {
  final jsonData = json.decode(str);
  return Receipt.fromJson(jsonData);
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

  factory Receipt.fromJson(Map<String, dynamic> json) => new Receipt(
        id: json["id"],
        utime: json["utime"],
        description: json["description"],
        price: json["price"],
        continuationType: json["continuation_type"],
        paymentType: json["payment_type"],
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
