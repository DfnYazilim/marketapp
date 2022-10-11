/// id : 1
/// amount : 1.5
/// priceRow : 5.6
/// date : "2022-10-11 11:09:00"
/// productId : 1

class SaleModel {
  SaleModel({
      this.id, 
      this.amount, 
      this.priceRow, 
      this.productName,
      this.date,
      this.productId,});

  SaleModel.fromJson(dynamic json) {
    id = json['id'];
    productName = json['productName'];
    amount = json['amount'];
    priceRow = json['priceRow'];
    date = json['date'];
    productId = json['productId'];
  }
  num? id;
  num? amount;
  num? priceRow;
  String? date;
  String? productName;
  num? productId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['amount'] = amount;
    map['priceRow'] = priceRow;
    map['date'] = DateTime.now().toIso8601String();
    map['productId'] = productId;
    return map;
  }

}