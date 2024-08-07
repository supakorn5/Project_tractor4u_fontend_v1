import 'dart:convert';

GetOwnerId getOwnerIdFromJson(String str) =>
    GetOwnerId.fromJson(json.decode(str));

String getOwnerIdToJson(GetOwnerId data) => json.encode(data.toJson());

class GetOwnerId {
  bool? success;
  String? message;
  List<Datum>? data;

  GetOwnerId({
    this.success,
    this.message,
    this.data,
  });

  factory GetOwnerId.fromJson(Map<String, dynamic> json) => GetOwnerId(
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
  int? ownersId;

  Datum({
    this.ownersId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        ownersId: json["owners_id"],
      );

  Map<String, dynamic> toJson() => {
        "owners_id": ownersId,
      };
}
