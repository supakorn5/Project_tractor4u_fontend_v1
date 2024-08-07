// To parse this JSON data, do
//
//     final getQueueByDate = getQueueByDateFromJson(jsonString);

import 'dart:convert';

GetQueueByDate getQueueByDateFromJson(String str) =>
    GetQueueByDate.fromJson(json.decode(str));

String getQueueByDateToJson(GetQueueByDate data) => json.encode(data.toJson());

class GetQueueByDate {
  bool? success;
  String? message;
  List<Datum>? data;

  GetQueueByDate({
    this.success,
    this.message,
    this.data,
  });

  factory GetQueueByDate.fromJson(Map<String, dynamic> json) => GetQueueByDate(
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
  int? ordersStatus;
  int? landsSizeRai;

  Datum({
    this.ordersId,
    this.usersUsername,
    this.ordersStatus,
    this.landsSizeRai,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        ordersId: json["orders_id"],
        usersUsername: json["users_username"],
        ordersStatus: json["orders_status"],
        landsSizeRai: json["lands_size_rai"],
      );

  Map<String, dynamic> toJson() => {
        "orders_id": ordersId,
        "users_username": usersUsername,
        "orders_status": ordersStatus,
        "lands_size_rai": landsSizeRai,
      };
}
