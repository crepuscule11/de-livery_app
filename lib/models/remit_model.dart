class RemitDetails {
  int? status;
  String? message;
  ReturnDetails? returnDetails;
  List<Items>? items;

  RemitDetails({this.status, this.message, this.returnDetails, this.items});

  RemitDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    returnDetails = json['return_details'] != null
        ? new ReturnDetails.fromJson(json['return_details'])
        : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.returnDetails != null) {
      data['return_details'] = this.returnDetails!.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReturnDetails {
  String? returnId;
  String? returnReason;
  String? returnAmount;
  String? returnDate;
  String? name;
  String? address;
  String? contactNo;

  ReturnDetails(
      {this.returnId,
      this.returnReason,
      this.returnAmount,
      this.returnDate,
      this.name,
      this.address,
      this.contactNo});

  ReturnDetails.fromJson(Map<String, dynamic> json) {
    returnId = json['return_id'];
    returnReason = json['return_reason'];
    returnAmount = json['return_amount'];
    returnDate = json['return_date'];
    name = json['name'];
    address = json['address'];
    contactNo = json['contact_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['return_id'] = this.returnId;
    data['return_reason'] = this.returnReason;
    data['return_amount'] = this.returnAmount;
    data['return_date'] = this.returnDate;
    data['name'] = this.name;
    data['address'] = this.address;
    data['contact_no'] = this.contactNo;
    return data;
  }
}

class Items {
  String? productName;
  Null? mG;
  Null? g;
  String? mL;
  String? productImg;
  String? expirationDate;
  String? qty;

  Items(
      {this.productName,
      this.mG,
      this.g,
      this.mL,
      this.productImg,
      this.expirationDate,
      this.qty});

  Items.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    mG = json['MG'];
    g = json['G'];
    mL = json['ML'];
    productImg = json['product_img'];
    expirationDate = json['expiration_date'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['MG'] = this.mG;
    data['G'] = this.g;
    data['ML'] = this.mL;
    data['product_img'] = this.productImg;
    data['expiration_date'] = this.expirationDate;
    data['qty'] = this.qty;
    return data;
  }
}
