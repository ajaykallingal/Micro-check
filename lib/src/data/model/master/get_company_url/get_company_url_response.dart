// To parse this JSON data, do
//
//     final getBaseUrlResponse = getBaseUrlResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetBaseUrlResponse getBaseUrlResponseFromJson(String str) => GetBaseUrlResponse.fromJson(json.decode(str));

String getBaseUrlResponseToJson(GetBaseUrlResponse data) => json.encode(data.toJson());

class GetBaseUrlResponse {
  GetBaseUrlResponse({
    required this.result,
    required this.data,
  });

  String result;
  List<Datum> data;

  factory GetBaseUrlResponse.fromJson(Map<String, dynamic> json) => GetBaseUrlResponse(
    result: json["result"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.clientId,
    required this.restaurantCrmUrl,
    required this.oneboxUrl,
    required this.waApikey,
    required this.createdAt,
  });

  String id;
  String clientId;
  String restaurantCrmUrl;
  String oneboxUrl;
  String waApikey;
  DateTime createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    clientId: json["client_id"],
    restaurantCrmUrl: json["restaurant_crm_url"],
    oneboxUrl: json["onebox_url"],
    waApikey: json["wa_apikey"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "client_id": clientId,
    "restaurant_crm_url": restaurantCrmUrl,
    "onebox_url": oneboxUrl,
    "wa_apikey": waApikey,
    "created_at": createdAt.toIso8601String(),
  };
}
