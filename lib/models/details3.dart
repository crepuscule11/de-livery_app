// To parse this JSON data, do
//
//     final deliverModel = deliverModelFromJson(jsonString);

import 'dart:convert';

Delivered deliverModelFromJson(String str) =>
    Delivered.fromJson(json.decode(str));

String deliverModelToJson(Delivered data) => json.encode(data.toJson());

class Delivered {
  int status;
  String message;
  List<Done> orders;

  Delivered({
    required this.status,
    required this.message,
    required this.orders,
  });

  factory Delivered.fromJson(Map<String, dynamic> json) => Delivered(
        status: json["status"],
        message: json["message"],
        orders: List<Done>.from(json["orders"].map((x) => Done.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Done {
  String transactionId;
  String orderStatus;
  String custId;
  String custName;
  String paymentType;
  String address;
  double total;

  Done({
    required this.transactionId,
    required this.orderStatus,
    required this.custId,
    required this.custName,
    required this.paymentType,
    required this.address,
    required this.total,
  });

  factory Done.fromJson(Map<String, dynamic> json) => Done(
        transactionId: json["transaction_id"],
        orderStatus: json["order_status"],
        custId: json["cust_id"],
        custName: json["cust_name"],
        paymentType: json["payment_type"],
        address: json["address"],
        total: json["total"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "order_status": orderStatus,
        "cust_id": custId,
        "cust_name": custName,
        "payment_type": paymentType,
        "address": address,
        "total": total,
      };
}
