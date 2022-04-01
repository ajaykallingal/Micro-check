// To parse this JSON data, do
//
//     final updateTestDetailsRequest = updateTestDetailsRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UpdateTestDetailsRequest updateTestDetailsRequestFromJson(String str) => UpdateTestDetailsRequest.fromJson(json.decode(str));

String updateTestDetailsRequestToJson(UpdateTestDetailsRequest data) => json.encode(data.toJson());

class UpdateTestDetailsRequest {
  UpdateTestDetailsRequest({
    required this.prePrintedBarcode,
    required this.uidImage,
    required this.uidNo,
    required this.uidType,
    required this.email,
    required this.dob,
    required this.gender,
    required this.nameTitle,
    required this.requestDetailId,
    required this.districtId,
    required this.localBodyType,
    required this.localBody,
    required this.patientCategory,
  });

  final String prePrintedBarcode;
  final String uidImage;
  final String uidNo;
  final String uidType;
  final String email;
  final String dob;
  final String gender;
  final String nameTitle;
  final String requestDetailId;
  final String districtId;
  final String localBodyType;
  final String localBody;
  final String patientCategory;

  factory UpdateTestDetailsRequest.fromJson(Map<String, dynamic> json) => UpdateTestDetailsRequest(
    prePrintedBarcode: json["pre_printed_barcode"] == null ? null : json["pre_printed_barcode"],
    uidImage: json["uid_image"] == null ? null : json["uid_image"],
    uidNo: json["uid_no"] == null ? null : json["uid_no"],
    uidType: json["uid_type"] == null ? null : json["uid_type"],
    email: json["email"] == null ? null : json["email"],
    dob: json["dob"] == null ? null : json["dob"],
    gender: json["gender"] == null ? null : json["gender"],
    nameTitle: json["name_title"] == null ? null : json["name_title"],
    requestDetailId: json["request_detail_id"] == null ? null : json["request_detail_id"],
    districtId: json["district_id"] == null ? null : json["district_id"],
    localBodyType: json["local_body_type"] == null ? null : json["local_body_type"],
    localBody: json["local_body"] == null ? null : json["local_body"],
    patientCategory: json["patient_category"] == null ? null : json["patient_category"],
  );

  Map<String, dynamic> toJson() => {
    "pre_printed_barcode": prePrintedBarcode == null ? null : prePrintedBarcode,
    "uid_image": uidImage == null ? null : uidImage,
    "uid_no": uidNo == null ? null : uidNo,
    "uid_type": uidType == null ? null : uidType,
    "email": email == null ? null : email,
    "dob": dob == null ? null : dob,
    "gender": gender == null ? null : gender,
    "name_title": nameTitle == null ? null : nameTitle,
    "request_detail_id": requestDetailId == null ? null : requestDetailId,
    "district_id": districtId == null ? null : districtId,
    "local_body_type": localBodyType == null ? null : localBodyType,
    "local_body": localBody == null ? null : localBody,
    "patient_category" : patientCategory == null ? null : patientCategory,

  };
}
