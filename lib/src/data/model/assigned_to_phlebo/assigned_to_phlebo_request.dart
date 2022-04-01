// To parse this JSON data, do
//
//     final assignedToPhleboRequest = assignedToPhleboRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AssignedToPhleboRequest assignedToPhleboRequestFromJson(String str) => AssignedToPhleboRequest.fromJson(json.decode(str));

String assignedToPhleboRequestToJson(AssignedToPhleboRequest data) => json.encode(data.toJson());

class AssignedToPhleboRequest {
  AssignedToPhleboRequest({
    required this.reqMasterId,
    required this.phlebotomistId,
    required this.districtId,
    required this.latitude,
    required this.longitude,
    required this.pageNo,
  });

  final String reqMasterId;
  final String phlebotomistId;
  final String districtId;
  final String latitude;
  final String longitude;
  final String pageNo;

  factory AssignedToPhleboRequest.fromJson(Map<String, dynamic> json) => AssignedToPhleboRequest(
    reqMasterId: json["req_master_id"] == null ? null : json["req_master_id"],
    phlebotomistId: json["PhlebotomistID"] == null ? null : json["PhlebotomistID"],
    districtId: json["DistrictID"] == null ? null : json["DistrictID"],
    latitude: json["Latitude"] == null ? null : json["Latitude"],
    longitude: json["Longitude"] == null ? null : json["Longitude"],
    pageNo: json["PageNO"] == null ? null : json["PageNO"],
  );

  Map<String, dynamic> toJson() => {
    "req_master_id": reqMasterId == null ? null : reqMasterId,
    "PhlebotomistID": phlebotomistId == null ? null : phlebotomistId,
    "DistrictID": districtId == null ? null : districtId,
    "Latitude": latitude == null ? null : latitude,
    "Longitude": longitude == null ? null : longitude,
    "PageNO": pageNo == null ? null : pageNo,
  };
}
