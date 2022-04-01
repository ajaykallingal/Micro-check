// To parse this JSON data, do
//
//     final getSingleRequestDetailsRequest = getSingleRequestDetailsRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetSingleRequestDetailsRequest getSingleRequestDetailsRequestFromJson(String str) => GetSingleRequestDetailsRequest.fromJson(json.decode(str));

String getSingleRequestDetailsRequestToJson(GetSingleRequestDetailsRequest data) => json.encode(data.toJson());

class GetSingleRequestDetailsRequest {
  GetSingleRequestDetailsRequest({
    required this.districtId,
    required this.requestId,
    required this.latitude,
    required this.longitude,
    required this.phlebotomistId,
  });

  final String districtId;
  final String requestId;
  final String latitude;
  final String longitude;
  final String phlebotomistId;


  factory GetSingleRequestDetailsRequest.fromJson(Map<String, dynamic> json) => GetSingleRequestDetailsRequest(
    districtId: json["DistrictID"] == null ? null : json["DistrictID"],
    requestId: json["RequestID"] == null ? null : json["RequestID"],
    latitude: json["Latitude"] == null ? null : json["Latitude"],
    longitude: json["Longitude"] == null ? null : json["Longitude"],
    phlebotomistId: json["PhlebotomistID"] == null ? null : json["PhlebotomistID"],

  );

  Map<String, dynamic> toJson() => {
    "DistrictID": districtId == null ? null : districtId,
    "RequestID": requestId == null ? null : requestId,
    "Latitude": latitude == null ? null : latitude,
    "Longitude": longitude == null ? null : longitude,
    "PhlebotomistID": phlebotomistId == null ? null : phlebotomistId,
  };
}
