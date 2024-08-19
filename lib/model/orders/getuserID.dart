// To parse this JSON data, do
//
//     final getuserId = getuserIdFromJson(jsonString);

import 'dart:convert';

GetuserId getuserIdFromJson(String str) => GetuserId.fromJson(json.decode(str));

String getuserIdToJson(GetuserId data) => json.encode(data.toJson());

class GetuserId {
  bool? success;
  String? message;
  List<Datum>? data;

  GetuserId({
    this.success,
    this.message,
    this.data,
  });

  factory GetuserId.fromJson(Map<String, dynamic> json) => GetuserId(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? ownersUsersId;

  Datum({
    this.ownersUsersId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        ownersUsersId: json["owners_users_id"],
      );

  Map<String, dynamic> toJson() => {
        "owners_users_id": ownersUsersId,
      };
}
