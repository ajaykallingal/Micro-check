import 'package:flutter/material.dart';
import 'package:micro_check/src/common/route_generator.dart';
import 'package:micro_check/src/data/bloc/settings_bloc.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  ObjectFactory().setPrefs(sharedPreferences);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  SettingsBloc settingsBloc = SettingsBloc();
  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider<ThemeChanger>(
    //   create: (_) => ThemeChanger(ThemeData.dark()),
    //   child: new MaterialAppWithTheme(),
    // );
    return StreamBuilder<bool>(
        stream: settingsBloc.themeStatusStream,
        initialData: true,
        builder: (context, snapshot) {
        return MaterialApp(debugShowCheckedModeBanner: false,
          initialRoute: "/",
          builder: (context, child) {
            return MediaQuery(
              child: child!,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          },
          onGenerateRoute: RouteGenerator.generateRoute,
          theme: snapshot.hasData?snapshot.data!?ThemeData.light():ThemeData.dark():ThemeData.dark(),
        );
      }
    );


  }
}

