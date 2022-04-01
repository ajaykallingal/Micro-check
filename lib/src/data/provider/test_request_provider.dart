

import 'package:micro_check/src/data/model/add_new_test/add_new_test_request.dart';
import 'package:micro_check/src/data/model/add_new_test/add_new_test_response.dart';
import 'package:micro_check/src/data/model/assigned_to_phlebo/assigned_to_phlebo_request.dart';
import 'package:micro_check/src/data/model/assigned_to_phlebo/assigned_to_phlebo_response.dart';
import 'package:micro_check/src/data/model/common/state_model.dart';
import 'package:micro_check/src/data/model/online/online_status_phlebo_request.dart';
import 'package:micro_check/src/data/model/online/online_status_phlebo_response.dart';
import 'package:micro_check/src/data/model/payment/payment_request.dart';
import 'package:micro_check/src/data/model/payment/payment_response.dart';
import 'package:micro_check/src/data/model/test_request/assigned_request.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_request.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_response.dart';
import 'package:micro_check/src/data/model/test_request/local_body_fetch_response.dart';
import 'package:micro_check/src/data/model/test_request/pending_request.dart';
import 'package:micro_check/src/data/model/test_request/test_response.dart';
import 'package:micro_check/src/data/model/test_request/update_test_details.dart';
import 'package:micro_check/src/data/model/test_request/update_test_details_response.dart';
import 'package:micro_check/src/data/model/test_request/update_travel_status_request.dart';
import 'package:micro_check/src/data/model/test_request/update_travel_status_response.dart';
import 'package:micro_check/src/data/model/test_request/verify_barcode_response.dart';
import 'package:micro_check/src/data/model/update_live_location/update_live_location_request.dart';
import 'package:micro_check/src/data/model/update_live_location/update_live_location_response.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';

import '../model/test_request/local_body_fetch_request.dart';

class TestRequestProvider {
  ///fetch assigned test request
  Future<StateModel> assignedTestRequest(GetAssignedRequest request) async {
    final response = await ObjectFactory().apiClient.getAssignedRequest(request);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<GetTestRequestResponse>.success(GetTestRequestResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }

  Future<StateModel> pendingTestRequest(PendingTestRequest request) async {
    final response = await ObjectFactory().apiClient.getPendingRequest(request);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<GetTestRequestResponse>.success(GetTestRequestResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }

  Future<StateModel> assignedToPhlebo(AssignedToPhleboRequest request) async {
    final response = await ObjectFactory().apiClient.assignedToPhlebo(request);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<AssignedToPhleboResponse>.success(AssignedToPhleboResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }

  Future<StateModel> updateTestDetails(UpdateTestDetailsRequest request) async {
    final response = await ObjectFactory().apiClient.updateTestDetails(request);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<UpdateTestDetailsResponse>.success(UpdateTestDetailsResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }

  Future<StateModel> onlineStatusPhlebo(OnlineStatusPhleboRequest request) async {
    final response = await ObjectFactory().apiClient.onlineStatusPhlebo(request);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<OnlineStatusPhleboResponse>.success(OnlineStatusPhleboResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }

  Future<StateModel> getSingleRequestDetails(GetSingleRequestDetailsRequest request) async {
    final response = await ObjectFactory().apiClient.getSingleRequestDetails(request);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<GetSingleRequestDetailsResponse>.success(GetSingleRequestDetailsResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }

  Future<StateModel> updateTravelingStatus(UpdateTravelStatusRequest request) async {
    final response = await ObjectFactory().apiClient.updateTravelingStatus(request);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<UpdateTravelStatusResponse>.success(UpdateTravelStatusResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }
  Future<StateModel> localBodyFetch(LocalBodyFetchRequest request) async {
    final response = await ObjectFactory().apiClient.localBodyFetch(request);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<LocalBodyFetchResponse>.success(LocalBodyFetchResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }


  Future<StateModel> updateLiveLocation(UpdateLiveLocationRequest request) async {
    final response = await ObjectFactory().apiClient.updateLiveLocation(request);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<UpdateLiveLocationResponse>.success(UpdateLiveLocationResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }


  Future<StateModel> verifyBarcode(String barcode) async {
    final response = await ObjectFactory().apiClient.verifyBarcode(barcode);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<VerifyBarcodeResponse>.success(VerifyBarcodeResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }

  Future<StateModel> payment(PaymentRequest request) async {
    final response = await ObjectFactory().apiClient.payment(request);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<PaymentMethodResponse>.success(PaymentMethodResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }

  Future<StateModel> addNewTest(AddNewTestRequest request) async {
    final response = await ObjectFactory().apiClient.addNewTest(request);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<AddNewTestResponse>.success(AddNewTestResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }


}