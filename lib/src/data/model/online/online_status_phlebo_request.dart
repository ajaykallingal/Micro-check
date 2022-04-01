// To parse this JSON data, do
//
//     final onlineStatusPhleboRequest = onlineStatusPhleboRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OnlineStatusPhleboRequest onlineStatusPhleboRequestFromJson(String str) => OnlineStatusPhleboRequest.fromJson(json.decode(str));

String onlineStatusPhleboRequestToJson(OnlineStatusPhleboRequest data) => json.encode(data.toJson());

class OnlineStatusPhleboRequest {
  OnlineStatusPhleboRequest({
    required this.phleboId,
    required this.phlebotomistWorkStatus,
  });

  final String phleboId;
  final bool phlebotomistWorkStatus;

  factory OnlineStatusPhleboRequest.fromJson(Map<String, dynamic> json) => OnlineStatusPhleboRequest(
    phleboId: json["phlebo_id"] == null ? null : json["phlebo_id"],
    phlebotomistWorkStatus: json["phlebotomist_work_status"] == null ? null : json["phlebotomist_work_status"],
  );

  Map<String, dynamic> toJson() => {
    "phlebo_id": phleboId == null ? null : phleboId,
    "phlebotomist_work_status": phlebotomistWorkStatus == null ? null : phlebotomistWorkStatus,
  };
}
