// To parse this JSON data, do
//
//     final pendingTestRequest = pendingTestRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PendingTestRequest pendingTestRequestFromJson(String str) => PendingTestRequest.fromJson(json.decode(str));

String pendingTestRequestToJson(PendingTestRequest data) => json.encode(data.toJson());

class PendingTestRequest {
  PendingTestRequest({
    required this.districtId,
    required this.latitude,
    required this.longitude,
    required this.pageNo,
  });

  final String districtId;
  final String latitude;
  final String longitude;
  final String pageNo;

  factory PendingTestRequest.fromJson(Map<String, dynamic> json) => PendingTestRequest(
    districtId: json["DistrictID"] == null ? null : json["DistrictID"],
    latitude: json["Latitude"] == null ? null : json["Latitude"],
    longitude: json["Longitude"] == null ? null : json["Longitude"],
    pageNo: json["PageNO"] == null ? null : json["PageNO"],
  );

  Map<String, dynamic> toJson() => {
    "DistrictID": districtId == null ? null : districtId,
    "Latitude": latitude == null ? null : latitude,
    "Longitude": longitude == null ? null : longitude,
    "PageNO": pageNo == null ? null : pageNo,
  };
}
