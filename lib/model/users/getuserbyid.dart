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
        success: json["success"] ?? false, // Provide default value if null
        message: json["message"] ?? '', // Provide default value if null
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [], // Handle null data field
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
  String? usersImage; // Nullable
  String? usersAddress; // Nullable
  dynamic usersLat;
  dynamic usersLon;

  Datum({
    required this.usersId,
    required this.usersUsername,
    required this.usersPassword,
    required this.usersPhone,
    required this.usersType,
    this.usersImage, // Nullable
    this.usersAddress, // Nullable
    this.usersLat,
    this.usersLon,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        usersId: json["users_id"] ?? 0, // Provide default value if null
        usersUsername:
            json["users_username"] ?? '', // Provide default value if null
        usersPassword:
            json["users_password"] ?? '', // Provide default value if null
        usersPhone: json["users_phone"] ?? '', // Provide default value if null
        usersType: json["users_type"] ?? 0, // Provide default value if null
        usersImage: json["users_image"], // It can be null
        usersAddress: json["users_address"], // It can be null
        usersLat: json["users_lat"], // It can be null
        usersLon: json["users_lon"], // It can be null
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
