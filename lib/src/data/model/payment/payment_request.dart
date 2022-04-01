// To parse this JSON data, do
//
//     final paymentRequest = paymentRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PaymentRequest paymentRequestFromJson(String str) => PaymentRequest.fromJson(json.decode(str));

String paymentRequestToJson(PaymentRequest data) => json.encode(data.toJson());

class PaymentRequest {
  PaymentRequest({
    required this.reqMasterId,
    required this.totalAmount,
    required this.payMethod,
    required this.refNo,
    required this.cashPaid,
    required this.balanceToCustomer,
  });

  final String reqMasterId;
  final String totalAmount;
  final String payMethod;
  final String refNo;
  final String cashPaid;
  final String balanceToCustomer;

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
    reqMasterId: json["req_master_id"] == null ? null : json["req_master_id"],
    totalAmount: json["TotalAmount"] == null ? null : json["TotalAmount"],
    payMethod: json["PayMethod"] == null ? null : json["PayMethod"],
    refNo: json["RefNo"] == null ? null : json["RefNo"],
    cashPaid: json["CashPaid"] == null ? null : json["CashPaid"],
    balanceToCustomer: json["BalanceToCustomer"] == null ? null : json["BalanceToCustomer"],
  );

  Map<String, dynamic> toJson() => {
    "req_master_id": reqMasterId == null ? null : reqMasterId,
    "TotalAmount": totalAmount == null ? null : totalAmount,
    "PayMethod": payMethod == null ? null : payMethod,
    "RefNo": refNo == null ? null : refNo,
    "CashPaid": cashPaid == null ? null : cashPaid,
    "BalanceToCustomer": balanceToCustomer == null ? null : balanceToCustomer,
  };
}
