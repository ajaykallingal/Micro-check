// import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:micro_check/src/constants/urls.dart';
import 'package:micro_check/src/data/model/add_new_test/add_new_test_request.dart';
import 'package:micro_check/src/data/model/assigned_to_phlebo/assigned_to_phlebo_request.dart';
import 'package:micro_check/src/data/model/online/online_status_phlebo_request.dart';
import 'package:micro_check/src/data/model/payment/payment_request.dart';
import 'package:micro_check/src/data/model/test_request/assigned_request.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_request.dart';
import 'package:micro_check/src/data/model/test_request/local_body_fetch_request.dart';
import 'package:micro_check/src/data/model/test_request/pending_request.dart';
import 'package:micro_check/src/data/model/test_request/update_test_details.dart';
import 'package:micro_check/src/data/model/test_request/update_travel_status_request.dart';
import 'package:micro_check/src/data/model/time_slot/time_slot_request.dart';
import 'package:micro_check/src/data/model/update_live_location/update_live_location_request.dart';


class ApiClient {
   ApiClient() {
    initClient();
  }

   late Dio dio;

   late BaseOptions _baseOptions;
  //
  // String username= 'admin@finekube.com';
  // // live
  // String password = 'SA537KEDx3o2M4544O6Xh78wkgxOSH9a';
  // // dev
  // String passwordDev = 'w4M2099455l9k9Vy6l4PA136Y62l05lX';
  //
  /// client production
  initClient() async {

    // String basicAuth = 'Basic ' +
    //     base64Encode(utf8.encode('$username:$password'));
    _baseOptions = BaseOptions(
      baseUrl: Urls.baseUrlProd,
        connectTimeout: 30000,
        receiveTimeout: 1000000,
        followRedirects: true,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          // "authorization": basicAuth
        },
        responseType: ResponseType.json,
        receiveDataWhenStatusError: true);

    dio = Dio(_baseOptions);

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (reqOptions,handler) {
        return handler.next(reqOptions);
      },
      onError: (DioError dioError,handler) {
        return handler.next(dioError);
      },
    ));
  }




  /// login screen
  Future<Response> getOtp(String phoneNo) {
    return dio.post(Urls.getOtp,data: {"PhlebotomistContact":phoneNo,"Signature":"updatesoon"});
  }

  ///otp screen
  Future<Response> getPhleboDetails(String phoneNo) {
    return dio.post(Urls.getPhleboDetails,data: {"PhlebotomistContact":phoneNo});
  }


  ///home screen
  Future<Response> getAssignedRequest(GetAssignedRequest request) {
    return dio.post(Urls.getAssignedTestRequest,data:request);
  }

  Future<Response> getPendingRequest(PendingTestRequest request) {
    return dio.post(Urls.pendingTestRequest,data:request);
  }


   Future<Response> assignedToPhlebo(AssignedToPhleboRequest request) {
    return dio.post(Urls.assignedToPhlebo,data:request);
  }


  Future<Response> updateTestDetails(UpdateTestDetailsRequest request) {
    return dio.post(Urls.updateTestDetails,data:request);
  }

  Future<Response> onlineStatusPhlebo(OnlineStatusPhleboRequest request) {
    return dio.post(Urls.onlineStatusPhlebo,data:request);
  }

   ///request details screen
   Future<Response> getSingleRequestDetails(GetSingleRequestDetailsRequest request) {
     return dio.post(Urls.singleRequestDetails,data: request);
   }

   Future<Response> updateTravelingStatus(UpdateTravelStatusRequest request) {
     return dio.post(Urls.updateTravelingStatus,data: request);
   }

   Future<Response> updateLiveLocation(UpdateLiveLocationRequest request) {
     return dio.post(Urls.updateLiveLocation,data: request);
   }


   ///user input screen
   Future<Response> verifyBarcode(String barcode) {
     return dio.post(Urls.verifyBarcode,data: {"Barcode":barcode});
   }

   Future<Response> localBodyFetch(LocalBodyFetchRequest request) {
     return dio.post(Urls.localBodyList,data: request);
   }

   ///payment screen
   Future<Response> payment(PaymentRequest request) {
     return dio.post(Urls.payment,data: request);
   }


   ///payment screen
   Future<Response> addNewTest(AddNewTestRequest request) {
     return dio.post(Urls.addNewTest,data: request);
   }



   ///add new Request screen
   Future<Response> checkTimeSlot(TimeSlotRequest request) {
     return dio.post(Urls.addNewTest,data: request);
   }








}