// To parse this JSON data, do
//
//     final getOrdersByLandsId = getOrdersByLandsIdFromJson(jsonString);

import 'dart:convert';

GetOrdersByLandsId getOrdersByLandsIdFromJson(String str) =>
    GetOrdersByLandsId.fromJson(json.decode(str));

String getOrdersByLandsIdToJson(GetOrdersByLandsId data) =>
    json.encode(data.toJson());

class GetOrdersByLandsId {
  bool? success;
  String? message;
  List<Datum>? data;

  GetOrdersByLandsId({
    this.success,
    this.message,
    this.data,
  });

  factory GetOrdersByLandsId.fromJson(Map<String, dynamic> json) =>
      GetOrdersByLandsId(
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
  String? usersUsername;
  int? ordersStatus;
  DateTime? date;

  Datum({
    this.usersUsername,
    this.ordersStatus,
    this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        usersUsername: json["users_username"],
        ordersStatus: json["orders_status"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "users_username": usersUsername,
        "orders_status": ordersStatus,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}
