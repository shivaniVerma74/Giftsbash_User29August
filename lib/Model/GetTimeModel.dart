/// error : false
/// message : "Time Slot "
/// data : [{"id":"15","title":"10:00 AM To 12:00 PM","from_time":"10:00:00","to_time":"12:00:00","last_order_time":"11:30:00","delivery_charge":"10","status":"1"},{"id":"16","title":"01:00 PM To 04:00 PM","from_time":"13:00:00","to_time":"16:00:00","last_order_time":"14:30:00","delivery_charge":"20","status":"1"},{"id":"17","title":"04:30 PM To 08:00 PM","from_time":"16:30:00","to_time":"20:00:00","last_order_time":"19:00:00","delivery_charge":"30","status":"1"},{"id":"18","title":"08:00 PM To 11:00 PM","from_time":"20:00:00","to_time":"23:00:00","last_order_time":"22:44:00","delivery_charge":"50","status":"1"}]

class GetTimeModel {
  GetTimeModel({
      bool? error, 
      String? message, 
      List<Data>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  GetTimeModel.fromJson(dynamic json) {
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
GetTimeModel copyWith({  bool? error,
  String? message,
  List<Data>? data,
}) => GetTimeModel(  error: error ?? _error,
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

/// id : "15"
/// title : "10:00 AM To 12:00 PM"
/// from_time : "10:00:00"
/// to_time : "12:00:00"
/// last_order_time : "11:30:00"
/// delivery_charge : "10"
/// status : "1"

class Data {
  Data({
      String? id, 
      String? title, 
      String? fromTime, 
      String? toTime, 
      String? lastOrderTime, 
      String? deliveryCharge, 
      String? status,}){
    _id = id;
    _title = title;
    _fromTime = fromTime;
    _toTime = toTime;
    _lastOrderTime = lastOrderTime;
    _deliveryCharge = deliveryCharge;
    _status = status;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _fromTime = json['from_time'];
    _toTime = json['to_time'];
    _lastOrderTime = json['last_order_time'];
    _deliveryCharge = json['delivery_charge'];
    _status = json['status'];
  }
  String? _id;
  String? _title;
  String? _fromTime;
  String? _toTime;
  String? _lastOrderTime;
  String? _deliveryCharge;
  String? _status;
Data copyWith({  String? id,
  String? title,
  String? fromTime,
  String? toTime,
  String? lastOrderTime,
  String? deliveryCharge,
  String? status,
}) => Data(  id: id ?? _id,
  title: title ?? _title,
  fromTime: fromTime ?? _fromTime,
  toTime: toTime ?? _toTime,
  lastOrderTime: lastOrderTime ?? _lastOrderTime,
  deliveryCharge: deliveryCharge ?? _deliveryCharge,
  status: status ?? _status,
);
  String? get id => _id;
  String? get title => _title;
  String? get fromTime => _fromTime;
  String? get toTime => _toTime;
  String? get lastOrderTime => _lastOrderTime;
  String? get deliveryCharge => _deliveryCharge;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['from_time'] = _fromTime;
    map['to_time'] = _toTime;
    map['last_order_time'] = _lastOrderTime;
    map['delivery_charge'] = _deliveryCharge;
    map['status'] = _status;
    return map;
  }

}