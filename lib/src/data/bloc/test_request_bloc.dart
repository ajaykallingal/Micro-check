import 'dart:async';

import 'package:micro_check/src/constants/strings.dart';
import 'package:micro_check/src/data/model/add_new_test/add_new_test_request.dart';
import 'package:micro_check/src/data/model/add_new_test/add_new_test_response.dart';
import 'package:micro_check/src/data/model/assigned_to_phlebo/assigned_to_phlebo_request.dart';
import 'package:micro_check/src/data/model/assigned_to_phlebo/assigned_to_phlebo_response.dart';
import 'package:micro_check/src/data/model/common/state_model.dart';
import 'package:micro_check/src/data/model/get_otp/get_otp_response.dart';
import 'package:micro_check/src/data/model/master/get_company_url/get_company_url_response.dart';
import 'package:micro_check/src/data/model/online/online_status_phlebo_request.dart';
import 'package:micro_check/src/data/model/online/online_status_phlebo_response.dart';
import 'package:micro_check/src/data/model/payment/payment_request.dart';
import 'package:micro_check/src/data/model/payment/payment_response.dart';
import 'package:micro_check/src/data/model/test_request/assigned_request.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_request.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_response.dart';
import 'package:micro_check/src/data/model/test_request/local_body_fetch_request.dart';
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


enum MasterBlocAction{Fetch,ClearData}
enum CounterAction{Increment,Decrement,Reset,Fetch}
enum ThemeAction{OFF,ON}
class TestRequestBloc {

  bool _isDisposed = false;

  ///event stream
  final _eventSC = StreamController<MasterBlocAction>();
  StreamSink<MasterBlocAction> get eventSink => _eventSC.sink;
  Stream<MasterBlocAction> get eventStream => _eventSC.stream;

  /// event stream for theme
  final _eventThemeSC = StreamController<ThemeAction>();
  StreamSink<ThemeAction> get eventThemeSink => _eventThemeSC.sink;
  Stream<ThemeAction> get eventThemeStream => _eventThemeSC.stream;


  /// stream for loader
  final _loadingSC = StreamController<bool>.broadcast();
  StreamSink<bool> get loadingSink => _loadingSC.sink;
  Stream<bool> get loadingListener => _loadingSC.stream;

  /// stream for getting request
  final _getTestRequestSC =  StreamController<GetTestRequestResponse>.broadcast();
  StreamSink<GetTestRequestResponse> get getTestRequestSCSink => _getTestRequestSC.sink;
  Stream<GetTestRequestResponse> get getTestRequestResponseSCListener => _getTestRequestSC.stream;


  /// stream for assigning request to phlebo
  final _assignedToPhleboSC =  StreamController<AssignedToPhleboResponse>.broadcast();
  StreamSink<AssignedToPhleboResponse> get assignedToPhleboSCSink => _assignedToPhleboSC.sink;
  Stream<AssignedToPhleboResponse> get assignedToPhleboSCListener => _assignedToPhleboSC.stream;

  /// stream for updating user details to each request
  final _updateTestDetailsSC =  StreamController<UpdateTestDetailsResponse>.broadcast();
  StreamSink<UpdateTestDetailsResponse> get updateTestDetailsSCSink => _updateTestDetailsSC.sink;
  Stream<UpdateTestDetailsResponse> get updateTestDetailsSCListener => _updateTestDetailsSC.stream;

  /// stream for updating user online status
  final _onlineStatusPhleboSC =  StreamController<OnlineStatusPhleboResponse>.broadcast();
  StreamSink<OnlineStatusPhleboResponse> get onlineStatusPhleboSCSink => _onlineStatusPhleboSC.sink;
  Stream<OnlineStatusPhleboResponse> get onlineStatusPhleboSCListener => _onlineStatusPhleboSC.stream;

  /// stream for view single request
  final _singleRequestDetailsSC =  StreamController<GetSingleRequestDetailsResponse>.broadcast();
  StreamSink<GetSingleRequestDetailsResponse> get singleRequestDetailsSCSCSink => _singleRequestDetailsSC.sink;
  Stream<GetSingleRequestDetailsResponse> get singleRequestDetailsSCListener => _singleRequestDetailsSC.stream;


  /// stream for change travel status
  final _updateTravelStatusSC =  StreamController<UpdateTravelStatusResponse>.broadcast();
  StreamSink<UpdateTravelStatusResponse> get updateTravelStatusSCSink => _updateTravelStatusSC.sink;
  Stream<UpdateTravelStatusResponse> get updateTravelStatusSCListener => _updateTravelStatusSC.stream;

  /// stream for localBodyFetch
  final _localBodyFetchSC =  StreamController<LocalBodyFetchResponse>.broadcast();
  StreamSink<LocalBodyFetchResponse> get localBodyFetchSCSink => _localBodyFetchSC.sink;
  Stream<LocalBodyFetchResponse> get localBodyFetchSCListener => _localBodyFetchSC.stream;

  /// stream for update live location
  final _updateLiveLocationSC =  StreamController<UpdateLiveLocationResponse>.broadcast();
  StreamSink<UpdateLiveLocationResponse> get updateLiveLocationSCSink => _updateLiveLocationSC.sink;
  Stream<UpdateLiveLocationResponse> get updateLiveLocationSCListener => _updateLiveLocationSC.stream;

  /// stream for verify barcode
  final _verifyBarcodeSC =  StreamController<VerifyBarcodeResponse>.broadcast();
  StreamSink<VerifyBarcodeResponse> get verifyBarcodeSCSink => _verifyBarcodeSC.sink;
  Stream<VerifyBarcodeResponse> get verifyBarcodeSCListener => _verifyBarcodeSC.stream;


