// To parse this JSON data, do
//
//     final getuserbyid = getuserbyidFromJson(jsonString);

import 'dart:convert';

Getuserbyid getuserbyidFromJson(String str) =>
    Getuserbyid.fromJson(json.decode(str));

String getuserbyidToJson(Getuserbyid data) => json.encode(data.toJson());

class Getuserbyid {
  bool success;
  String message;
  List<Datum> data;

  Getuserbyid({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Getuserbyid.fromJson(Map<String, dynamic> json) => Getuserbyid(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int usersId;
  String usersUsername;
  String usersPassword;
  String usersPhone;
  int usersType;
  String usersImage;
  dynamic usersAddress;
  dynamic usersLat;
  dynamic usersLon;

  Datum({
    required this.usersId,
    required this.usersUsername,
    required this.usersPassword,
    required this.usersPhone,
    required this.usersType,
    required this.usersImage,
    required this.usersAddress,
    required this.usersLat,
    required this.usersLon,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        usersId: json["users_id"],
        usersUsername: json["users_username"],
        usersPassword: json["users_password"],
        usersPhone: json["users_phone"],
        usersType: json["users_type"],
        usersImage: json["users_image"],
        usersAddress: json["users_address"],
        usersLat: json["users_lat"],
        usersLon: json["users_lon"],
      );

  Map<String, dynamic> toJson() => {
        "users_id": usersId,
        "users_username": usersUsername,
        "users_password": usersPassword,
        "users_phone": usersPhone,
        "users_type": usersType,
        "users_image": usersImage,
        "users_address": usersAddress,
        "users_lat": usersLat,
        "users_lon": usersLon,
      };
}
