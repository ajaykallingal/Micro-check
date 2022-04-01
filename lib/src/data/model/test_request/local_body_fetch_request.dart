// To parse this JSON data, do
//
//     final localBodyFetchRequest = localBodyFetchRequestFromJson(jsonString);

import 'dart:convert';

LocalBodyFetchRequest localBodyFetchRequestFromJson(String str) => LocalBodyFetchRequest.fromJson(json.decode(str));

String localBodyFetchRequestToJson(LocalBodyFetchRequest data) => json.encode(data.toJson());

class LocalBodyFetchRequest {
  LocalBodyFetchRequest({
    required this.localBodyType,
    required this.localBodyDistrictId,
  });

  String localBodyType;
  String localBodyDistrictId;

  factory LocalBodyFetchRequest.fromJson(Map<String, dynamic> json) => LocalBodyFetchRequest(
    localBodyType: json["localBodyType"] == null ? null : json["localBodyType"],
    localBodyDistrictId: json["localBodyDistrictId"] == null ? null : json["localBodyDistrictID"],
  );

  Map<String, dynamic> toJson() => {
    "localBodyType": localBodyType == null ? null : localBodyType,
    "localBodyDistrictID": localBodyDistrictId == null ? null : localBodyDistrictId,
  };
}
