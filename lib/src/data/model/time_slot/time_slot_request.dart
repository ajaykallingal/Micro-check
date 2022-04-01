// To parse this JSON data, do
//
//     final timeSlotRequest = timeSlotRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TimeSlotRequest timeSlotRequestFromJson(String str) => TimeSlotRequest.fromJson(json.decode(str));

String timeSlotRequestToJson(TimeSlotRequest data) => json.encode(data.toJson());

class TimeSlotRequest {
  TimeSlotRequest({
    required this.districtId,
    required this.date,
  });

  final String districtId;
  final String date;

  factory TimeSlotRequest.fromJson(Map<String, dynamic> json) => TimeSlotRequest(
    districtId: json["DistrictID"] == null ? null : json["DistrictID"],
    date: json["Date"] == null ? null : json["Date"],
  );

  Map<String, dynamic> toJson() => {
    "DistrictID": districtId == null ? null : districtId,
    "Date": date == null ? null : date,
  };
}
