// To parse this JSON data, do
//
//     final getdatestatus = getdatestatusFromJson(jsonString);

import 'dart:convert';

Getdatestatus getdatestatusFromJson(String str) =>
    Getdatestatus.fromJson(json.decode(str));

String getdatestatusToJson(Getdatestatus data) => json.encode(data.toJson());

class Getdatestatus {
  bool? success;
  String? message;
  List<Datum>? data;

  Getdatestatus({
    this.success,
    this.message,
    this.data,
  });

  factory Getdatestatus.fromJson(Map<String, dynamic> json) => Getdatestatus(
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
      date: json["date"]);

  Map<String, dynamic> toJson() => {
        "dateStatus_id": dateStatusId,
        "dateStatus_status": dateStatusStatus,
        "date": "${date!}",
      };
}
