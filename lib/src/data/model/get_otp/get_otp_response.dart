// To parse this JSON data, do
//
//     final getOtpResponse = getOtpResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetOtpResponse getOtpResponseFromJson(String str) => GetOtpResponse.fromJson(json.decode(str));

String getOtpResponseToJson(GetOtpResponse data) => json.encode(data.toJson());

class GetOtpResponse {
  GetOtpResponse({
    required this.status,
    required this.message,
    required this.validUser,
    required this.otp,
  });

  final String status;
  final String message;
  final bool validUser;
  final String otp;

  factory GetOtpResponse.fromJson(Map<String, dynamic> json) => GetOtpResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    validUser: json["validUser"] == null ? null : json["validUser"],
    otp: json["otp"] == null ? null : json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "validUser": validUser == null ? null : validUser,
    "otp": otp == null ? null : otp,
  };
}
