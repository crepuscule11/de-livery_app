import 'package:meta/meta.dart';
import 'dart:convert';

class Rtn {
  int status;
  String message;

  Rtn({
    required this.status,
    required this.message,
  });

  factory Rtn.fromJson(String str) => Rtn.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Rtn.fromMap(Map<String, dynamic> json) => Rtn(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
      };
}
