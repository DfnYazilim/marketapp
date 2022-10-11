/// id : 1
/// name : "İçeçecekler"

class ProductGroupModel {
  ProductGroupModel({
      this.id, 
      this.name,});

  ProductGroupModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  num? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['name'] = name;
    return map;
  }

}