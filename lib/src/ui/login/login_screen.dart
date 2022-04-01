import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:micro_check/src/constants/assets.dart';
import 'package:micro_check/src/constants/colors.dart';
import 'package:micro_check/src/data/bloc/auth_bloc.dart';
import 'package:micro_check/src/data/utils/utils.dart';

import 'otp_screen_argument_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _textEditingController = TextEditingController();
  final authBloc = AuthBloc();
  bool loading = false;
  late bool serviceEnabled;
  bool clickedOneTime = false;
  late PermissionStatus permissionStatus;
  late LocationData locationData;
  Location location = Location();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    authBloc.getOtpSCListener.listen((event) {
      if (clickedOneTime) if (event.validUser) {
        setState(() {
          clickedOneTime = false;
          loading = false;
        });
        Navigator.pushNamed(context, "/otp",
            arguments: OtpScreenArguments(
                phoneNo: _textEditingController.text, otp: event.otp));
      } else {
        setState(() {
          clickedOneTime = false;
          loading = false;
        });
        showToast("Not a Valid User");
        setState(() {
          loading = false;
        });
      }
    });

    super.didChangeDependencies();
  }

  permissionHandle1() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      // AppSettings.openAppSettings();

      permissionStatus = await location.requestPermission();

      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
    // fetchLocationFun();
    // Timer.periodic(Duration(seconds: 5), (timer) {
    //   fetchLocationFun();
    //
    // });
    // fetchLocationFun();
    // print(locationData.latitude.toString() +
    //     " " +
    //     locationData.longitude.toString());
  }

  permissionHandle2() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionStatus = await location.hasPermission();

    // AppSettings.openAppSettings();

    // permissionStatus = await location.requestPermission();
    if (permissionStatus != PermissionStatus.granted) {
      showDialog(
          context: context,
          useRootNavigator: true,
          barrierColor: Colors.black12.withOpacity(0.5),
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              title: const Icon(Icons.location_on_outlined,
                  color: Colors.blueAccent),
              content: const Text(
                'Allow Android App to access this\ndevice location?',
                softWrap: true,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    AppSettings.openAppSettings();
                    Navigator.of(context, rootNavigator: true).pop();

                    // permissionHandle2();
                  },
                  child: Text('Go to settings'),
                ),
              ],
            );
          });
    } else {
      return;
    }

    // print(locationData.latitude.toString() +
    //     " " +
    //     locationData.longitude.toString());
  }

  permissionOnStart() async {
    // AppLifecycleState? state;

    String deviceVersionCheck = '11';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String? deviceVersion = androidInfo.version.release;
    int devVersion = int.parse(deviceVersion!);

    print(devVersion);
    if (devVersion > 10) {
      permissionHandle1();
    } else if (devVersion <= 10) {
      permissionHandle2();

      // fetchLocationFun();
      // Timer.periodic(Duration(seconds: 5), (timer) {
      //   fetchLocationFun();
      //   // if(state == AppLifecycleState.detached){
      //   //   timer.cancel();
      //   // }
      // });
      // Navigator.pop(context);

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    permissionHandle2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .63,
            color: Colors.transparent,
            child: Image.asset(
              Assets.loginBackground,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .62,
            color: AppColors.buttonColor.withOpacity(.6),
            child: Center(
              child: Image.asset(
                Assets.logo,
                scale: 3,
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  height: MediaQuery.of(context).size.height * .4,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: AppColors.buttonColor),
                        ),
                        TextField(
                            controller: _textEditingController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                        SizedBox(
                          height: 24,
                        ),
                        GestureDetector(
                          onTap: () async {

                            if (!clickedOneTime) {
                              if (!loading) {
                                permissionStatus =
                                    await location.hasPermission();
                                if (permissionStatus ==
                                    PermissionStatus.granted) {
                                  if (!loading) {
                                    showToast("OTP Sent");
                                    authBloc.getOtp(
                                        phoneNo: _textEditingController.text);
                                    setState(() {
                                      loading = true;
                                      clickedOneTime = true;
                                    });
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      useRootNavigator: true,
                                      barrierColor:
                                          Colors.black12.withOpacity(0.5),
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18)),
                                          title: const Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.blueAccent),
                                          content: const Text(
                                            'Allow Android App to access this\ndevice location?',
                                            softWrap: true,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                AppSettings.openAppSettings();
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();

                                                // permissionHandle2();
                                              },
                                              child: Text('Go to settings'),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              }
                            }
                          },
                          // onTap: ()=>  Navigator.pushNamed(context, "/otp",arguments: _textEditingController.text),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                                color: AppColors.buttonColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Center(
                                child: loading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text(
                                        "Get OTP",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(color: Colors.white),
                                      )),
                          ),
                        )
                      ],
                    ),
                  )))
        ],
      ),
    ));
  }
}
