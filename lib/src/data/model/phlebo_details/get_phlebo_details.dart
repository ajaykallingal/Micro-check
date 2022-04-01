// To parse this JSON data, do
//
//     final getPhleboDetailsResponse = getPhleboDetailsResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetPhleboDetailsResponse getPhleboDetailsResponseFromJson(String str) => GetPhleboDetailsResponse.fromJson(json.decode(str));

String getPhleboDetailsResponseToJson(GetPhleboDetailsResponse data) => json.encode(data.toJson());

class GetPhleboDetailsResponse {
  GetPhleboDetailsResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  final String? status;
  final String? message;
  final Response? response;

  factory GetPhleboDetailsResponse.fromJson(Map<String, dynamic> json) => GetPhleboDetailsResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    response: json["Response"] == null ? null : Response.fromJson(json["Response"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "Response": response == null ? null : response!.toJson(),
  };
}

class Response {
  Response({
    required this.phlebotomistId,
    required this.phlebotomistName,
    required this.phlebotomistPhNo,
    required this.phlebotomistEmail,
    required this.phlebotomistDistrictId,
    required this.districtName,
    required this.phlebotomistDistrictCode,
    required this.phlebotomistWorkStatus,
  });

  final String phlebotomistId;
  final String phlebotomistName;
  final String phlebotomistPhNo;
  final String phlebotomistEmail;
  final String phlebotomistDistrictId;
  final String districtName;
  final String phlebotomistDistrictCode;
  final String phlebotomistWorkStatus;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    phlebotomistId: json["phlebotomist_id"] == null ? null : json["phlebotomist_id"],
    phlebotomistName: json["phlebotomist_name"] == null ? null : json["phlebotomist_name"],
    phlebotomistPhNo: json["phlebotomist_ph_no"] == null ? null : json["phlebotomist_ph_no"],
    phlebotomistEmail: json["phlebotomist_email"] == null ? null : json["phlebotomist_email"],
    phlebotomistDistrictId: json["phlebotomist_district_id"] == null ? null : json["phlebotomist_district_id"],
    districtName: json["district_name"] == null ? null : json["district_name"],
    phlebotomistDistrictCode: json["phlebotomist_district_code"] == null ? null : json["phlebotomist_district_code"],
    phlebotomistWorkStatus: json["phlebotomist_work_status"] == null ? null : json["phlebotomist_work_status"],
  );

  Map<String, dynamic> toJson() => {
    "phlebotomist_id": phlebotomistId == null ? null : phlebotomistId,
    "phlebotomist_name": phlebotomistName == null ? null : phlebotomistName,
    "phlebotomist_ph_no": phlebotomistPhNo == null ? null : phlebotomistPhNo,
    "phlebotomist_email": phlebotomistEmail == null ? null : phlebotomistEmail,
    "phlebotomist_district_id": phlebotomistDistrictId == null ? null : phlebotomistDistrictId,
    "district_name": districtName == null ? null : districtName,
    "phlebotomist_district_code": phlebotomistDistrictCode == null ? null : phlebotomistDistrictCode,
    "phlebotomist_work_status": phlebotomistWorkStatus == null ? null : phlebotomistWorkStatus,
  };
}
