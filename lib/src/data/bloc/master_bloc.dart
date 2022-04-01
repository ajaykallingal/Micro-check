import 'dart:async';

import 'package:micro_check/src/constants/strings.dart';
import 'package:micro_check/src/data/model/common/state_model.dart';
import 'package:micro_check/src/data/model/master/get_company_url/get_company_url_response.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';


enum MasterBlocAction{Fetch,ClearData}
enum CounterAction{Increment,Decrement,Reset,Fetch}
enum ThemeAction{OFF,ON}
class MasterBloc {

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
  final _loadingSC = new StreamController<bool>.broadcast();
  StreamSink<bool> get loadingSink => _loadingSC.sink;
  Stream<bool> get loadingListener => _loadingSC.stream;

  /// stream for getting company base url
  final _getCompanyUrlSC = new StreamController<GetBaseUrlResponse>.broadcast();
  StreamSink<GetBaseUrlResponse> get getCompanyUrlSink => _getCompanyUrlSC.sink;
  Stream<GetBaseUrlResponse> get getCompanyUrlListener => _getCompanyUrlSC.stream;



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





  ///controllers disposed here
  void dispose() {
    _themeStatusSC.close();
    _eventSC.close();
    _eventThemeSC.close();
    _loadingSC.close();
    _getCompanyUrlSC.close();
  }
}