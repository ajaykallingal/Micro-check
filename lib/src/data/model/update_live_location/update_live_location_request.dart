// To parse this JSON data, do
//
//     final updateLiveLocationRequest = updateLiveLocationRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UpdateLiveLocationRequest updateLiveLocationRequestFromJson(String str) => UpdateLiveLocationRequest.fromJson(json.decode(str));

String updateLiveLocationRequestToJson(UpdateLiveLocationRequest data) => json.encode(data.toJson());

class UpdateLiveLocationRequest {
  UpdateLiveLocationRequest({
    required this.phleboId,
    required this.phleboLatitude,
    required this.phleboLongitude,
  });

  final String phleboId;
  final String phleboLatitude;
  final String phleboLongitude;

  factory UpdateLiveLocationRequest.fromJson(Map<String, dynamic> json) => UpdateLiveLocationRequest(
    phleboId: json["phlebo_id"] == null ? null : json["phlebo_id"],
    phleboLatitude: json["phlebo_latitude"] == null ? null : json["phlebo_latitude"],
    phleboLongitude: json["phlebo_longitude"] == null ? null : json["phlebo_longitude"],
  );

  Map<String, dynamic> toJson() => {
    "phlebo_id": phleboId == null ? null : phleboId,
    "phlebo_latitude": phleboLatitude == null ? null : phleboLatitude,
    "phlebo_longitude": phleboLongitude == null ? null : phleboLongitude,
  };
}
