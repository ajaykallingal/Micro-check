// To parse this JSON data, do
//
//     final getOtpRequest = getOtpRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetOtpRequest getOtpRequestFromJson(String str) => GetOtpRequest.fromJson(json.decode(str));

String getOtpRequestToJson(GetOtpRequest data) => json.encode(data.toJson());

class GetOtpRequest {
  GetOtpRequest({
    required this.phlebotomistContact,
  });

  final String phlebotomistContact;

  factory GetOtpRequest.fromJson(Map<String, dynamic> json) => GetOtpRequest(
    phlebotomistContact: json["PhlebotomistContact"] == null ? null : json["PhlebotomistContact"],
  );

  Map<String, dynamic> toJson() => {
    "PhlebotomistContact": phlebotomistContact == null ? null : phlebotomistContact,
  };
}
