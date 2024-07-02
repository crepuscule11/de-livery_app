// To parse this JSON data, do
//
//     final usermodel = usermodelFromJson(jsonString);

import 'dart:convert';

Usermodel usermodelFromJson(String str) => Usermodel.fromJson(json.decode(str));

String usermodelToJson(Usermodel data) => json.encode(data.toJson());

class Usermodel {
  int status;
  String message;
  Data data;

  Usermodel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Usermodel.fromJson(Map<String, dynamic> json) => Usermodel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String empId;
  String name;
  String email;
  String username;
  String contactNo;
  String address;
  DateTime birthday;
  String picture;

  Data({
    required this.empId,
    required this.name,
    required this.email,
    required this.username,
    required this.contactNo,
    required this.address,
    required this.birthday,
    required this.picture,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        empId: json["emp_id"],
        name: json["name"],
        email: json["email"],
        username: json["username"],
        contactNo: json["contact_no"],
        address: json["address"],
        birthday: DateTime.parse(json["birthday"]),
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "emp_id": empId,
        "name": name,
        "email": email,
        "username": username,
        "contact_no": contactNo,
        "address": address,
        "birthday":
            "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "picture": picture,
      };
}
