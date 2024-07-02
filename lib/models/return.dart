import 'package:meta/meta.dart';
import 'dart:convert';

class Balik {
  int status;
  String message;
  List<Datum> data;

  Balik({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Balik.fromJson(String str) => Balik.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Balik.fromMap(Map<String, dynamic> json) {
    if (json["data"] == null) {
      // Handle the case where "data" is null, maybe return an empty list or throw an error
      return Balik(
        status: json["status"],
        message: json["message"],
        data: [],
      );
    } else {
      return Balik(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );
    }
  }

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Datum {
  String returnId;
  String transactionId;
  String returnReason;
  String returnAmount;
  String returnDate;

  Datum({
    required this.returnId,
    required this.transactionId,
    required this.returnReason,
    required this.returnAmount,
    required this.returnDate,
  });

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        returnId: json["return_id"],
        transactionId: json["transaction_id"],
        returnReason: json["return_reason"],
        returnAmount: json["return_amount"],
        returnDate: json["return_date"],
      );

  Map<String, dynamic> toMap() => {
        "return_id": returnId,
        "transaction_id": transactionId,
        "return_reason": returnReason,
        "return_amount": returnAmount,
        "return_date": returnDate,
      };
}
