// To parse this JSON data, do
//
//     final paymentResponse = paymentResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PaymentMethodResponse paymentResponseFromJson(String str) => PaymentMethodResponse.fromJson(json.decode(str));

String paymentResponseToJson(PaymentMethodResponse data) => json.encode(data.toJson());

class PaymentMethodResponse {
  PaymentMethodResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  final String status;
  final String message;
  final Response? response;

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) => PaymentMethodResponse(
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
    required this.updateResponse,
    required this.lastInsertedId,
  });

  final bool updateResponse;
  final int lastInsertedId;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    updateResponse: json["UpdateResponse"] == null ? null : json["UpdateResponse"],
    lastInsertedId: json["LastInsertedID"] == null ? null : json["LastInsertedID"],
  );

  Map<String, dynamic> toJson() => {
    "UpdateResponse": updateResponse == null ? null : updateResponse,
    "LastInsertedID": lastInsertedId == null ? null : lastInsertedId,
  };
}
