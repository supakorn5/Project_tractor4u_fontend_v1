// To parse this JSON data, do
//
//     final getQueueById = getQueueByIdFromJson(jsonString);

import 'dart:convert';

GetQueueById getQueueByIdFromJson(String str) =>
    GetQueueById.fromJson(json.decode(str));

String getQueueByIdToJson(GetQueueById data) => json.encode(data.toJson());

class GetQueueById {
  bool? success;
  String? message;
  List<Datum>? data;

  GetQueueById({
    this.success,
    this.message,
    this.data,
  });

  factory GetQueueById.fromJson(Map<String, dynamic> json) => GetQueueById(
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
  String? date;

  Datum({
    this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "date": "${date!}",
      };
}
