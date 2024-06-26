// To parse this JSON data, do
//
//     final getlandsbyuserid = getlandsbyuseridFromJson(jsonString);

import 'dart:convert';

Getlandsbyuserid getlandsbyuseridFromJson(String str) => Getlandsbyuserid.fromJson(json.decode(str));

String getlandsbyuseridToJson(Getlandsbyuserid data) => json.encode(data.toJson());

class Getlandsbyuserid {
    bool? success;
    String? message;
    List<Datum>? data;

    Getlandsbyuserid({
        this.success,
        this.message,
        this.data,
    });

    factory Getlandsbyuserid.fromJson(Map<String, dynamic> json) => Getlandsbyuserid(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? landsId;
    String? landsInfo;
    double? landsLat;
    double? landsLon;
    int? landsSizeRai;
    int? landsSizeNgan;
    int? landsUsersId;

    Datum({
        this.landsId,
        this.landsInfo,
        this.landsLat,
        this.landsLon,
        this.landsSizeRai,
        this.landsSizeNgan,
        this.landsUsersId,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        landsId: json["lands_id"],
        landsInfo: json["lands_info"],
        landsLat: json["lands_lat"]?.toDouble(),
        landsLon: json["lands_lon"]?.toDouble(),
        landsSizeRai: json["lands_size_rai"],
        landsSizeNgan: json["lands_size_ngan"],
        landsUsersId: json["lands_users_id"],
    );

    Map<String, dynamic> toJson() => {
        "lands_id": landsId,
        "lands_info": landsInfo,
        "lands_lat": landsLat,
        "lands_lon": landsLon,
        "lands_size_rai": landsSizeRai,
        "lands_size_ngan": landsSizeNgan,
        "lands_users_id": landsUsersId,
    };
}
