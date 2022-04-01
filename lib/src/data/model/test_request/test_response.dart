// To parse this JSON data, do
//
//     final getTestRequestResponse = getTestRequestResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetTestRequestResponse getTestRequestResponseFromJson(String str) => GetTestRequestResponse.fromJson(json.decode(str));

String getTestRequestResponseToJson(GetTestRequestResponse data) => json.encode(data.toJson());

class GetTestRequestResponse {
  GetTestRequestResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  final String status;
  final String message;
  final List<Response>? response;

  factory GetTestRequestResponse.fromJson(Map<String, dynamic> json) => GetTestRequestResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    response: json["Response"] == null ? null : List<Response>.from(json["Response"].map((x) => Response.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "Response": response == null ? null : List<dynamic>.from(response!.map((x) => x.toJson())),
  };
}

class Response {
  Response({
    required this.reqMasterId,
    required this.requestStatus,
    required this.fullName,
    required this.phoneNoInp,
    required this.latitude,
    required this.longitude,
    required this.zoomLevel,
    required this.preferredDate,
    required this.preferredTimeStart,
    required this.preferredTimeEnd,
    required this.airportPassenger,
    required this.distanceInKm,
  });

  final String reqMasterId;
  final String requestStatus;
  final String fullName;
  final String phoneNoInp;
  final String latitude;
  final String longitude;
  final String zoomLevel;
  final String preferredDate;
  final String preferredTimeStart;
  final String preferredTimeEnd;
  final String airportPassenger;
  final String distanceInKm;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    reqMasterId: json["req_master_id"] == null ? null : json["req_master_id"],
    requestStatus: json["request_status"] == null ? null : json["request_status"],
    fullName: json["full_name"] == null ? null : json["full_name"],
    phoneNoInp: json["phone_no_inp"] == null ? null : json["phone_no_inp"],
    latitude: json["latitude"] == null ? null : json["latitude"],
    longitude: json["longitude"] == null ? null : json["longitude"],
    zoomLevel: json["zoom_level"] == null ? null : json["zoom_level"],
    preferredDate: json["preferred_date"] == null ? null : json["preferred_date"],
    preferredTimeStart: json["preferred_time_start"] == null ? null : json["preferred_time_start"],
    preferredTimeEnd: json["preferred_time_end"] == null ? null : json["preferred_time_end"],
    airportPassenger: json["airport_passenger"] == null ? null : json["airport_passenger"],
    distanceInKm: json["distance_in_km"] == null ? null : json["distance_in_km"],
  );

  Map<String, dynamic> toJson() => {
    "req_master_id": reqMasterId == null ? null : reqMasterId,
    "request_status": requestStatus == null ? null : requestStatus,
    "full_name": fullName == null ? null : fullName,
    "phone_no_inp": phoneNoInp == null ? null : phoneNoInp,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "zoom_level": zoomLevel == null ? null : zoomLevel,
    "preferred_date": preferredDate == null ? null : preferredDate,
    "preferred_time_start": preferredTimeStart == null ? null : preferredTimeStart,
    "preferred_time_end": preferredTimeEnd == null ? null : preferredTimeEnd,
    "airport_passenger": airportPassenger == null ? null : airportPassenger,
    "distance_in_km": distanceInKm == null ? null : distanceInKm,
  };
}
