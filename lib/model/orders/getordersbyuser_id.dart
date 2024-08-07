// To parse this JSON data, do
//
//     final getOrdersByuserId = getOrdersByuserIdFromJson(jsonString);

import 'dart:convert';

GetOrdersByuserId getOrdersByuserIdFromJson(String str) =>
    GetOrdersByuserId.fromJson(json.decode(str));

String getOrdersByuserIdToJson(GetOrdersByuserId data) =>
    json.encode(data.toJson());

class GetOrdersByuserId {
  bool? success;
  String? message;
  List<Datum>? data;

  GetOrdersByuserId({
    this.success,
    this.message,
    this.data,
  });

  factory GetOrdersByuserId.fromJson(Map<String, dynamic> json) =>
      GetOrdersByuserId(
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
  int? ordersId;
  String? usersUsername;
  int? ordersUsersId;
  String? date;

  Datum({
    this.ordersId,
    this.usersUsername,
    this.ordersUsersId,
    this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        ordersId: json["orders_id"],
        usersUsername: json["users_username"],
        ordersUsersId: json["orders_users_id"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "orders_id": ordersId,
        "users_username": usersUsername,
        "orders_users_id": ordersUsersId,
        "date": date,
      };
}
