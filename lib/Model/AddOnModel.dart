/// error : false
/// message : "Add On Product Get Successfully"
/// data : [{"id":"88","product_id":"83","price":"120","image":"uploads/media/2022/4.png","name":"candles"},{"id":"90","product_id":"83","price":"10","image":"uploads/media/2022/download_(18).jpg","name":"cap"}]

class AddOnModel {
  AddOnModel({
      bool? error, 
      String? message, 
      List<Data>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  AddOnModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  List<Data>? _data;
AddOnModel copyWith({  bool? error,
  String? message,
  List<Data>? data,
}) => AddOnModel(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "88"
/// product_id : "83"
/// price : "120"
/// image : "uploads/media/2022/4.png"
/// name : "candles"

class Data {
  Data({
      String? id, 
      String? productId, 
      String? price, 
      String? image, 
      String? name,}){
    _id = id;
    _productId = productId;
    _price = price;
    _image = image;
    _name = name;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _productId = json['product_id'];
    _price = json['price'];
    _image = json['image'];
    _name = json['name'];
  }
  String? _id;
  String? _productId;
  String? _price;
  String? _image;
  String? _name;
Data copyWith({  String? id,
  String? productId,
  String? price,
  String? image,
  String? name,
}) => Data(  id: id ?? _id,
  productId: productId ?? _productId,
  price: price ?? _price,
  image: image ?? _image,
  name: name ?? _name,
);
  String? get id => _id;
  String? get productId => _productId;
  String? get price => _price;
  String? get image => _image;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['product_id'] = _productId;
    map['price'] = _price;
    map['image'] = _image;
    map['name'] = _name;
    return map;
  }

}