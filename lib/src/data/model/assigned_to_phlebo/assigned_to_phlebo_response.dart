// To parse this JSON data, do
//
//     final assignedToPhleboResponse = assignedToPhleboResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:micro_check/src/data/model/test_request/test_response.dart';

AssignedToPhleboResponse assignedToPhleboResponseFromJson(String str) => AssignedToPhleboResponse.fromJson(json.decode(str));

String assignedToPhleboResponseToJson(AssignedToPhleboResponse data) => json.encode(data.toJson());

class AssignedToPhleboResponse {
  AssignedToPhleboResponse({
    required this.status,
    required this.message,
    required this.response,
    required this.lastInsertedRowId,
    required this.pendingRequestList,
  });

  final String status;
  final String message;
  final bool response;
  final int lastInsertedRowId;
  final List<Response>? pendingRequestList;

  factory AssignedToPhleboResponse.fromJson(Map<String, dynamic> json) => AssignedToPhleboResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    response: json["Response"] == null ? null : json["Response"],
    lastInsertedRowId: json["LastInsertedRowID"] == null ? null : json["LastInsertedRowID"],
    pendingRequestList: json["PendingRequestList"] == null ? null : List<Response>.from(json["PendingRequestList"].map((x) => Response.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "Response": response == null ? null : response,
    "LastInsertedRowID": lastInsertedRowId == null ? null : lastInsertedRowId,
    "PendingRequestList": pendingRequestList == null ? null : pendingRequestList,
  };
}
