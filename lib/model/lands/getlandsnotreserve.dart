// To parse this JSON data, do
//
//     final getLandNotReserve = getLandNotReserveFromJson(jsonString);

import 'dart:convert';

GetLandNotReserve getLandNotReserveFromJson(String str) =>
    GetLandNotReserve.fromJson(json.decode(str));

String getLandNotReserveToJson(GetLandNotReserve data) =>
    json.encode(data.toJson());

class GetLandNotReserve {
  bool? success;
  String? message;
  List<Datum>? data;

  GetLandNotReserve({
    this.success,
    this.message,
    this.data,
  });

  factory GetLandNotReserve.fromJson(Map<String, dynamic> json) =>
      GetLandNotReserve(
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

  Datum({
    this.landsId,
    this.landsInfo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        landsId: json["lands_id"],
        landsInfo: json["lands_info"],
      );

  Map<String, dynamic> toJson() => {
        "lands_id": landsId,
        "lands_info": landsInfo,
      };
}
