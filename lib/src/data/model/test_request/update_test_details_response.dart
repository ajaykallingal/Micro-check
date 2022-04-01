// To parse this JSON data, do
//
//     final updateTestDetailsResponse = updateTestDetailsResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UpdateTestDetailsResponse updateTestDetailsResponseFromJson(String str) => UpdateTestDetailsResponse.fromJson(json.decode(str));

String updateTestDetailsResponseToJson(UpdateTestDetailsResponse data) => json.encode(data.toJson());

class UpdateTestDetailsResponse {
  UpdateTestDetailsResponse({
    required this.status,
    required this.message,
    required this.response,
    required this.paymentLink,
  });

  final String status;
  final String message;
  final bool response;
  final String paymentLink;

  factory UpdateTestDetailsResponse.fromJson(Map<String, dynamic> json) => UpdateTestDetailsResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    response: json["Response"] == null ? null : json["Response"],
    paymentLink: json["PaymentLink"] == null ? null : json["PaymentLink"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "Response": response == null ? null : response,
    "PaymentLink": paymentLink == null ? null : paymentLink,
  };
}
