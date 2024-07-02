import 'package:meta/meta.dart';
import 'dart:convert';

class Remitdetails2 {
  int status;
  String message;
  Red2 returnDetails;
  List<Item2> items;

  Remitdetails2({
    required this.status,
    required this.message,
    required this.returnDetails,
    required this.items,
  });

  factory Remitdetails2.fromJson(String str) =>
      Remitdetails2.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Remitdetails2.fromMap(Map<String, dynamic> json) => Remitdetails2(
        status: json["status"],
        message: json["message"],
        returnDetails: Red2.fromMap(json["return_details"]),
        items: List<Item2>.from(json["items"].map((x) => Item2.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "return_details": returnDetails.toMap(),
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
      };
}

class Item2 {
  String productName;
  dynamic mg;
  dynamic g;
  dynamic ml;
  String productImg;
  DateTime expirationDate;
  String qty;

  Item2({
    required this.productName,
    required this.mg,
    required this.g,
    required this.ml,
    required this.productImg,
    required this.expirationDate,
    required this.qty,
  });

  factory Item2.fromJson(String str) => Item2.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item2.fromMap(Map<String, dynamic> json) => Item2(
        productName: json["product_name"],
        mg: json["MG"],
        g: json["G"],
        ml: json["ML"],
        productImg: json["product_img"],
        expirationDate: DateTime.parse(json["expiration_date"]),
        qty: json["qty"],
      );

  Map<String, dynamic> toMap() => {
        "product_name": productName,
        "MG": mg,
        "G": g,
        "ML": ml,
        "product_img": productImg,
        "expiration_date":
            "${expirationDate.year.toString().padLeft(4, '0')}-${expirationDate.month.toString().padLeft(2, '0')}-${expirationDate.day.toString().padLeft(2, '0')}",
        "qty": qty,
      };
}

class Red2 {
  String returnId;
  String returnReason;
  String returnAmount;
  DateTime returnDate;
  String name;
  String address;
  String contactNo;

  Red2({
    required this.returnId,
    required this.returnReason,
    required this.returnAmount,
    required this.returnDate,
    required this.name,
    required this.address,
    required this.contactNo,
  });

  factory Red2.fromJson(String str) => Red2.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Red2.fromMap(Map<String, dynamic> json) => Red2(
        returnId: json["return_id"],
        returnReason: json["return_reason"],
        returnAmount: json["return_amount"],
        returnDate: DateTime.parse(json["return_date"]),
        name: json["name"],
        address: json["address"],
        contactNo: json["contact_no"],
      );

  Map<String, dynamic> toMap() => {
        "return_id": returnId,
        "return_reason": returnReason,
        "return_amount": returnAmount,
        "return_date":
            "${returnDate.year.toString().padLeft(4, '0')}-${returnDate.month.toString().padLeft(2, '0')}-${returnDate.day.toString().padLeft(2, '0')}",
        "name": name,
        "address": address,
        "contact_no": contactNo,
      };
}
