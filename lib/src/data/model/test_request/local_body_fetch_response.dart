// To parse this JSON data, do
//
//     final localBodyFetchResponse = localBodyFetchResponseFromJson(jsonString);

import 'dart:convert';

LocalBodyFetchResponse localBodyFetchResponseFromJson(String str) => LocalBodyFetchResponse.fromJson(json.decode(str));

String localBodyFetchResponseToJson(LocalBodyFetchResponse data) => json.encode(data.toJson());

class LocalBodyFetchResponse {
  LocalBodyFetchResponse({
    required this.status,
    required this.message,
    required this.localBodyList,
  });

  String status;
  String message;
  List<LocalBodyList>? localBodyList;

  factory LocalBodyFetchResponse.fromJson(Map<String, dynamic> json) => LocalBodyFetchResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    localBodyList: json["LocalBodyList"] == null ? null : List<LocalBodyList>.from(json["LocalBodyList"].map((x) => LocalBodyList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "LocalBodyList": localBodyList == null ? null : List<dynamic>.from(localBodyList!.map((x) => x.toJson())),
  };
}

class LocalBodyList {
  LocalBodyList({
    required this.localBodyName,
    required this.localBodyNo,
  });

  String localBodyName;
  String localBodyNo;

  factory LocalBodyList.fromJson(Map<String, dynamic> json) => LocalBodyList(
    localBodyName: json["local_body_name"] == null ? null : json["local_body_name"],
    localBodyNo: json["local_body_no"] == null ? null : json["local_body_no"],
  );

  Map<String, dynamic> toJson() => {
    "local_body_name": localBodyName == null ? null : localBodyName,
    "local_body_no": localBodyNo == null ? null : localBodyNo,
  };
}
