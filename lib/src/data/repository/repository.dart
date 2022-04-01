import 'package:dio/dio.dart';
import 'package:micro_check/src/data/model/add_new_test/add_new_test_request.dart';
import 'package:micro_check/src/data/model/assigned_to_phlebo/assigned_to_phlebo_request.dart';
import 'package:micro_check/src/data/model/common/state_model.dart';
import 'package:micro_check/src/data/model/online/online_status_phlebo_request.dart';
import 'package:micro_check/src/data/model/payment/payment_request.dart';
import 'package:micro_check/src/data/model/test_request/assigned_request.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_request.dart';
import 'package:micro_check/src/data/model/test_request/local_body_fetch_request.dart';
import 'package:micro_check/src/data/model/test_request/pending_request.dart';
import 'package:micro_check/src/data/model/test_request/update_test_details.dart';
import 'package:micro_check/src/data/model/test_request/update_travel_status_request.dart';
import 'package:micro_check/src/data/model/update_live_location/update_live_location_request.dart';
import 'package:micro_check/src/data/provider/auth_provider.dart';
import 'package:micro_check/src/data/provider/master_provider.dart';
import 'package:micro_check/src/data/provider/test_request_provider.dart';

/// Repository is an intermediary class between network and data
class Repository {
  final authApiProvider = AuthApiProvider();
  final testRequestProvider = TestRequestProvider();
  // final masterApiProvider = MasterApiProvider();

  /// auth api provider

  //get otp
  // Future<StateModel> getOtp(phoneNo,signature) => authApiProvider.getOtp(phoneNo,signature);

  ///auth api provider
  Future<StateModel> getOtp(String phoneNo) =>
      authApiProvider.getOtp(phoneNo);

  Future<StateModel> getPhleboDetails(String phoneNo) =>
      authApiProvider.getPhleboDetails(phoneNo);

  ///test request provider
  Future<StateModel> assignedTestRequest(GetAssignedRequest request) =>
      testRequestProvider.assignedTestRequest(request);

  Future<StateModel> pendingTestRequest(PendingTestRequest request) =>
      testRequestProvider.pendingTestRequest(request);

  Future<StateModel> assignedToPhlebo(AssignedToPhleboRequest request) =>
      testRequestProvider.assignedToPhlebo(request);

  Future<StateModel> updateTestDetails(UpdateTestDetailsRequest request) =>
      testRequestProvider.updateTestDetails(request);

  Future<StateModel> onlineStatusPhlebo(OnlineStatusPhleboRequest request) =>
      testRequestProvider.onlineStatusPhlebo(request);

  Future<StateModel> getSingleRequestDetails(GetSingleRequestDetailsRequest request) =>
      testRequestProvider.getSingleRequestDetails(request);

  Future<StateModel> updateTravelingStatus(UpdateTravelStatusRequest request) =>
      testRequestProvider.updateTravelingStatus(request);

  Future<StateModel> localBodyFetch(LocalBodyFetchRequest request) =>
      testRequestProvider.localBodyFetch(request);

  Future<StateModel> updateLiveLocation(UpdateLiveLocationRequest request) =>
      testRequestProvider.updateLiveLocation(request);

  Future<StateModel> verifyBarcode(String barcode) =>
      testRequestProvider.verifyBarcode(barcode);

  Future<StateModel> payment(PaymentRequest request) =>
      testRequestProvider.payment(request);

  Future<StateModel> addNewTest(AddNewTestRequest request) =>
      testRequestProvider.addNewTest(request);

}
