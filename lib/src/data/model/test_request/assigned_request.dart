// To parse this JSON data, do
//
//     final getAssignedRequest = getAssignedRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetAssignedRequest getAssignedRequestFromJson(String str) => GetAssignedRequest.fromJson(json.decode(str));

String getAssignedRequestToJson(GetAssignedRequest data) => json.encode(data.toJson());

class GetAssignedRequest {
  GetAssignedRequest({
    required this.phlebotomistId,
    required this.districtID,
    required this.latitude,
    required this.longitude,
    required this.pageNo,
  });

  final String phlebotomistId;
  final String districtID;
  final String latitude;
  final String longitude;
  final String pageNo;

  factory GetAssignedRequest.fromJson(Map<String, dynamic> json) => GetAssignedRequest(
    phlebotomistId: json["PhlebotomistID"] == null ? null : json["PhlebotomistID"],
    districtID: json["DistrictID"] == null ? null : json["DistrictID"],
    latitude: json["Latitude"] == null ? null : json["Latitude"],
    longitude: json["Longitude"] == null ? null : json["Longitude"],
    pageNo: json["PageNO"] == null ? null : json["PageNO"],
  );

  Map<String, dynamic> toJson() => {
    "PhlebotomistID": phlebotomistId == null ? null : phlebotomistId,
    "DistrictID": districtID == null ? null : districtID,
    "Latitude": latitude == null ? null : latitude,
    "Longitude": longitude == null ? null : longitude,
    "PageNO": pageNo == null ? null : pageNo,
  };
}
