// To parse this JSON data, do
//
//     final deliverModel = deliverModelFromJson(jsonString);

import 'dart:convert';

ShippedModel deliverModelFromJson(String str) =>
    ShippedModel.fromJson(json.decode(str));

String deliverModelToJson(ShippedModel data) => json.encode(data.toJson());

class ShippedModel {
  int status;
  String message;
  List<Shipped> orders;

  ShippedModel({
    required this.status,
    required this.message,
    required this.orders,
  });

  factory ShippedModel.fromJson(Map<String, dynamic> json) => ShippedModel(
        status: json["status"],
        message: json["message"],
        orders:
            List<Shipped>.from(json["orders"].map((x) => Shipped.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Shipped {
  String transactionId;
  String orderStatus;
  String custId;
  String custName;
  String paymentType;
  String address;
  double total;

  Shipped({
    required this.transactionId,
    required this.orderStatus,
    required this.custId,
    required this.custName,
    required this.paymentType,
    required this.address,
    required this.total,
  });

  factory Shipped.fromJson(Map<String, dynamic> json) => Shipped(
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
