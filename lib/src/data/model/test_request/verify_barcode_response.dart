// To parse this JSON data, do
//
//     final verifyBarcodeResponse = verifyBarcodeResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

VerifyBarcodeResponse verifyBarcodeResponseFromJson(String str) => VerifyBarcodeResponse.fromJson(json.decode(str));

String verifyBarcodeResponseToJson(VerifyBarcodeResponse data) => json.encode(data.toJson());

class VerifyBarcodeResponse {
  VerifyBarcodeResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  final String status;
  final String message;
  final bool response;

  factory VerifyBarcodeResponse.fromJson(Map<String, dynamic> json) => VerifyBarcodeResponse(
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
