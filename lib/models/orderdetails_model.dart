// To parse this JSON data, do
//
//     final leny = lenyFromJson(jsonString);

import 'dart:convert';

Leny lenyFromJson(String str) => Leny.fromJson(json.decode(str));

String lenyToJson(Leny data) => json.encode(data.toJson());

class Leny {
  int status;
  String message;
  OrderDetails orderDetails;

  Leny({
    required this.status,
    required this.message,
    required this.orderDetails,
  });

  factory Leny.fromJson(Map<String, dynamic> json) => Leny(
        status: json["status"],
        message: json["message"],
        orderDetails: OrderDetails.fromJson(json["order_details"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "order_details": orderDetails.toJson(),
      };
}

class OrderDetails {
  String transactionId;
  String orderStatus;
  String custId;
  String custName;
  String paymentType;
  String address;
  int total;
  List<Product> products;

  OrderDetails({
    required this.transactionId,
    required this.orderStatus,
    required this.custId,
    required this.custName,
    required this.paymentType,
    required this.address,
    required this.total,
    required this.products,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        transactionId: json["transaction_id"],
        orderStatus: json["order_status"],
        custId: json["cust_id"],
        custName: json["cust_name"],
        paymentType: json["payment_type"],
        address: json["address"],
        total: json["total"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "order_status": orderStatus,
        "cust_id": custId,
        "cust_name": custName,
        "payment_type": paymentType,
        "address": address,
        "total": total,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  String productName;
  String productImg;
  int qty;
  int amount;

  Product({
    required this.productName,
    required this.productImg,
    required this.qty,
    required this.amount,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productName: json["product_name"],
        productImg: json["product_img"],
        qty: json["qty"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "product_img": productImg,
        "qty": qty,
        "amount": amount,
      };
}
