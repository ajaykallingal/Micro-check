// To parse this JSON data, do
//
//     final getSingleRequestDetailsResponse = getSingleRequestDetailsResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:micro_check/src/data/model/test_request/update_travel_status_response.dart';

GetSingleRequestDetailsResponse getSingleRequestDetailsResponseFromJson(String str) => GetSingleRequestDetailsResponse.fromJson(json.decode(str));

String getSingleRequestDetailsResponseToJson(GetSingleRequestDetailsResponse data) => json.encode(data.toJson());

class GetSingleRequestDetailsResponse {
  GetSingleRequestDetailsResponse({
    required this.status,
    required this.message,
    required this.response,
    required this.paymentDetails,
    required this.uidList,
    required this.skipInputDetails

  });

  final String status;
  final String message;
  final Response? response;
  final PaymentDetails? paymentDetails;
  final List<UidList>? uidList;
  final bool skipInputDetails;

  factory GetSingleRequestDetailsResponse.fromJson(Map<String, dynamic> json) => GetSingleRequestDetailsResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    skipInputDetails: json["SkipInputDetails"] == null ? null : json["SkipInputDetails"],
    response: json["Response"] == null ? null : Response.fromJson(json["Response"]),
    paymentDetails: json["PaymentDetails"] == null ? null : PaymentDetails.fromJson(json["PaymentDetails"]),
    uidList: json["UID_List"] == null ? null : List<UidList>.from(json["UID_List"].map((x) => UidList.fromJson(x))),


  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "SkipInputDetails": skipInputDetails == null ? null : skipInputDetails,
    "Response": response == null ? null : response!.toJson(),
    "PaymentDetails": paymentDetails == null ? null : paymentDetails!.toJson(),
    "UID_List": uidList == null ? null : List<dynamic>.from(uidList!.map((x) => x.toJson())),

  };
}
class PaymentDetails {
  PaymentDetails({
    required this.districtUpiQrCode,
    required this.districtRtpcrPrice,
  });

  final String districtUpiQrCode;
  final String districtRtpcrPrice;

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
    districtUpiQrCode: json["district_upi_qr_code"] == null ? null : json["district_upi_qr_code"],
    districtRtpcrPrice: json["district_rtpcr_price"] == null ? null : json["district_rtpcr_price"],
  );

  Map<String, dynamic> toJson() => {
    "district_upi_qr_code": districtUpiQrCode == null ? null : districtUpiQrCode,
    "district_rtpcr_price": districtRtpcrPrice == null ? null : districtRtpcrPrice,
  };
}
class Response {
  Response({
    required this.reqMasterId,
    required this.requestStatus,
    required this.fullName,
    required this.phoneNoInp,
    required this.contactNo,
    required this.address,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.zoomLevel,
    required this.preferredDate,
    required this.preferredTimeStart,
    required this.preferredTimeEnd,
    required this.airportPassenger,
    required this.flightNo,
    required this.travelDate,
    required this.travelTime,
    required this.travelDestination,
    required this.assignedStatus,
    required this.dataFrom,
    required this.payStatus,
    required this.requestedOn,
    required this.distanceInKm,
    required this.showButton,
    required this.isRtpcr,
    required this.remarks,
  });

  final String reqMasterId;
  final String requestStatus;
  final String fullName;
  final String phoneNoInp;
  final String contactNo;
  final String address;
  final String pincode;
  final String latitude;
  final String longitude;
  final String zoomLevel;
  final String preferredDate;
  final String preferredTimeStart;
  final String preferredTimeEnd;
  final String airportPassenger;
  final String flightNo;
  final String travelDate;
  final String travelTime;
  final String travelDestination;
  final String assignedStatus;
  final String dataFrom;
  final String payStatus;
  final String requestedOn;
  final String distanceInKm;
  final bool showButton;
  final String isRtpcr;
  final String remarks;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    reqMasterId: json["req_master_id"] == null ? null : json["req_master_id"],
    requestStatus: json["request_status"] == null ? null : json["request_status"],
    fullName: json["full_name"] == null ? null : json["full_name"],
    phoneNoInp: json["phone_no_inp"] == null ? null : json["phone_no_inp"],
    contactNo: json["contact_no"] == null ? null : json["contact_no"],
    address: json["address"] == null ? null : json["address"],
    pincode: json["pincode"] == null ? null : json["pincode"],
    latitude: json["latitude"] == null ? null : json["latitude"],
    longitude: json["longitude"] == null ? null : json["longitude"],
    zoomLevel: json["zoom_level"] == null ? null : json["zoom_level"],
    preferredDate: json["preferred_date"] == null ? null : json["preferred_date"],
    preferredTimeStart: json["preferred_time_start"] == null ? null : json["preferred_time_start"],
    preferredTimeEnd: json["preferred_time_end"] == null ? null : json["preferred_time_end"],
    airportPassenger: json["airport_passenger"] == null ? null : json["airport_passenger"],
    flightNo: json["flight_no"] == null ? " " : json["flight_no"],
    travelDate: json["travel_date"] == null ? " " : json["travel_date"],
    travelTime: json["travel_time"] == null ? " " : json["travel_time"],
    travelDestination: json["travel_destination"] == " " ? null : json["travel_destination"],
    assignedStatus: json["assigned_status"] == null ? null : json["assigned_status"],
    dataFrom: json["data_from"] == null ? null : json["data_from"],
    payStatus: json["pay_status"] == null ? null : json["pay_status"],
    requestedOn: json["requested_on"] == null ? null : json["requested_on"],
    distanceInKm: json["distance_in_km"] == null ? null : json["distance_in_km"],
    showButton: json["ShowButton"] == null ? null : json["ShowButton"],
    isRtpcr: json["is_rtpcr"] == null ? null : json["is_rtpcr"],
    remarks: json["remarks"] == null ? "" : json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "req_master_id": reqMasterId == null ? null : reqMasterId,
    "request_status": requestStatus == null ? null : requestStatus,
    "full_name": fullName == null ? null : fullName,
    "phone_no_inp": phoneNoInp == null ? null : phoneNoInp,
    "contact_no": contactNo == null ? null : contactNo,
    "address": address == null ? null : address,
    "pincode": pincode == null ? null : pincode,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "zoom_level": zoomLevel == null ? null : zoomLevel,
    "preferred_date": preferredDate == null ? null : preferredDate,
    "preferred_time_start": preferredTimeStart == null ? null : preferredTimeStart,
    "preferred_time_end": preferredTimeEnd == null ? null : preferredTimeEnd,
    "airport_passenger": airportPassenger == null ? null : airportPassenger,
    "flight_no": flightNo == null ? null : flightNo,
    "travel_date": travelDate == null ? null : travelDate,
    "travel_time": travelTime == null ? null : travelTime,
    "travel_destination": travelDestination == null ? null : travelDestination,
    "assigned_status": assignedStatus == null ? null : assignedStatus,
    "data_from": dataFrom == null ? null : dataFrom,
    "pay_status": payStatus == null ? null : payStatus,
    "requested_on": requestedOn == null ? null : requestedOn,
    "distance_in_km": distanceInKm == null ? null : distanceInKm,
    "ShowButton": showButton == null ? null : showButton,
    "is_rtpcr": isRtpcr == null ? null : isRtpcr,
    "remarks": remarks == null ? "" : remarks,
  };
}
