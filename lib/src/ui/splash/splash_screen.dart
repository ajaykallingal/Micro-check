import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:micro_check/src/constants/assets.dart';
import 'package:micro_check/src/constants/colors.dart';
import 'package:micro_check/src/data/model/latlng.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';
import 'package:micro_check/src/ui/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int splashDelay = 3;

  LocationData? locationData;
  Location location = Location();
  late PermissionStatus permissionStatus;
  late LatLng latLng;

  @override
  void initState() {
    // TODO: implement initState
    _loadWidget();
    super.initState();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);

    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if (mounted) {
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //         LoginScreen()),
      //         (Route<dynamic> route) => false);
      if (!ObjectFactory().prefs.isLoggedIn()!) {
        Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
      } else {
        fetchLocationFun();
      }
    }
  }

  fetchLocationFun() async {
    bool gotEnabled = await location.requestService();
    permissionStatus = await location.hasPermission();

    // permissionStatus = await location.requestPermission();
    if (permissionStatus == PermissionStatus.granted) {
      locationData = await location.getLocation();
      await Navigator.pushNamedAndRemoveUntil(
          context, "/home", (route) => false,
          arguments: LatLng(
              latitude: locationData!.latitude!,
              longitude: locationData!.longitude!));
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: AppColors.buttonColor,
      child: Center(
        child: Image.asset(
          Assets.logo,
          scale: 3,
        ),
      ),
    ),
      
    );
  }
}
