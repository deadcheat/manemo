import 'dart:convert';

Monemo receiptFromJson(String str) {
  final jsonData = json.decode(str);
  return Monemo.fromJson(jsonData);
}

String receiptToJson(Monemo data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Monemo {
  int id;
  int utime;
  String description;
  int paymentType;

  Monemo({
    this.id,
    this.utime,
    this.description,
    this.paymentType,
  });

  factory Monemo.fromJson(Map<String, dynamic> json) => new Monemo(
        id: json["id"],
        utime: json["utime"],
        description: json["description"],
        paymentType: json["payment_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "utime": utime,
        "description": description,
        "payment_type": paymentType,
      };
}
