import 'dart:convert';

GetDateStatusId getDateStatusIdFromJson(String str) =>
    GetDateStatusId.fromJson(json.decode(str));

String getDateStatusIdToJson(GetDateStatusId data) =>
    json.encode(data.toJson());

class GetDateStatusId {
  bool? success;
  String? message;
  List<Datum>? data;

  GetDateStatusId({
    this.success,
    this.message,
    this.data,
  });

  factory GetDateStatusId.fromJson(Map<String, dynamic> json) =>
      GetDateStatusId(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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
  DateTime? date;

  Datum({
    this.dateStatusId,
    this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        dateStatusId: json["dateStatus_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "dateStatus_id": dateStatusId,
        "date": date != null
            ? "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}"
            : null,
      };
}
