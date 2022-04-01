import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:micro_check/src/common/styles.dart';
import 'package:micro_check/src/constants/assets.dart';
import 'package:micro_check/src/data/bloc/test_request_bloc.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_request.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_response.dart';
import 'package:micro_check/src/data/model/test_request/local_body_fetch_response.dart';
import 'package:micro_check/src/data/model/test_request/update_travel_status_request.dart';
import 'package:micro_check/src/data/model/test_request/update_travel_status_response.dart';
import 'package:micro_check/src/data/model/update_live_location/update_live_location_request.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';
import 'package:micro_check/src/data/utils/utils.dart';
import 'package:micro_check/src/ui/payment/payment_screen_arguments.dart';
import 'package:micro_check/src/ui/request_details/widgets/address_details_widgets.dart';
import 'package:micro_check/src/ui/request_details/widgets/contact_direction_widget.dart';
import 'package:micro_check/src/ui/request_details/widgets/name_date_time_details.dart';
import 'package:micro_check/src/ui/request_details/widgets/remarks_details_widget.dart';
import 'package:micro_check/src/ui/request_details/widgets/travel_details_widgets.dart';
import 'package:micro_check/src/ui/user_input_data/input_screen_argument_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RequestDetailScreen extends StatefulWidget {
  final GetSingleRequestDetailsRequest getSingleRequestDetailsRequest;

  const RequestDetailScreen(
      {Key? key, required this.getSingleRequestDetailsRequest})
      : super(key: key);

  @override
  _RequestDetailScreenState createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  Location location = Location();
  late bool serviceEnabled;
  bool phleboReached = false;
  late PermissionStatus permissionStatus;
  late LocationData locationData;
  TextEditingController rescheduleDatePickerController =
      TextEditingController();
  TextEditingController rescheduleTimePickerController =
      TextEditingController();

  String? newDatePicked;
  Timer? timer;

  DateTime initialDate = DateTime.now();
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  String? newTimePicked;
  bool loading = true;
  String referenceID = "0";
  String phleboTravellingStarted = "STARTED";
  String phleboTravellingReached = "REACHED";

  final testRequestBloc = TestRequestBloc();
  StreamSubscription<LocationData>? locationSubscription;

  Future _selectRescheduleDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
        initialDatePickerMode: DatePickerMode.day,
        // initialEntryMode: DatePickerEntryMode.calendar,
        context: context,
        initialDate: DateUtils.dateOnly(initialDate),
        firstDate: DateTime(2010),
        lastDate: DateTime(2100));

    if (date != null) {
      // datePickerController2.text = clientDate.toString();

      setState(() {
        initialDate = date;
        rescheduleDatePickerController.text = DateFormat.yMd().format(date);

        // newDatePicked = initialDate as String;
      });
    }
  }

  Future _selectRescheduleTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      // _controller2.text = newTime.toString();

      setState(() {
        _time = newTime;
        rescheduleTimePickerController.text = newTime.format(context);
        // newTimePicked = _time.format(context).toString();
      });
    }
  }

  fetchLocationFun() async {
    locationData = await location.getLocation();
    location.enableBackgroundMode(enable: true);
    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocationFetch) {
      timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        if (phleboReached) {
          print("phlebo reached");
        } else {
          testRequestBloc.updateLiveLocation(
              request: UpdateLiveLocationRequest(
                  phleboId: ObjectFactory()
                      .prefs
                      .getPhleboData()!
                      .response!
                      .phlebotomistId,
                  phleboLatitude: currentLocationFetch.latitude.toString(),
                  phleboLongitude: currentLocationFetch.longitude.toString()));
        }
      });

      // print(currentLocationFetch.latitude.toString() +
      //     " " +
      //     currentLocationFetch.longitude.toString());
    });
  }

  refreshAddressScreen(dynamic value) {
    setState(() {
      referenceID = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    testRequestBloc.getSingleRequestDetails(
        request: widget.getSingleRequestDetailsRequest);
    rescheduleTimePickerController.addListener(() {});
    rescheduleDatePickerController.addListener(() {});
    super.initState();
  }

  Response? responseDetails;
  List<UidList>? uidList;
  bool skipInput = false;
  PaymentDetails? paymentDetails;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    testRequestBloc.singleRequestDetailsSCListener.listen((event) {
      setState(() {
        loading = false;
        responseDetails = event.response!;
        uidList = event.uidList;


        skipInput = event.skipInputDetails;
        paymentDetails = event.paymentDetails;
      });
    });


    testRequestBloc.updateTravelStatusSCListener.listen((event) {
      setState(() {
        if (event.updateResponse) {
          loading = false;
          if (event.requestDetails!.requestStatus == "10") {
            showToast("Traveling started");
            fetchLocationFun();
          } else if (event.requestDetails!.requestStatus == "11") {
            showToast("Destination Reached");
              phleboReached = true;
              locationSubscription?.cancel();
            timer?.cancel();
            Navigator.pushNamed(context, "/userInput",
                arguments: UserInputDataScreenArguments(
                    requestID: event.requestDetails!.reqMasterId,

                    list: event.uidList!,totalAmount: paymentDetails!.districtRtpcrPrice,name: event.requestDetails!.fullName,



                ));
          }
          responseDetails = event.requestDetails!;
        }
      });
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    rescheduleDatePickerController.dispose();
    rescheduleTimePickerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // extendBody: true,
      // bottomSheet:
      backgroundColor: Color(0xff26ABE2).withOpacity(1.0),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: kMainThemeColor,
            child: Column(
              children: [
                SizedBox(height: 45),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                      contentPadding: EdgeInsets.only(right: 70),
                      title: Text(
                        'Request Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      )),
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                    child: !loading
                        ? Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(1.0),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  // mainAxisSize: MainAxisSize.max,
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    responseDetails!.requestStatus == "10"
                                        ? Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, left: 130),
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Row(
                                                    children: [
                                                      ImageIcon(
                                                        AssetImage(
                                                            Assets.traveling),
                                                        color: Color(0xff21B137)
                                                            .withOpacity(1.0),
                                                        size: 30,
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        'Traveling....',
                                                        style:
                                                            kRequestDetailsPageTitleText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              ///reschedule and hold
                                              // InkWell(
                                              //   child: Padding(
                                              //     padding: const EdgeInsets.only(
                                              //         right: 20, top: 10),
                                              //     child: ImageIcon(
                                              //       AssetImage(Assets.lineIcon),
                                              //       color: Color(0xff26ABE2).withOpacity(1.0),
                                              //     ),
                                              //   ),
                                              //   onTap: () {
                                              //     showAlertDialog(context);
                                              //   },
                                              // ),
                                            ],
                                          )
                                        : Container(),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Container(
                                                height: 480,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: responseDetails!
                                                              .airportPassenger ==
                                                          "1"
                                                      ? Color(0xFFF85656)
                                                          .withOpacity(1.0)
                                                      : Colors.white,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15, top: 8),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Row(
                                                      children: [
                                                        ImageIcon(
                                                          AssetImage(
                                                              Assets.roundIcon),
                                                          size: 20,
                                                          color: Colors.white
                                                              .withOpacity(1.0),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          'Airport Passenger',
                                                          style:
                                                              kRequestDetailsAirportPassenger,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  height: 446,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        color: Colors.black12,
                                                        width: .5),
                                                    color: Colors.white
                                                        .withOpacity(1.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20,
                                                            top: 15),
                                                    child:
                                                        SingleChildScrollView(
                                                            physics:
                                                                BouncingScrollPhysics(),
                                                            child: Column(
                                                              children: [
                                                                NameDateTimeDetails(
                                                                    response:
                                                                        responseDetails!),
                                                                SizedBox(
                                                                    height: 10),
                                                                AddressDetailsWidget(
                                                                  response:
                                                                      responseDetails!,
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                ContactAndDirectionWidget(
                                                                  response:
                                                                      responseDetails!,
                                                                ),
                                                                SizedBox(
                                                                    height: 15),
                                                                responseDetails!
                                                                            .airportPassenger ==
                                                                        "1"
                                                                    ? TravelDetailsWidget(
                                                                        response:
                                                                            responseDetails!,
                                                                      )
                                                                    : Container(),
                                                                Divider(
                                                                  color: Color(0xff707070),
                                                                  thickness: 0.1,
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                responseDetails!
                                                                .airportPassenger == "1" ?
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'Remarks',
                                                                            style: kTitiliumWebLeftSideSemiBoldText2,
                                                                            textAlign: TextAlign.left,
                                                                          ),
                                                                          SizedBox(height: 3),
                                                                          // Text(
                                                                          //   response.fullName,overflow: TextOverflow.ellipsis,maxLines: 1,softWrap: true,
                                                                          //   style: kTitiliumWebLeftSideSemiBoldText1,
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          // Text(
                                                                          //   ' Preferred Date & Time',
                                                                          //   style: kTitiliumWebLeftSideSemiBoldText2,
                                                                          //   textAlign: TextAlign.left,
                                                                          // ),
                                                                          //
                                                                          // SizedBox(height: 3),

                                                                          Text(
                                                                            "RTPCR",
                                                                            // ' ${response.preferredDate.split('-').reversed.join('-')} | ${response.preferredTimeStart} ',
                                                                            // ' ${response.preferredDate.split('-').reversed.join('-')} | ${DateFormat("h:mma").format(DateTime.tryParse(response.preferredTimeStart)!)} ',
                                                                            // ' ${String.fromCharCodes(response.preferredDate.runes.toList().reversed)} | ${response.preferredTimeStart} ',
                                                                            style:TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.black.withOpacity(1.0),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                                    :
                                                                RemarksDetails(response: responseDetails!) ,



                                                              ],
                                                            )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(height: 8),
                                  ],
                                ),
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: responseDetails!.showButton &&
                                          responseDetails!.requestStatus !=
                                              "10" &&
                                          responseDetails!.requestStatus != "11"
                                      ? buildStartButton(
                                          context, responseDetails!.reqMasterId)
                                      : responseDetails!.requestStatus == "10"
                                          ? buildReachedButton(context,
                                              responseDetails!.reqMasterId)
                                          : responseDetails!.requestStatus ==
                                                  "11"
                                              ? buildNextButton(
                                                  context,
                                                  responseDetails!.reqMasterId,
                                                )
                                              : Container()),
                            ],
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future buildConfirmationPopUp({required String type}) async {
    await Alert(
      padding: EdgeInsets.only(top: 15),
      // image: ImageIcon(
      //   AssetImage(Assets.success),
      //   size: 95,
      //   color: Color(0xff68CE78).withOpacity(1.0),
      // ),
      closeIcon: Container(),

      context: context,
      // type: AlertType.success,
      // title: "RFLUTTER ALERT",
      desc: "Do you want to Continue?",
      style: AlertStyle(
          isOverlayTapDismiss: false,
          alertElevation: 1.0,
          alertPadding: EdgeInsets.symmetric(vertical: 200, horizontal: 50),
          overlayColor: Colors.transparent.withOpacity(0.4),
          constraints: BoxConstraints(maxHeight: 80, maxWidth: 324),
          // alertPadding: EdgeInsets.only(top: 30),
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23),
            side: BorderSide(
              color: Colors.white10,
            ),
          ),
          // alertBorder: Border(top: BorderSide(color: Colors.white)),
          descStyle: kTitiliumWebLeftSideSemiBoldText1),
      buttons: [
        DialogButton(
          height: 36.0,
          radius: BorderRadius.circular(12),
          child: Text(
            "Cancel",
            style: kSuccessAlertButtonStyle,
          ),
          onPressed: () => Navigator.of(context).pop(),
          width: 95,
          color: Color(0xff68CE78).withOpacity(1.0),
        ),
        DialogButton(
          height: 36.0,
          radius: BorderRadius.circular(12),
          child: Text(
            "OK",
            style: kSuccessAlertButtonStyle,
          ),
          onPressed: () {
            setState(() {
              loading = true;
            });
            if (type == phleboTravellingStarted) {
              testRequestBloc.updateTravelingStatus(
                  request: UpdateTravelStatusRequest(
                      requestStatus: "10",
                      reqMasterId:
                      widget.getSingleRequestDetailsRequest.requestId,
                      districtId: ObjectFactory()
                          .prefs
                          .getPhleboData()!
                          .response!
                          .phlebotomistDistrictId,
                      longitude:
                      widget.getSingleRequestDetailsRequest.longitude,
                      latitude: widget.getSingleRequestDetailsRequest.latitude,
                      phlebotomistId: ObjectFactory()
                          .prefs
                          .getPhleboData()!
                          .response!
                          .phlebotomistId));
            } else if (type == phleboTravellingReached) {
              testRequestBloc.updateTravelingStatus(
                  request: UpdateTravelStatusRequest(
                      requestStatus: "11",
                      reqMasterId:
                          widget.getSingleRequestDetailsRequest.requestId,
                      districtId: ObjectFactory()
                          .prefs
                          .getPhleboData()!
                          .response!
                          .phlebotomistDistrictId,
                      longitude:
                          widget.getSingleRequestDetailsRequest.longitude,
                      latitude: widget.getSingleRequestDetailsRequest.latitude,
                      phlebotomistId: ObjectFactory()
                          .prefs
                          .getPhleboData()!
                          .response!
                          .phlebotomistId));
            }
            Navigator.of(context).pop();
            // testRequestBloc.assignedToPhlebo(
            //   request: AssignedToPhleboRequest(
            //       reqMasterId: requestList[index].reqMasterId,
            //       phlebotomistId: ObjectFactory()
            //           .prefs
            //           .getPhleboData()!
            //           .response!
            //           .phlebotomistId,
            //       pageNo: "1",
            //       latitude: latLng.latitude.toString(),
            //       longitude: latLng.longitude.toString(),
            //       districtId: ObjectFactory()
            //           .prefs
            //           .getPhleboData()!
            //           .response!
            //           .phlebotomistDistrictId),
            // );
            // Navigator.of(context).pop();
            // setState(() {
            //   loading = true;
            // });
          },
          width: 95,
          color: Color(0xff68CE78).withOpacity(1.0),
        ),
      ],
    ).show();
  }

  ///Reschedule Success pop up Method
  ///
  Future buildSuccessPopUp() async {
    await Alert(
      padding: EdgeInsets.only(top: 15),
      image: ImageIcon(
        AssetImage('assets/images/success.png'),
        size: 95,
        color: Color(0xff68CE78).withOpacity(1.0),
      ),
      closeIcon: Container(),

      context: context,
      // type: AlertType.success,
      // title: "RFLUTTER ALERT",
      desc: "The Request is Successfully\nRescheduled.",
      style: AlertStyle(
          isOverlayTapDismiss: false,
          alertElevation: 1.0,
          alertPadding: EdgeInsets.symmetric(vertical: 200, horizontal: 50),
          overlayColor: Colors.transparent.withOpacity(0.4),
          constraints: BoxConstraints(maxHeight: 80, maxWidth: 324),
          // alertPadding: EdgeInsets.only(top: 30),
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23),
            side: BorderSide(
              color: Colors.white10,
            ),
          ),
          // alertBorder: Border(top: BorderSide(color: Colors.white)),
          descStyle: kTitiliumWebLeftSideSemiBoldText1),
      buttons: [
        DialogButton(
          height: 36.0,
          radius: BorderRadius.circular(12),
          child: Text(
            "OK",
            style: kSuccessAlertButtonStyle,
          ),
          onPressed: () => Navigator.pop(context),
          width: 95,
          color: Color(0xff68CE78).withOpacity(1.0),
        )
      ],
    ).show();
  }

  ///Assigned Pop up Alert Method
  ///
  Future buildAssignedAlertPopUp() async {
    await Alert(
      // type: AlertType.none,
      padding: EdgeInsets.only(top: 10),
      image: Image.asset(
        'assets/images/already assigned.png',
        height: 122,
        width: 160,
        fit: BoxFit.cover,
      ),

      closeIcon: Container(),

      context: context,
      // type: AlertType.success,
      // title: "RFLUTTER ALERT",
      desc: "The Request is Successfully\nRescheduled.",
      style: AlertStyle(
          isOverlayTapDismiss: false,
          alertElevation: 1.0,
          alertPadding: EdgeInsets.symmetric(vertical: 200, horizontal: 50),
          overlayColor: Colors.transparent.withOpacity(0.4),
          constraints: BoxConstraints(maxHeight: 80, maxWidth: 324),
          // alertPadding: EdgeInsets.only(top: 30),
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23),
            side: BorderSide(
              color: Colors.white10,
            ),
          ),
          // alertBorder: Border(top: BorderSide(color: Colors.white)),
          descStyle: kTitiliumWebLeftSideSemiBoldText1),
      buttons: [
        DialogButton(
          height: 36.0,
          radius: BorderRadius.circular(12),
          child: Text(
            "OK",
            style: kSuccessAlertButtonStyle,
          ),
          onPressed: () => Navigator.pop(context),
          width: 95,
          color: Color(0xffF27373).withOpacity(1.0),
        )
      ],
    ).show();
  }

  ///Reached  button widget
  Widget buildReachedButton(BuildContext context, String reqMasterId) {
    return Padding(
      padding: EdgeInsets.zero,
      child: ElevatedButton(
        child: Text(
          'Reached',
          style: kReachedButtonStyle,
        ),
        onPressed: () {
          buildConfirmationPopUp(
            type: phleboTravellingReached,
          );
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 50),
          primary: Color(0xff5AC96B).withOpacity(1.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
      ),
    );
    //   RoundedEdgeButton(
    //   context: context,
    //   buttonText: 'Reached',
    //   buttonColor: Color(0xff5AC96B).withOpacity(1.0), onPressedCallBack: () => Navigator.of(context),
    // );
  }

  Widget buildStartButton(BuildContext context, String reqMasterId) {
    return Padding(
      padding: EdgeInsets.zero,
      child: ElevatedButton(
        child: Text(
          'Start',
          style: kReachedButtonStyle,
        ),
        onPressed: () {
          buildConfirmationPopUp(
            type: phleboTravellingStarted,
          );
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 50),
          primary: Color(0xff5AC96B).withOpacity(1.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
      ),
    );
    //   RoundedEdgeButton(
    //   context: context,
    //   buttonText: 'Reached',
    //   buttonColor: Color(0xff5AC96B).withOpacity(1.0), onPressedCallBack: () => Navigator.of(context),
    // );
  }

  Widget buildNextButton(BuildContext context, String reqMasterId) {
    return Padding(
      padding: EdgeInsets.zero,
      child: ElevatedButton(
        child: Text(
          'Next',
          style: kReachedButtonStyle,
        ),
        onPressed: () {
          if (skipInput) {
            Navigator.pushNamed(context, "/payment",
                arguments: PaymentScreenArguments(
                    requestId: reqMasterId,
                    totalAmount: paymentDetails!.districtRtpcrPrice,
                    qrUrl: paymentDetails!.districtUpiQrCode));
          } else {
            Navigator.pushNamed(context, "/userInput",
                arguments: UserInputDataScreenArguments(
                    requestID: reqMasterId, list: uidList!,totalAmount: paymentDetails!.districtRtpcrPrice,name: responseDetails!.fullName,
                ));
          }

          // Navigator.pushNamed(context, "/userInput");
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => PaymentMethodScreen(
          //           notifyParent: (value) {
          //             refreshAddressScreen(value);
          //           },
          //           loading: loading,
          //         )));
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 50),
          primary: Color(0xff5AC96B).withOpacity(1.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
      ),
    );
    //   RoundedEdgeButton(
    //   context: context,
    //   buttonText: 'Reached',
    //   buttonColor: Color(0xff5AC96B).withOpacity(1.0), onPressedCallBack: () => Navigator.of(context),
    // );
  }

  /// Reshedule and On hold alert dialog  box
  showAlertDialog(BuildContext context) {
    AlertDialog addShiftAlert = AlertDialog(
      elevation: 1.0,
      contentPadding: EdgeInsets.all(10),
      insetPadding: EdgeInsets.only(left: 80, top: 95, right: 0, bottom: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // title: Text("Add new shift"),
      content: AlertDialogContent(context),
    );

    showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 250, maxWidth: 280),
              child: addShiftAlert,
            ),
          ],
        ),
      ),
    );
  }

  /// Show_Modal_Bottom_Sheet

  Column AlertDialogContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        InkWell(
          // focusColor: Colors.transparent,
          // hoverColor: Colors.transparent,
          // splashColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Reschedule",
                  style: kTitiliumWebLeftSideSemiBoldText1,
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.pop(context);
            // FocusScope.of(context).unfocus();
            // FocusScope.of(context).requestFocus(new FocusNode());

            showModalBottomSheet<void>(
                enableDrag: true,
                elevation: 1.0,
                isDismissible: true,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter myState) {
                        return Container(
                          height: 348,
                          width: 428,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(1.0),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: ImageIcon(
                                          AssetImage(Assets.closeIcon),
                                          color: Color(0xffFA5757),
                                          size: 20,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      flex: 5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: kMainThemeColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 44,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: TextField(
                                          keyboardType: TextInputType.none,
                                          showCursor: false,
                                          enableInteractiveSelection: false,
                                          onTap: () {
                                            myState(() {
                                              _selectRescheduleDate(context);
                                            });
                                          },
                                          onChanged: (newDateValue) {
                                            myState(() {
                                              newDateValue = newDatePicked!;
                                            });
                                          },
                                          controller:
                                              rescheduleDatePickerController,
                                          // enabled: true,
                                          maxLines: null,
                                          // textAlignVertical: TextAlignVertical.top,
                                          obscureText: false,

                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.all(8),
                                              suffixIconConstraints:
                                                  BoxConstraints(
                                                      maxWidth: 20,
                                                      maxHeight: 20),
                                              suffixIcon: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: ImageIcon(AssetImage(
                                                    Assets.downArrowIcon)),
                                              ),
                                              labelText: 'Select date',
                                              labelStyle: kTextFieldTextStyle),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),

                                    ///Time Picker TextField///
                                    ///
                                    ///
                                    Flexible(
                                      flex: 3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: kMainThemeColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 44,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: TextField(
                                          keyboardType: TextInputType.none,
                                          enableInteractiveSelection: false,
                                          showCursor: false,
                                          onTap: () {
                                            myState(() {
                                              _selectRescheduleTime(context);
                                            });
                                          },
                                          onChanged: (newTimeValue) {
                                            myState(() {
                                              newTimeValue = newTimePicked!;
                                            });
                                          },
                                          controller:
                                              rescheduleTimePickerController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(8),
                                            suffixIconConstraints:
                                                BoxConstraints(
                                                    maxWidth: 20,
                                                    maxHeight: 20),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: ImageIcon(AssetImage(
                                                  Assets.downArrowIcon)),
                                            ),
                                            border: InputBorder.none,
                                            labelText: 'Select time',
                                            labelStyle: kTextFieldTextStyle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kMainThemeColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 110,
                                  width: 378,
                                  child: TextField(
                                    textInputAction: TextInputAction.done,
                                    textAlignVertical: TextAlignVertical.top,
                                    maxLines: 10,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8),
                                      suffixIconConstraints: BoxConstraints(
                                          maxWidth: 20, maxHeight: 20),
                                      // suffixIcon: Padding(
                                      //   padding: EdgeInsets.only(right: 10.0),
                                      //   child: Icon(Icons.arrow_drop_down),
                                      // ),
                                      border: InputBorder.none,
                                      labelText: 'Reason',
                                      labelStyle: kTextFieldTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 60),

                              ///Rescheduled  button with pop-up alert
                              Flexible(
                                // flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.zero,
                                  child: ElevatedButton(
                                    child: Text(
                                      'Reschedule',
                                      style: kReachedButtonStyle,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);

                                      // buildSuccessPopUp();
                                      buildAssignedAlertPopUp();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width,
                                          58),
                                      primary:
                                          Color(0xff26ABE2).withOpacity(1.0),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                });
          },
        ),
        SizedBox(height: 10),
        Divider(
          color: Color(0xff707070),
          thickness: 0.1,
        ),
        SizedBox(height: 10),

        ///On hold OnTap with Show_Modal_Bottom_Sheet
        ///
        ///

        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                child: Text(
                  "On Hold",
                  style: kTitiliumWebLeftSideSemiBoldText1,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // FocusScope.of(context).unfocus();
                  // FocusScope.of(context).requestFocus(new FocusNode());

                  showModalBottomSheet<void>(
                      enableDrag: true,
                      elevation: 1.0,
                      isDismissible: true,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter myState) {
                              return Container(
                                height: 300,
                                width: 428,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(1.0),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: ImageIcon(
                                                AssetImage(Assets.closeIcon),
                                                color: Color(0xffFA5757),
                                                size: 18,
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: kMainThemeColor),
                                        ),
                                        height: 150,
                                        width: 378,
                                        child: TextField(
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          textInputAction: TextInputAction.done,
                                          maxLines: 13,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(8),
                                            suffixIconConstraints:
                                                BoxConstraints(
                                                    maxWidth: 20,
                                                    maxHeight: 20),
                                            // suffixIcon: Padding(
                                            //   padding: EdgeInsets.only(right: 10.0),
                                            //   child: Icon(Icons.arrow_drop_down),
                                            // ),
                                            border: InputBorder.none,
                                            labelText: 'Reason',
                                            labelStyle: kTextFieldTextStyle,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 40),

                                    ///On Hold Elevated Button with Pop-up alert

                                    Flexible(
                                      // flex: 3,
                                      child: Padding(
                                        padding: EdgeInsets.zero,
                                        child: ElevatedButton(
                                          child: Text(
                                            'On Hold',
                                            style: kReachedButtonStyle,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            buildSuccessPopUp();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                58),
                                            primary: Color(0xff26ABE2)
                                                .withOpacity(1.0),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // RoundedEdgeButton(
                                      //   context: context,
                                      //   buttonText: 'Reschedule',
                                      //   buttonColor: Color(0xff26ABE2).withOpacity(1.0),
                                      //   onPressedCallBack: () => buildRescheduledSuccessPopUp(),
                                      // ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