  /// stream for payment
  final _paymentSC =  StreamController<PaymentMethodResponse>.broadcast();
  StreamSink<PaymentMethodResponse> get paymentSCSink => _paymentSC.sink;
  Stream<PaymentMethodResponse> get paymentSCListener => _paymentSC.stream;


  /// stream for add new test request
  final _addNewTestSC =  StreamController<AddNewTestResponse>.broadcast();
  StreamSink<AddNewTestResponse> get addNewTestSCSink => _addNewTestSC.sink;
  Stream<AddNewTestResponse> get addNewTestSCListener => _addNewTestSC.stream;




  TestRequestBloc();

  /// method used for fetching company url using company id
  assignedTestRequest({required GetAssignedRequest request}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.assignedTestRequest(request);

    if (state is SuccessState) {
      if (!_getTestRequestSC.isClosed) {
        getTestRequestSCSink.add(state.value as GetTestRequestResponse);
      }
    } else if (state is ErrorState) {
      getTestRequestSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }


  pendingTestRequest({required PendingTestRequest request}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.pendingTestRequest(request);

    if (state is SuccessState) {
      if (!_getTestRequestSC.isClosed) {
        getTestRequestSCSink.add(state.value as GetTestRequestResponse);
      }
    } else if (state is ErrorState) {
      getTestRequestSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }

  assignedToPhlebo({required AssignedToPhleboRequest request}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.assignedToPhlebo(request);

    if (state is SuccessState) {
      if (!_assignedToPhleboSC.isClosed) {
        assignedToPhleboSCSink.add(state.value as AssignedToPhleboResponse);
      }
    } else if (state is ErrorState) {
      assignedToPhleboSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }


  updateTestDetails({required UpdateTestDetailsRequest request}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.updateTestDetails(request);

    if (state is SuccessState) {
      if (!_updateTestDetailsSC.isClosed) {
        updateTestDetailsSCSink.add(state.value as UpdateTestDetailsResponse);

      }
    } else if (state is ErrorState) {
      updateTestDetailsSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }

  onlineStatusPhlebo({required OnlineStatusPhleboRequest request}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.onlineStatusPhlebo(request);

    if (state is SuccessState) {
      if (!_onlineStatusPhleboSC.isClosed) {
        onlineStatusPhleboSCSink.add(state.value as OnlineStatusPhleboResponse);

      }
    } else if (state is ErrorState) {
      onlineStatusPhleboSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }

  ///request details screen
  getSingleRequestDetails({required GetSingleRequestDetailsRequest request}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.getSingleRequestDetails(request);

    if (state is SuccessState) {
      if (!_singleRequestDetailsSC.isClosed) {
        singleRequestDetailsSCSCSink.add(state.value as GetSingleRequestDetailsResponse);
      }
    } else if (state is ErrorState) {
      singleRequestDetailsSCSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }

  updateTravelingStatus({required UpdateTravelStatusRequest request}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.updateTravelingStatus(request);

    if (state is SuccessState) {
      if (!_updateTravelStatusSC.isClosed) {
        updateTravelStatusSCSink.add(state.value as UpdateTravelStatusResponse);
      }
    } else if (state is ErrorState) {
      updateTravelStatusSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }

  localBodyFetch({required LocalBodyFetchRequest request}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.localBodyFetch(request);

    if (state is SuccessState) {
      if (!_localBodyFetchSC.isClosed) {
        localBodyFetchSCSink.add(state.value as LocalBodyFetchResponse);
      }
    } else if (state is ErrorState) {
      localBodyFetchSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }

  updateLiveLocation({required UpdateLiveLocationRequest request}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.updateLiveLocation(request);

    if (state is SuccessState) {
      if (!_updateLiveLocationSC.isClosed) {
        updateLiveLocationSCSink.add(state.value as UpdateLiveLocationResponse);
      }
    } else if (state is ErrorState) {
      updateLiveLocationSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }

  verifyBarcode({required String barcode}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.verifyBarcode(barcode);

    if (state is SuccessState) {
      if (!_verifyBarcodeSC.isClosed) {
        verifyBarcodeSCSink.add(state.value as VerifyBarcodeResponse);
      }
    } else if (state is ErrorState) {
      verifyBarcodeSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }

  payment({required PaymentRequest request}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.payment(request);

    if (state is SuccessState) {
      if (!_paymentSC.isClosed) {
        paymentSCSink.add(state.value as PaymentMethodResponse);
      }
    } else if (state is ErrorState) {
      paymentSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }


  addNewTest({required AddNewTestRequest request}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.addNewTest(request);

    if (state is SuccessState) {
      if (!_addNewTestSC.isClosed) {
        addNewTestSCSink.add(state.value as AddNewTestResponse);
      }
    } else if (state is ErrorState) {
      addNewTestSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }



  ///controllers disposed here
  void dispose() {
    _eventSC.close();
    _eventThemeSC.close();
    _loadingSC.close();
    _getTestRequestSC.close();
    _updateTravelStatusSC.close();
    _verifyBarcodeSC.close();
    _singleRequestDetailsSC.close();
    _updateTestDetailsSC.close();
    _assignedToPhleboSC.close();
    _paymentSC.close();
    _onlineStatusPhleboSC.close();
    _updateLiveLocationSC.close();
    _addNewTestSC.close();
    _localBodyFetchSC.close();
  }
}