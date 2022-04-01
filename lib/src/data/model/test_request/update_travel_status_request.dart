// To parse this JSON data, do
//
//     final updateTravelStatusRequest = updateTravelStatusRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UpdateTravelStatusRequest updateTravelStatusRequestFromJson(String str) => UpdateTravelStatusRequest.fromJson(json.decode(str));

String updateTravelStatusRequestToJson(UpdateTravelStatusRequest data) => json.encode(data.toJson());

class UpdateTravelStatusRequest {
  UpdateTravelStatusRequest({
    required this.requestStatus,
    required this.reqMasterId,
    required this.districtId,
    required this.latitude,
    required this.longitude,
    required this.phlebotomistId,
  });

  final String requestStatus;
  final String reqMasterId;
  final String districtId;
  final String latitude;
  final String longitude;
  final String phlebotomistId;

  factory UpdateTravelStatusRequest.fromJson(Map<String, dynamic> json) => UpdateTravelStatusRequest(
    requestStatus: json["request_status"] == null ? null : json["request_status"],
    reqMasterId: json["req_master_id"] == null ? null : json["req_master_id"],
    districtId: json["DistrictID"] == null ? null : json["DistrictID"],
    latitude: json["Latitude"] == null ? null : json["Latitude"],
    longitude: json["Longitude"] == null ? null : json["Longitude"],
    phlebotomistId: json["PhlebotomistID"] == null ? null : json["PhlebotomistID"],
  );

  Map<String, dynamic> toJson() => {
    "request_status": requestStatus == null ? null : requestStatus,
    "req_master_id": reqMasterId == null ? null : reqMasterId,
    "DistrictID": districtId == null ? null : districtId,
    "Latitude": latitude == null ? null : latitude,
    "Longitude": longitude == null ? null : longitude,
    "PhlebotomistID": phlebotomistId == null ? null : phlebotomistId,
  };
}
