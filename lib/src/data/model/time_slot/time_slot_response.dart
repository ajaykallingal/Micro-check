// To parse this JSON data, do
//
//     final timeSlotResponse = timeSlotResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TimeSlotResponse timeSlotResponseFromJson(String str) => TimeSlotResponse.fromJson(json.decode(str));

String timeSlotResponseToJson(TimeSlotResponse data) => json.encode(data.toJson());

class TimeSlotResponse {
  TimeSlotResponse({
    required this.status,
    required this.message,
    required this.slots,
  });

  final String status;
  final String message;
  final List<Slot>? slots;

  factory TimeSlotResponse.fromJson(Map<String, dynamic> json) => TimeSlotResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    slots: json["Slots"] == null ? null : List<Slot>.from(json["Slots"].map((x) => Slot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "Slots": slots == null ? null : List<dynamic>.from(slots!.map((x) => x.toJson())),
  };
}

class Slot {
  Slot({
    required this.fromTime,
    required this.toTime,
  });

  final String fromTime;
  final String toTime;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    fromTime: json["FromTime"] == null ? null : json["FromTime"],
    toTime: json["ToTime"] == null ? null : json["ToTime"],
  );

  Map<String, dynamic> toJson() => {
    "FromTime": fromTime == null ? null : fromTime,
    "ToTime": toTime == null ? null : toTime,
  };
}
