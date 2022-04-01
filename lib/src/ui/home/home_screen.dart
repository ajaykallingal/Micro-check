import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:location/location.dart';
import 'package:micro_check/src/common/styles.dart';
import 'package:micro_check/src/constants/assets.dart';
import 'package:micro_check/src/constants/colors.dart';
import 'package:micro_check/src/constants/strings.dart';
import 'package:micro_check/src/data/bloc/master_bloc.dart';
import 'package:micro_check/src/data/bloc/test_request_bloc.dart';
import 'package:micro_check/src/data/model/assigned_to_phlebo/assigned_to_phlebo_request.dart';
import 'package:micro_check/src/data/model/latlng.dart';
import 'package:micro_check/src/data/model/online/online_status_phlebo_request.dart';
import 'package:micro_check/src/data/model/test_request/assigned_request.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_request.dart';
import 'package:micro_check/src/data/model/test_request/pending_request.dart';
import 'package:micro_check/src/data/model/test_request/test_response.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';
import 'package:micro_check/src/data/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final LatLng latLng;
  const HomeScreen({Key? key,required this.latLng}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late var _controller = ValueNotifier<bool>(false);

  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  bool positionStreamStarted = false;

  late Size _screenSize;
  bool assignedSelected = true;
  bool loading = true;
  bool statusLoading = false;
  bool assignedRequestFetched = false;
  Location location = Location();
  late bool serviceEnabled;
  late PermissionStatus permissionStatus;
  late LocationData locationData;
  late LatLng latLng;
  LocationData? lastSavedLocation;

  final testRequestBloc = TestRequestBloc();
  final masterBloc = MasterBloc();
  List<Response> requestList = List.empty(growable: true);

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    testRequestBloc.getTestRequestResponseSCListener.listen((event) {
      setState(() {
        loading = false;
        if(assignedSelected){
          assignedRequestFetched = true;
        }else{
          assignedRequestFetched = false;
        }
        requestList = event.response!;
      });
    });
    testRequestBloc.onlineStatusPhleboSCListener.listen((event) {
      if(statusLoading) {
        setState(() {
          statusLoading = false;
          ObjectFactory().prefs.setIsPhleboOnline(event.response);
          // _controller = ValueNotifier<bool>(event.response);
          fetchLocationFun(isAssignedSelected: assignedSelected);
          loading = true;
          showToast(event.message);
        });
      }
    });
    testRequestBloc.assignedToPhleboSCListener.listen((event) {
      if (event.response) {
        setState(() {
          loading=false;
          requestList = event.pendingRequestList!;
        });
      }
    });

    super.didChangeDependencies();
  }

  fetchLocationFun({required bool isAssignedSelected}) async {

    if (isAssignedSelected) {
      await testRequestBloc.assignedTestRequest(
          request: GetAssignedRequest(
              phlebotomistId: ObjectFactory()
                  .prefs
                  .getPhleboData()!
                  .response!
                  .phlebotomistId,
              districtID: ObjectFactory()
                  .prefs
                  .getPhleboData()!
                  .response!
                  .phlebotomistDistrictId,
              latitude: latLng.latitude.toString(),
              longitude: latLng.longitude.toString(),
              pageNo: "1"));
    } else {
      await testRequestBloc.pendingTestRequest(
          request: PendingTestRequest(
              latitude: latLng.latitude.toString(),
              longitude: latLng.longitude.toString(),
              pageNo: "1",
              districtId: ObjectFactory()
                  .prefs
                  .getPhleboData()!
                  .response!
                  .phlebotomistDistrictId));
    }
    locationData = await location.getLocation();
    setState(() {
      latLng = LatLng(latitude: locationData.latitude!, longitude: locationData.longitude!);
      print(latLng.longitude);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    latLng =widget.latLng;
    _controller = ValueNotifier<bool>(ObjectFactory().prefs.isPhleboOnline()!);
    if (ObjectFactory().prefs.isPhleboOnline()!) {
      fetchLocationFun(isAssignedSelected: true);
    }
    _controller.addListener(() {
      setState(() {

          if (_controller.value) {
            statusLoading = true;
            testRequestBloc.onlineStatusPhlebo(
                request: OnlineStatusPhleboRequest(
                    phleboId: ObjectFactory()
                        .prefs
                        .getPhleboData()!
                        .response!
                        .phlebotomistId,
                    phlebotomistWorkStatus: true));
          } else {
            statusLoading = true;
            testRequestBloc.onlineStatusPhlebo(
                request: OnlineStatusPhleboRequest(
                    phleboId: ObjectFactory()
                        .prefs
                        .getPhleboData()!
                        .response!
                        .phlebotomistId,
                    phlebotomistWorkStatus: false));
          }

      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    testRequestBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    print(_screenSize.height * .15);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: _screenSize.height * .09,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {

                    buildLogoutPopUp();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Worksheet",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Text(
                      "v1.0.1",
                      style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          // fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),

                  ],
                ),
                statusLoading
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )))
                    : AdvancedSwitch(
                        controller: _controller,enabled: requestList.isEmpty && assignedRequestFetched || (ObjectFactory().prefs.isPhleboOnline()!)==false? true:false,
                        height: 30,
                        width: 65,
                        activeColor: Colors.green.withOpacity(1),
                        inactiveColor: Colors.grey.withOpacity(1),
                        activeChild: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(
                            'Online',
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                        inactiveChild: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(
                            'Offline',
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 10,

                              fontWeight: FontWeight.w700,
                              // color: Colors.grey,
                            ),
                          ),
                        ),
                        // inactiveColor: Color(0xFFEBEBEB).withOpacity(1.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
              ],
            ),
          ),
          getScrollableBody(),
          Positioned(
            top: _screenSize.height * .17,
            left: 0,
            right: 0,
            child: Row(
              children: [
                buildTab(
                    text: Strings.assigned,
                    icon: Assets.assigned,
                    voidCallback: () {},
                    left: true),
                buildTab(
                    text: Strings.pending,
                    icon: Assets.pending,
                    voidCallback: () {},
                    left: false),
              ],
            ),
          ),
          ObjectFactory().prefs.isPhleboOnline()!
              ? Container()
              : Positioned(
                  bottom: 0,
                  top: _screenSize.height * .17,
                  right: 0,
                  left: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: Center(
                      child: Text(
                        "Please be Online to\n view requests.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(ObjectFactory().prefs.isPhleboOnline()!) {
            Navigator.pushNamed(context, "/addNewRequest");
          }
          else{
            showToast("Please be online to add request");
          }
        },
        child: Image.asset(
          Assets.addNewIcon,
          scale: 4,
        ),
        backgroundColor: AppColors.buttonColor,
      ),
    );
  }

  Widget buildTab(
      {required String text,
      required String icon,
      required VoidCallback voidCallback,
      required bool left}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (!loading) {
              if (text == Strings.pending) {
                if (assignedSelected) {
                  fetchLocationFun(isAssignedSelected: false);
                  setState(() {
                    loading = true;
                    assignedSelected = false;
                  });
                }
              } else {
                if (!assignedSelected) {
                  fetchLocationFun(isAssignedSelected: true);
                  setState(() {
                    loading = true;
                    assignedSelected = true;
                  });
                }
              }
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: left ? Radius.circular(25) : Radius.circular(25),
                bottomLeft: left ? Radius.circular(25) : Radius.circular(25),
                bottomRight: left ? Radius.circular(25) : Radius.circular(25),
                topRight: left ? Radius.circular(25) : Radius.circular(25)),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: assignedSelected && text == Strings.assigned
                          ? AppColors.buttonColor
                          : !assignedSelected && text == Strings.pending
                              ? AppColors.buttonColor
                              : Colors.grey,
                      // child: Center(child: Image.asset(icon,scale: 2,)),
                      child: Center(
                          child: Image.asset(
                        icon,
                        scale: 2,
                      )),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      color: assignedSelected && text == Strings.assigned
                          ? AppColors.buttonColor
                          : !assignedSelected && text == Strings.pending
                          ? AppColors.buttonColor
                          : Colors.grey,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text(
                            text,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getScrollableBody() {
    return Positioned(
      bottom: 0,
      top: _screenSize.height * .17,
      right: 0,
      left: 0,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [BoxShadow(color: Colors.black26,offset: Offset(-1, -1),spreadRadius: 1,blurRadius: 12),]),
        child: Column(
          children: [
            Container(
              height: 100,
              // child: Align(
              //   alignment: Alignment.topLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left:18.0),
              //     child: Row(children: [Text(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString())],),
              //   ),),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: !loading
                    ? requestList.length > 0
                        ? Column(
                            children: List.generate(requestList.length,
                                (index) => buildRequest(index)),
                          )
                        : SizedBox(
                            height: 300,
                            child: Center(
                              child: Text("No Data"),
                            ))
                    : ObjectFactory().prefs.isPhleboOnline()!
                        ? SizedBox(
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ))
                        : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRequest(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 8, top: 8),
      child: GestureDetector(
        onTap: () {
          if (assignedSelected) {
            Navigator.pushNamed(context, "/requestDetails",
                arguments: GetSingleRequestDetailsRequest(
                    districtId: ObjectFactory()
                        .prefs
                        .getPhleboData()!
                        .response!
                        .phlebotomistDistrictId,
                    phlebotomistId: ObjectFactory()
                        .prefs
                        .getPhleboData()!
                        .response!
                        .phlebotomistId,
                    requestId: requestList[index].reqMasterId,
                    latitude: latLng.latitude.toString(),
                    longitude:latLng.longitude.toString())).then((value) =>  fetchLocationFun(isAssignedSelected: true));
          }
        },
        child: Container(
          height: assignedSelected
              ? requestList[index].airportPassenger == "0"
                  ?requestList[index].requestStatus=="10"?160 :125
                  :requestList[index].requestStatus=="10"?200 :165
              : 170,
          width: _screenSize.width,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: const BoxDecoration(
                            color: AppColors.airportPassengerColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 20),
                            child: Row(
                              children: [
                                Image.asset(
                                  Assets.roundIcon,
                                  scale: 2,
                                ),
                                // Icon(Icons.countertops),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Airport Passenger",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        decoration: const BoxDecoration(
                            color: AppColors.travelingColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20))),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Image.asset(Assets.blinking),
                                Image.asset(
                                  Assets.traveling,
                                  scale: 3,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Traveling....",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: assignedSelected,
                child: Align(
                  alignment:requestList[index].requestStatus=="10" &&
                      requestList[index].airportPassenger == "1"
                      ?Alignment.center:requestList[index].requestStatus=="10"?Alignment.topCenter :requestList[index].airportPassenger=="1"?Alignment.bottomCenter:Alignment.center,
                  child: Container(
                    height: 125,
                    width: _screenSize.width,
                    decoration: BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        border: Border.all(color: Colors.grey, width: .3),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildRow(
                            column1title: Strings.nameTitle,
                            column2title: Strings.preferredTitle,
                            column1Body: requestList[index].fullName,
                            column2Body:
                                requestList[index].preferredDate.toString(),
                            index: index),
                        buildRow(
                            column1title: Strings.phoneTitle,
                            column2title: Strings.distanceTitle,
                            column1Body: requestList[index].phoneNoInp,
                            column2Body: requestList[index]
                                    .distanceInKm
                                     +
                                " km",
                            index: index),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !assignedSelected,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: assignedSelected
                        ? _screenSize.height * .225
                        : _screenSize.height * .275,
                    width: _screenSize.width,
                    decoration: BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        border: Border.all(color: Colors.grey, width: .3),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildRow(
                            column1title: Strings.nameTitle,
                            column2title: Strings.preferredTitle,
                            column1Body: requestList[index].fullName,
                            column2Body:
                                requestList[index].preferredDate.toString(),
                            index: index),
                        buildRow(
                            column1title: Strings.phoneTitle,
                            column2title: Strings.distanceTitle,
                            column1Body: requestList[index].phoneNoInp,
                            column2Body: requestList[index]
                                    .distanceInKm
                                  +
                                " km",
                            index: index),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: GestureDetector(
                            onTap: () {
                              buildConfirmationPopUp(index);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: AppColors.assignedButtonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  "Assigned To Me",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future buildConfirmationPopUp(int index) async {
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
            testRequestBloc.assignedToPhlebo(
              request: AssignedToPhleboRequest(
                  reqMasterId: requestList[index].reqMasterId,
                  phlebotomistId: ObjectFactory()
                      .prefs
                      .getPhleboData()!
                      .response!
                      .phlebotomistId,
                  pageNo: "1",
                  latitude: latLng.latitude.toString(),
                  longitude: latLng.longitude.toString(),
                  districtId: ObjectFactory()
                      .prefs
                      .getPhleboData()!
                      .response!
                      .phlebotomistDistrictId),
            );
            Navigator.of(context).pop();
            setState(() {
              loading = true;
            });
          },
          width: 95,
          color: Color(0xff68CE78).withOpacity(1.0),
        ),
      ],
    ).show();
  }

  Future buildLogoutPopUp() async {
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
      desc: "Do you want to Logout?",
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
            "Logout",
            style: kSuccessAlertButtonStyle,
          ),
          onPressed: () {
            if(assignedSelected) {
              if (requestList.isEmpty &&
                  ObjectFactory().prefs.isPhleboOnline()! &&
                  assignedRequestFetched) {
                testRequestBloc.onlineStatusPhlebo(
                    request: OnlineStatusPhleboRequest(
                        phleboId: ObjectFactory()
                            .prefs
                            .getPhleboData()!
                            .response!
                            .phlebotomistId,
                        phlebotomistWorkStatus: false));
                ObjectFactory().prefs.clearPrefs();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (route) => false);
              }
              else {
                showToast("Please complete assigned task before go offline");
              }
            }else{
              showToast("please check do you have active request..");
              Navigator.of(context).pop();
            }
          },
          width: 95,
          color: Color(0xff68CE78).withOpacity(1.0),
        ),
      ],
    ).show();
  }

  Row buildRow(
      {required String column1title,
      required String column2title,
      required String column1Body,
      required String column2Body,
      required int index}) {
    return Row(
      children: [
        buildColumn(
            title: column1title,
            body: column1Body,
            alignedToLeft: true,
            index: index),
        buildColumn2(
            title: column2title,
            body: column2Body,
            alignedToLeft: false,
            index: index),
      ],
    );
  }

  Expanded buildColumn({
    required String title,
    required String body,
    required bool alignedToLeft,
    required int index,
  }) {
    return Expanded(
        flex: 11,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child:  Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.titleColor,)),
              Text(body,overflow: TextOverflow.ellipsis,softWrap: true,maxLines: 2,
                  style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
        ));
  }

  Future<void> launchURL(String url) async {
    print("phone clicked");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> openMap(
      {required double latitude, required double longitude}) async {
    print("map clicked");

    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Expanded buildColumn2(
      {required String title,
      required String body,
      required bool alignedToLeft,
      required int index}) {
    return Expanded(
        flex: 9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,overflow: TextOverflow.ellipsis,softWrap: true,maxLines: 1,
                  style: title == Strings.preferredTitle
                      ? TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.titleColor)
                      : TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.titleColor)),
              Text(body,overflow: TextOverflow.ellipsis,softWrap: true,maxLines: 2,
                  style: title == Strings.preferredTitle
                      ? TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.dateColor)
                      : TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ));
  }

  Widget buildIconButton(
      {required String icon,
      required VoidCallback voidCallback,
      required String text}) {
    return GestureDetector(
      onTap: voidCallback,
      child: Container(
          decoration: BoxDecoration(
              color: AppColors.buttonColor,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset(
                    icon,
                    scale: 3,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
