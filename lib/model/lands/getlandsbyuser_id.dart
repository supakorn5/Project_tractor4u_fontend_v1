// To parse this JSON data, do
//
//     final getLandsByUserid = getLandsByUseridFromJson(jsonString);

import 'dart:convert';

GetLandsByUserid getLandsByUseridFromJson(String str) =>
    GetLandsByUserid.fromJson(json.decode(str));

String getLandsByUseridToJson(GetLandsByUserid data) =>
    json.encode(data.toJson());

class GetLandsByUserid {
  bool? success;
  String? message;
  List<Datum>? data;

  GetLandsByUserid({
    this.success,
    this.message,
    this.data,
  });

  factory GetLandsByUserid.fromJson(Map<String, dynamic> json) =>
      GetLandsByUserid(
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
  int? landsId;
  String? landsInfo;
  int? ordersStatus;
  DateTime? date;
  String? usersUsername;

  Datum({
    this.landsId,
    this.landsInfo,
    this.ordersStatus,
    this.date,
    this.usersUsername,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        landsId: json["lands_id"],
        landsInfo: json["lands_info"],
        ordersStatus: json["orders_status"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        usersUsername: json["users_username"],
      );

  Map<String, dynamic> toJson() => {
        "lands_id": landsId,
        "lands_info": landsInfo,
        "orders_status": ordersStatus,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "users_username": usersUsername,
      };
}
