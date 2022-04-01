import 'dart:async';

import 'package:micro_check/src/constants/strings.dart';
import 'package:micro_check/src/data/model/common/state_model.dart';
import 'package:micro_check/src/data/model/get_otp/get_otp_response.dart';
import 'package:micro_check/src/data/model/master/get_company_url/get_company_url_response.dart';
import 'package:micro_check/src/data/model/phlebo_details/get_phlebo_details.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';


enum MasterBlocAction{Fetch,ClearData}
enum CounterAction{Increment,Decrement,Reset,Fetch}
enum ThemeAction{OFF,ON}
class AuthBloc {

  bool _isDisposed = false;

  ///event stream
  final _eventSC = StreamController<MasterBlocAction>();
  StreamSink<MasterBlocAction> get eventSink => _eventSC.sink;
  Stream<MasterBlocAction> get eventStream => _eventSC.stream;

  /// event stream for theme
  final _eventThemeSC = StreamController<ThemeAction>();
  StreamSink<ThemeAction> get eventThemeSink => _eventThemeSC.sink;
  Stream<ThemeAction> get eventThemeStream => _eventThemeSC.stream;

  /// stream for theme mode status
  final _themeStatusSC = StreamController<bool>.broadcast();
  StreamSink<bool> get themeStatusSink => _themeStatusSC.sink;
  Stream<bool> get themeStatusStream => _themeStatusSC.stream;

  /// stream for loader
  final _loadingSC = StreamController<bool>.broadcast();
  StreamSink<bool> get loadingSink => _loadingSC.sink;
  Stream<bool> get loadingListener => _loadingSC.stream;

  /// stream for getting company base url
  final _getOtpSC =  StreamController<GetOtpResponse>.broadcast();
  StreamSink<GetOtpResponse> get getOtpSCSink => _getOtpSC.sink;
  Stream<GetOtpResponse> get getOtpSCListener => _getOtpSC.stream;

  /// stream for getting company base url
  final _getPhleboDetailsSC =  StreamController<GetPhleboDetailsResponse>.broadcast();
  StreamSink<GetPhleboDetailsResponse> get getPhleboDetailsSCSink => _getPhleboDetailsSC.sink;
  Stream<GetPhleboDetailsResponse> get getPhleboDetailsSCListener => _getPhleboDetailsSC.stream;



  MasterBloc(){
    eventStream.listen((event) {
      if(event == MasterBlocAction.Fetch){
        themeStatusSink.add(true);
        ObjectFactory().prefs.setDarkMode(true);
      }
      else if(event == MasterBlocAction.ClearData){
        themeStatusSink.add(false);
        ObjectFactory().prefs.setDarkMode(false);
      }
    });
  }

  /// method used for fetching company url using company id
  getOtp({required String phoneNo}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.getOtp(phoneNo);

    if (state is SuccessState) {
      if (!_getOtpSC.isClosed) {
        getOtpSCSink.add(state.value as GetOtpResponse);
      }
    } else if (state is ErrorState) {
      getOtpSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }

  /// method used for fetching company url using company id
  getPhleboDetails({required String phoneNo}) async {
    if (_isDisposed) {
      return;
    }
    loadingSink.add(true);
    StateModel? state = await ObjectFactory().repository.getPhleboDetails(phoneNo);

    if (state is SuccessState) {
      if (!_getPhleboDetailsSC.isClosed) {
        getPhleboDetailsSCSink.add(state.value as GetPhleboDetailsResponse);
      }
    } else if (state is ErrorState) {
      getPhleboDetailsSCSink.addError(Strings.SOME_ERROR_OCCURRED);
    }
    loadingSink.add(false);
  }



  ///controllers disposed here
  void dispose() {
    _themeStatusSC.close();
    _eventSC.close();
    _eventThemeSC.close();
    _loadingSC.close();
    _getOtpSC.close();
  }
}