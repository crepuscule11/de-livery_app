// To parse this JSON data, do
//
//     final deliverModel = deliverModelFromJson(jsonString);

import 'dart:convert';

DeliverModel deliverModelFromJson(String str) =>
    DeliverModel.fromJson(json.decode(str));

String deliverModelToJson(DeliverModel data) => json.encode(data.toJson());

class DeliverModel {
  int status;
  String message;
  List<Order> orders;

  DeliverModel({
    required this.status,
    required this.message,
    required this.orders,
  });

  factory DeliverModel.fromJson(Map<String, dynamic> json) => DeliverModel(
        status: json["status"],
        message: json["message"],
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  String transactionId;
  String orderStatus;
  String custId;
  String custName;
  String paymentType;
  String address;
  double total;

  Order({
    required this.transactionId,
    required this.orderStatus,
    required this.custId,
    required this.custName,
    required this.paymentType,
    required this.address,
    required this.total,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
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
