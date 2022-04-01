// To parse this JSON data, do
//
//     final onlineStatusPhleboResponse = onlineStatusPhleboResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OnlineStatusPhleboResponse onlineStatusPhleboResponseFromJson(String str) => OnlineStatusPhleboResponse.fromJson(json.decode(str));

String onlineStatusPhleboResponseToJson(OnlineStatusPhleboResponse data) => json.encode(data.toJson());

class OnlineStatusPhleboResponse {
  OnlineStatusPhleboResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  final String status;
  final String message;
  final bool response;

  factory OnlineStatusPhleboResponse.fromJson(Map<String, dynamic> json) => OnlineStatusPhleboResponse(
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
