// To parse this JSON data, do
//
//     final offerImage = offerImageFromJson(jsonString);

import 'dart:convert';

OfferImage offerImageFromJson(String str) => OfferImage.fromJson(json.decode(str));

String offerImageToJson(OfferImage data) => json.encode(data.toJson());

class OfferImage {
  String? responseCode;
  String? msg;
  List<Datum>? data;

  OfferImage({
    this.responseCode,
    this.msg,
    this.data,
  });

  factory OfferImage.fromJson(Map<String, dynamic> json) => OfferImage(
    responseCode: json["response_code"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "response_code": responseCode,
    "msg": msg,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? image;
  DateTime? createdAt;

  Datum({
    this.id,
    this.image,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
  };
}
