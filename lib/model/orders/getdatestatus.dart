// To parse this JSON data, do
//
//     final getDateStatus = getDateStatusFromJson(jsonString);

import 'dart:convert';

GetDateStatus getDateStatusFromJson(String str) =>
    GetDateStatus.fromJson(json.decode(str));

String getDateStatusToJson(GetDateStatus data) => json.encode(data.toJson());

class GetDateStatus {
  bool? success;
  String? message;
  List<Datum>? data;

  GetDateStatus({
    this.success,
    this.message,
    this.data,
  });

  factory GetDateStatus.fromJson(Map<String, dynamic> json) => GetDateStatus(
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
  int? dateStatusId;
  int? dateStatusStatus;
  String? date;

  Datum({
    this.dateStatusId,
    this.dateStatusStatus,
    this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        dateStatusId: json["dateStatus_id"],
        dateStatusStatus: json["dateStatus_status"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "dateStatus_id": dateStatusId,
        "dateStatus_status": dateStatusStatus,
        "date": date,
      };
}
