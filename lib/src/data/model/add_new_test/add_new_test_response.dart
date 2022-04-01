// To parse this JSON data, do
//
//     final addNewTestResponse = addNewTestResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AddNewTestResponse addNewTestResponseFromJson(String str) => AddNewTestResponse.fromJson(json.decode(str));

String addNewTestResponseToJson(AddNewTestResponse data) => json.encode(data.toJson());

class AddNewTestResponse {
  AddNewTestResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  final String status;
  final String message;
  final Response? response;

  factory AddNewTestResponse.fromJson(Map<String, dynamic> json) => AddNewTestResponse(
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
    required this.insertResponse,
    required this.lastInsertedId,
    required this.token,
    required this.paymentLink,
  });

  final bool insertResponse;
  final int lastInsertedId;
  final String token;
  final String paymentLink;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    insertResponse: json["InsertResponse"] == null ? null : json["InsertResponse"],
    lastInsertedId: json["LastInsertedID"] == null ? null : json["LastInsertedID"],
    token: json["Token"] == null ? null : json["Token"],
    paymentLink: json["PaymentLink"] == null ? null : json["PaymentLink"],
  );

  Map<String, dynamic> toJson() => {
    "InsertResponse": insertResponse == null ? null : insertResponse,
    "LastInsertedID": lastInsertedId == null ? null : lastInsertedId,
    "Token": token == null ? null : token,
    "PaymentLink": paymentLink == null ? null : paymentLink,
  };
}
