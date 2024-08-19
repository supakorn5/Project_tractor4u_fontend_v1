// To parse this JSON data, do
//
//     final getJobbyuserId = getJobbyuserIdFromJson(jsonString);

import 'dart:convert';

GetJobbyuserId getJobbyuserIdFromJson(String str) =>
    GetJobbyuserId.fromJson(json.decode(str));

String getJobbyuserIdToJson(GetJobbyuserId data) => json.encode(data.toJson());

class GetJobbyuserId {
  bool? success;
  String? message;
  List<Datum>? data;

  GetJobbyuserId({
    this.success,
    this.message,
    this.data,
  });

  factory GetJobbyuserId.fromJson(Map<String, dynamic> json) => GetJobbyuserId(
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
  DateTime? date;

  Datum({
    this.usersUsername,
    this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        usersUsername: json["users_username"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "users_username": usersUsername,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}
