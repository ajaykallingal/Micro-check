import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:micro_check/src/data/shared_pref/object_factory.dart';

enum ChatAction{Fetch,ClearData}
enum CounterAction{Increment,Decrement,Reset,Fetch}
enum ThemeAction{OFF,ON}
class SettingsBloc {

  ///event stream
  final _eventSC = StreamController<CounterAction>();
  StreamSink<CounterAction> get eventSink => _eventSC.sink;
  Stream<CounterAction> get eventStream => _eventSC.stream;

  /// event stream for theme
  final _eventThemeSC = StreamController<ThemeAction>();
  StreamSink<ThemeAction> get eventThemeSink => _eventThemeSC.sink;
  Stream<ThemeAction> get eventThemeStream => _eventThemeSC.stream;

  /// stream for theme mode status
  final _themeStatusSC = StreamController<bool>.broadcast();
  StreamSink<bool> get themeStatusSink => _themeStatusSC.sink;
  Stream<bool> get themeStatusStream => _themeStatusSC.stream;

  // void getJson() async {
  //   String a = "rgba(100, 200, 255, 1)";
  //   String b = a.replaceAll(new RegExp(r'[^0-9,]'),'');
  //   print(b);
  //   List<Example> example = exampleFromJson(
  //       await rootBundle.loadString('assets/data_json.json'));
  //
  // }


  SettingsBloc() {
    // getJson();
   eventThemeStream.listen((event) {
      if(event == ThemeAction.ON){
        themeStatusSink.add(true);
        ObjectFactory().prefs.setDarkMode(true);
      }
      else if(event == ThemeAction.OFF){
        themeStatusSink.add(false);
        ObjectFactory().prefs.setDarkMode(false);
      }
    });
  }



  void dispose() {
    _themeStatusSC.close();
    _eventSC.close();
    _eventThemeSC.close();
  }
}