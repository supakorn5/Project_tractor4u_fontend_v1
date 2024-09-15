// To parse this JSON data, do
//
//     final provinceinTh = provinceinThFromJson(jsonString);

import 'dart:convert';

List<ProvinceinTh> provinceinThFromJson(String str) => List<ProvinceinTh>.from(
    json.decode(str).map((x) => ProvinceinTh.fromJson(x)));

String provinceinThToJson(List<ProvinceinTh> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProvinceinTh {
  int id;
  String nameTh;
  String nameEn;
  int? geographyId;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  List<ProvinceinTh>? amphure;
  int? provinceId;
  List<ProvinceinTh>? tambon;
  int? zipCode;
  int? amphureId;

  ProvinceinTh({
    required this.id,
    required this.nameTh,
    required this.nameEn,
    this.geographyId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    this.amphure,
    this.provinceId,
    this.tambon,
    this.zipCode,
    this.amphureId,
  });

  factory ProvinceinTh.fromJson(Map<String, dynamic> json) => ProvinceinTh(
        id: json["id"],
        nameTh: json["name_th"],
        nameEn: json["name_en"],
        geographyId: json["geography_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        amphure: json["amphure"] == null
            ? []
            : List<ProvinceinTh>.from(
                json["amphure"]!.map((x) => ProvinceinTh.fromJson(x))),
        provinceId: json["province_id"],
        tambon: json["tambon"] == null
            ? []
            : List<ProvinceinTh>.from(
                json["tambon"]!.map((x) => ProvinceinTh.fromJson(x))),
        zipCode: json["zip_code"],
        amphureId: json["amphure_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_th": nameTh,
        "name_en": nameEn,
        "geography_id": geographyId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "amphure": amphure == null
            ? []
            : List<dynamic>.from(amphure!.map((x) => x.toJson())),
        "province_id": provinceId,
        "tambon": tambon == null
            ? []
            : List<dynamic>.from(tambon!.map((x) => x.toJson())),
        "zip_code": zipCode,
        "amphure_id": amphureId,
      };
}
