// To parse this JSON data, do
//
//     final addNewTestRequest = addNewTestRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AddNewTestRequest addNewTestRequestFromJson(String str) => AddNewTestRequest.fromJson(json.decode(str));

String addNewTestRequestToJson(AddNewTestRequest data) => json.encode(data.toJson());

class AddNewTestRequest {
  AddNewTestRequest({
    required this.fullName,
    required this.contactNo,
    required this.address,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.zoomLevel,
    required this.airportPassenger,
    required this.flightNo,
    required this.travelDate,
    required this.travelTime,
    required this.travelDestination,
    required this.districtId,
    required this.dataFrom,
    required this.phoneNoInp,
    required this.phlebotomistId,
    required this.isRtpcr,
    required this.remarks,


  });

  final String fullName;
  final String contactNo;
  final String address;
  final String pincode;
  final String latitude;
  final String longitude;
  final String zoomLevel;

  final String airportPassenger;
  final String flightNo;
  final String travelDate;
  final String travelTime;
  final String travelDestination;
  final String districtId;
  final String dataFrom;
  final String phoneNoInp;
  final String phlebotomistId;
  final String isRtpcr;
  final String remarks;



  factory AddNewTestRequest.fromJson(Map<String, dynamic> json) => AddNewTestRequest(
    fullName: json["full_name"] == null ? null : json["full_name"],
    contactNo: json["contact_no"] == null ? null : json["contact_no"],
    address: json["address"] == null ? null : json["address"],
    pincode: json["pincode"] == null ? null : json["pincode"],
    latitude: json["latitude"] == null ? null : json["latitude"],
    longitude: json["longitude"] == null ? null : json["longitude"],
    zoomLevel: json["zoom_level"] == null ? null : json["zoom_level"],
    airportPassenger: json["airport_passenger"] == null ? null : json["airport_passenger"],
    flightNo: json["flight_no"] == null ? null : json["flight_no"],
    travelDate: json["travel_date"] == null ? null : json["travel_date"],
    travelTime: json["travel_time"] == null ? null : json["travel_time"],
    travelDestination: json["travel_destination"] == null ? null : json["travel_destination"],
    districtId: json["district_id"] == null ? null : json["district_id"],
    dataFrom: json["data_from"] == null ? null : json["data_from"],
    phoneNoInp: json["phone_no_inp"] == null ? null : json["phone_no_inp"],
    phlebotomistId: json["PhlebotomistID"] == null ? null : json["PhlebotomistID"],
    isRtpcr: json["is_rtpcr"] == null ? "" : json["is_rtpcr"],
    remarks: json["remarks"] == null ? "" : json["remarks"],


  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName == null ? null : fullName,
    "contact_no": contactNo == null ? null : contactNo,
    "address": address == null ? null : address,
    "pincode": pincode == null ? null : pincode,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "zoom_level": zoomLevel == null ? null : zoomLevel,
    "airport_passenger": airportPassenger == null ? null : airportPassenger,
    "flight_no": flightNo == null ? null : flightNo,
    "travel_date": travelDate == null ? null : travelDate,
    "travel_time": travelTime == null ? null : travelTime,
    "travel_destination": travelDestination == null ? null : travelDestination,
    "district_id": districtId == null ? null : districtId,
    "data_from": dataFrom == null ? null : dataFrom,
    "phone_no_inp": phoneNoInp == null ? null : phoneNoInp,
    "PhlebotomistID": phlebotomistId == null ? null : phlebotomistId,
    "is_rtpcr": isRtpcr == null ? "" : isRtpcr,
    "remarks": remarks == null ? "" : remarks

  };
}
