import 'package:meta/meta.dart';
import 'dart:convert';

class Ordet {
  int status;
  String message;
  Redd orderDetails;

  Ordet({
    required this.status,
    required this.message,
    required this.orderDetails,
  });

  factory Ordet.fromJson(String str) => Ordet.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ordet.fromMap(Map<String, dynamic> json) => Ordet(
        status: json["status"],
        message: json["message"],
        orderDetails: Redd.fromMap(json["order_details"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "order_details": orderDetails.toMap(),
      };
}

class Redd {
  String transactionId;
  String orderStatus;
  String custId;
  String custName;
  String paymentType;
  String address;
  int total;
  List<Product> products;

  Redd({
    required this.transactionId,
    required this.orderStatus,
    required this.custId,
    required this.custName,
    required this.paymentType,
    required this.address,
    required this.total,
    required this.products,
  });

  factory Redd.fromJson(String str) => Redd.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Redd.fromMap(Map<String, dynamic> json) => Redd(
        transactionId: json["transaction_id"],
        orderStatus: json["order_status"],
        custId: json["cust_id"],
        custName: json["cust_name"],
        paymentType: json["payment_type"],
        address: json["address"],
        total: json["total"],
        products:
            List<Product>.from(json["products"].map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "transaction_id": transactionId,
        "order_status": orderStatus,
        "cust_id": custId,
        "cust_name": custName,
        "payment_type": paymentType,
        "address": address,
        "total": total,
        "products": List<dynamic>.from(products.map((x) => x.toMap())),
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

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        productName: json["product_name"],
        productImg: json["product_img"],
        qty: json["qty"],
        amount: json["amount"],
      );

  Map<String, dynamic> toMap() => {
        "product_name": productName,
        "product_img": productImg,
        "qty": qty,
        "amount": amount,
      };
}
