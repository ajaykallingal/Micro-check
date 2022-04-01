// To parse this JSON data, do
//
//     final updateTravelStatusResponse = updateTravelStatusResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:micro_check/src/data/model/test_request/get_single_request_details_response.dart';

UpdateTravelStatusResponse updateTravelStatusResponseFromJson(String str) => UpdateTravelStatusResponse.fromJson(json.decode(str));

String updateTravelStatusResponseToJson(UpdateTravelStatusResponse data) => json.encode(data.toJson());

class UpdateTravelStatusResponse {
  UpdateTravelStatusResponse({
    required this.status,
    required this.message,
    required this.updateResponse,
    required this.uidList,
    required this.requestDetails
  });

  final String status;
  final String message;
  final bool updateResponse;
  final List<UidList>? uidList;
  final Response? requestDetails;

  factory UpdateTravelStatusResponse.fromJson(Map<String, dynamic> json) => UpdateTravelStatusResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    updateResponse: json["UpdateResponse"] == null ? null : json["UpdateResponse"],
    uidList: json["UID_List"] == null ? null : List<UidList>.from(json["UID_List"].map((x) => UidList.fromJson(x))),
    requestDetails: json["RequestDetails"] == null ? null : Response.fromJson(json["RequestDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "UpdateResponse": updateResponse == null ? null : updateResponse,
    "UID_List": uidList == null ? null : List<dynamic>.from(uidList!.map((x) => x.toJson())),
    "RequestDetails": requestDetails == null ? null : requestDetails!.toJson(),
  };
}

class UidList {
  UidList({
    required this.uidId,
    required this.uidName,
  });

  final String uidId;
  final String uidName;

  factory UidList.fromJson(Map<String, dynamic> json) => UidList(
    uidId: json["uid_id"] == null ? null : json["uid_id"],
    uidName: json["uid_name"] == null ? null : json["uid_name"],
  );

  Map<String, dynamic> toJson() => {
    "uid_id": uidId == null ? null : uidId,
    "uid_name": uidName == null ? null : uidName,
  };
}
