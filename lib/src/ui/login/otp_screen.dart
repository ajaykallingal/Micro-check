import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:micro_check/src/constants/assets.dart';
import 'package:micro_check/src/data/bloc/auth_bloc.dart';
import 'package:micro_check/src/data/model/latlng.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';
import 'package:micro_check/src/data/utils/utils.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'otp_screen_argument_model.dart';

class OtpScreen extends StatefulWidget {
  final OtpScreenArguments otpScreenArguments;
  const OtpScreen({Key? key,required this.otpScreenArguments}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill,SingleTickerProviderStateMixin{
  final TextEditingController _textEditingController = TextEditingController();

  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController controller5 = new TextEditingController();
  TextEditingController controller6 = new TextEditingController();

  TextEditingController currController = new TextEditingController();

  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  FocusNode focusNode3 = new FocusNode();
  FocusNode focusNode4 = new FocusNode();
  FocusNode focusNode5 = new FocusNode();
  FocusNode focusNode6 = new FocusNode();

  bool showKeyboard = false;

  String? otpCode = '';
  String? signature;

  static const Color keyboardBackgroundColor = Color(0xFFEFEFEF);
  static const Color accentColor = Color(0xFF26AAE1);

  late AnimationController _controller;
  late LocationData locationData;
  Location location = Location();
  final authBloc = AuthBloc();
  String otpFromApi="0";
  late LatLng latLng;

  @override
  void initState() {
    // TODO: implement initState
    fetchLocationFun();
    currController = controller1;
    _controller = AnimationController(
      duration: Duration(minutes: 5),
      vsync: this,
    );
    _controller.forward();
    // _controller.addListener(() {
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    authBloc.getPhleboDetailsSCListener.listen((event) {
      ObjectFactory().prefs.savePhleboData(result:event);
      ObjectFactory().prefs.setIsLoggedIn(true);
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false,arguments: LatLng(latitude: latLng.latitude, longitude: latLng.longitude));
    });

    authBloc.getOtpSCListener.listen((event) {
      if(event.validUser) {
        setState(() {
          otpFromApi = event.otp;

        });
      }

    });

    super.didChangeDependencies();
  }

  fetchLocationFun() async {
    locationData = await location.getLocation();
    setState(() {
      latLng = LatLng(latitude: locationData.latitude!, longitude: locationData.longitude!);

    });

  }

  @override
  void codeUpdated() {
    // TODO: implement codeUpdated

    setState(() {

      otpCode = code;
      controller1.text = otpCode![0];
      controller2.text = otpCode![1];
      controller3.text = otpCode![2];
      controller4.text = otpCode![3];
      controller5.text = otpCode![4];
      controller6.text = otpCode![5];
      // if (otpCode == otpFromApi) {
      //   callOneTime = true;
      //   authBloc.loginWithPhone(
      //       phoneNo: textEditingControllerPhone.text,
      //       referredBy: referredBy,
      //       fcmToken: fcmToken);
      //   showLoading = true;
      //   showKeyboard = false;
      // }
      print(otpCode! + "new code");
    });
  }

  void getSignature() async {
    final signatureSms = await SmsAutoFill().getAppSignature;
    setState(() {
      signature = signatureSms;
    });
    print("signature :" + signatureSms.toString());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            "OTP Verification",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconTheme.of(context),
          centerTitle: true,
          elevation: 0,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .03,
                            ),
                            Text(
                              "Please Enter OTP",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                            ),

                            Text(
                              widget.otpScreenArguments.phoneNo,
                              // "Code send to +91 9090 323 323",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(color: Colors.grey),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFEFEFEF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: TextField(
                                      enabled: false,
                                        controller: controller1,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        autofocus: false,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                fontSize: 25,
                                                color: Colors.black),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFEFEFEF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: TextField(
                                        enabled: false,
                                        controller: controller2,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        autofocus: false,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                fontSize: 25,
                                                color: Colors.black),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFEFEFEF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: TextField(
                                        enabled: false,
                                        controller: controller3,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        autofocus: false,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                fontSize: 25,
                                                color: Colors.black),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFEFEFEF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: TextField(
                                        enabled: false,
                                        controller: controller4,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        autofocus: false,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                fontSize: 25,
                                                color: Colors.black),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "expires in ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                          color: Colors.grey,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                ),
                                // Countdown(
                                //   animation: StepTween(
                                //     begin: 5 * 60,
                                //     end: 0,
                                //   ).animate(_controller),
                                // ),
                    Countdown(animation: StepTween(
                      begin: 5 * 60,
                      end: 0,
                    ).animate(_controller))
                               ,
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ))),
              Positioned(
                top: MediaQuery.of(context).size.height * .35,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: (){

                          authBloc.getOtp(
                              phoneNo: widget.otpScreenArguments.phoneNo);
                          showToast("OTP sent");
                        },
                        child: Text(
                          "Resend OTP",
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: accentColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      FloatingActionButton(
                        elevation: 0,
                        onPressed: () {
                          String otpFromInput = controller1.text+controller2.text+controller3.text+controller4.text;
                          if(otpFromInput == widget.otpScreenArguments.otp || otpFromInput ==otpFromApi) {
                            authBloc.getPhleboDetails(phoneNo: widget
                                .otpScreenArguments.phoneNo);
                          }
                          else{
                            showToast("OTP is wrong !!!");
                          }
                        },
                        child: Icon(Icons.arrow_right_alt),
                        backgroundColor: accentColor,
                      )
                    ],
                  ),
                ),
              ),
              buildCustomKeyboard()
            ],
          ),
        ));
  }

  Widget buildCustomKeyboard() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * .45,
        decoration: const BoxDecoration(
          color: keyboardBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .37,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 16.0, right: 8.0, bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        MaterialButton(
                          splashColor: Colors.transparent,
                          hoverColor: keyboardBackgroundColor,
                          highlightElevation: 0,
                          color: keyboardBackgroundColor,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            inputTextToField("1");
                          },
                          child: Text("1",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ),
                        MaterialButton(
                          splashColor: Colors.transparent,
                          hoverColor: keyboardBackgroundColor,
                          highlightElevation: 0,
                          color: keyboardBackgroundColor,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            inputTextToField("2");
                          },
                          child: Text("2",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ),
                        MaterialButton(
                          splashColor: Colors.transparent,
                          hoverColor: keyboardBackgroundColor,
                          highlightElevation: 0,
                          color: keyboardBackgroundColor,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            inputTextToField("3");
                          },
                          child: Text("3",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        MaterialButton(
                          splashColor: Colors.transparent,
                          hoverColor: keyboardBackgroundColor,
                          highlightElevation: 0,
                          color: keyboardBackgroundColor,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            inputTextToField("4");
                          },
                          child: Text("4",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ),
                        MaterialButton(
                          splashColor: Colors.transparent,
                          hoverColor: keyboardBackgroundColor,
                          highlightElevation: 0,
                          color: keyboardBackgroundColor,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            inputTextToField("5");
                          },
                          child: Text("5",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ),
                        MaterialButton(
                          splashColor: Colors.transparent,
                          hoverColor: keyboardBackgroundColor,
                          highlightElevation: 0,
                          color: keyboardBackgroundColor,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            inputTextToField("6");
                          },
                          child: Text("6",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        MaterialButton(
                          splashColor: Colors.transparent,
                          hoverColor: keyboardBackgroundColor,
                          highlightElevation: 0,
                          color: keyboardBackgroundColor,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            inputTextToField("7");
                          },
                          child: Text("7",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ),
                        MaterialButton(
                          splashColor: Colors.transparent,
                          hoverColor: keyboardBackgroundColor,
                          highlightElevation: 0,
                          color: keyboardBackgroundColor,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            inputTextToField("8");
                          },
                          child: Text("8",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ),
                        MaterialButton(
                          splashColor: Colors.transparent,
                          hoverColor: keyboardBackgroundColor,
                          highlightElevation: 0,
                          color: keyboardBackgroundColor,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            inputTextToField("9");
                          },
                          child: Text("9",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        MaterialButton(
                            splashColor: Colors.transparent,
                            hoverColor: keyboardBackgroundColor,
                            highlightElevation: 0,
                            color: keyboardBackgroundColor,
                            highlightColor: Colors.transparent,
                            elevation: 0,
                            focusColor: Colors.transparent,
                            onPressed: () {
                              // setState(() {
                              //   showKeyboard = false;
                              // });
                              // matchOtp();
                            },
                            child: Text("",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center)),
                        MaterialButton(
                          splashColor: Colors.transparent,
                          hoverColor: keyboardBackgroundColor,
                          highlightElevation: 0,
                          color: keyboardBackgroundColor,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            inputTextToField("0");
                          },
                          child: Text("0",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ),
                        MaterialButton(
                            splashColor: Colors.transparent,
                            hoverColor: keyboardBackgroundColor,
                            highlightElevation: 0,
                            color: keyboardBackgroundColor,
                            highlightColor: Colors.transparent,
                            elevation: 0,
                            focusColor: Colors.transparent,
                            onPressed: () {
                              deleteText();
                            },
                            child: Icon(
                              Icons.backspace_outlined,
                              size: 22,
                              color: Colors.black87,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void inputTextToField(String str) {
    //Edit first textField
    if (currController == controller1) {
      controller1.text = str;
      currController = controller2;
    }

    //Edit second textField
    else if (currController == controller2) {
      controller2.text = str;
      currController = controller3;
    }

    //Edit third textField
    else if (currController == controller3) {
      controller3.text = str;
      currController = controller4;
    }

    //Edit fourth textField
    else if (currController == controller4) {
      controller4.text = str;
      currController = controller4;
    }

    // //Edit fifth textField
    // else if (currController == controller5) {
    //   controller5.text = str;
    //   currController = controller6;
    // }
    //
    // //Edit sixth textField
    // else if (currController == controller6) {
    //   controller6.text = str;
    //   currController = controller6;
    // }
  }

  void deleteText() {
    if (currController.text.length == 0) {
    } else {
      currController.text = "";
      currController = controller4;
      return;
    }

    if (currController == controller1) {
      controller1.text = "";
    } else if (currController == controller2) {
      controller1.text = "";
      currController = controller1;
    } else if (currController == controller3) {
      controller2.text = "";
      currController = controller2;
    } else if (currController == controller4) {
      controller3.text = "";
      currController = controller3;
    }
    // else if (currController == controller5) {
    //   controller4.text = "";
    //   currController = controller4;
    // } else if (currController == controller6) {
    //   controller5.text = "";
    //   currController = controller5;
    // }
  }
}
class Countdown extends AnimatedWidget {
  Countdown({ required this.animation}) : super(listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 12,
        color: Colors.black,
      ),
    );
  }
}