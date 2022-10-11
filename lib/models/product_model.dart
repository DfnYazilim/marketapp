/// id : 1
/// name : "Kola"
/// productGroupId : 1
/// price : 5.6

class ProductModel {
  ProductModel({
      this.id, 
      this.name, 
      this.productGroupId, 
      this.productGroupName,
      this.price,});

  ProductModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    productGroupName = json['productGroupName'];
    productGroupId = json['productGroupId'];
    price = json['price'];
  }
  num? id;
  String? name;
  String? productGroupName;
  num? productGroupId;
  num? price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['name'] = name;
    map['productGroupId'] = productGroupId;
    map['price'] = price;
    return map;
  }

}