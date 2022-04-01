// To parse this JSON data, do
//
//     final updateLiveLocationResponse = updateLiveLocationResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UpdateLiveLocationResponse updateLiveLocationResponseFromJson(String str) => UpdateLiveLocationResponse.fromJson(json.decode(str));

String updateLiveLocationResponseToJson(UpdateLiveLocationResponse data) => json.encode(data.toJson());

class UpdateLiveLocationResponse {
  UpdateLiveLocationResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  final String status;
  final String message;
  final bool response;

  factory UpdateLiveLocationResponse.fromJson(Map<String, dynamic> json) => UpdateLiveLocationResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    response: json["Response"] == null ? null : json["Response"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "Response": response == null ? null : response,
  };
}
