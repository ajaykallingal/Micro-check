import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:micro_check/src/common/styles.dart';
import 'package:micro_check/src/constants/assets.dart';
import 'package:micro_check/src/constants/colors.dart';
import 'package:micro_check/src/constants/strings.dart';
import 'package:micro_check/src/data/bloc/test_request_bloc.dart';
import 'package:micro_check/src/data/model/add_new_test/add_new_test_request.dart';
import 'package:micro_check/src/data/model/latlng.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_request.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';
import 'package:micro_check/src/data/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddNewRequestScreen extends StatefulWidget {
  const AddNewRequestScreen({Key? key}) : super(key: key);

  @override
  _AddNewRequestScreenState createState() => _AddNewRequestScreenState();
}

class _AddNewRequestScreenState extends State<AddNewRequestScreen> {
  late Size _screenSize;
  bool assignedSelected = true;
  String? _dropDownValue;
  File? imageFile;
  String? base64Image;
  List<String> timeSlotList = List.empty(growable: true);
  List<String> nameTitleList = ["Mr", "Mrs", "Ms", "Miss"];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _preferredDateController =
      TextEditingController();
  final TextEditingController _timeSlotController = TextEditingController();
  final TextEditingController _travelDateController = TextEditingController();
  final TextEditingController _traveltimeController = TextEditingController();
  final TextEditingController _flightNoController = TextEditingController();
  final TextEditingController _travelDestinationController =
      TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  TextEditingController _whatsAppNoController = TextEditingController();
  String barcodeText = "test";
  String uidType = "0";
  String datePicker = "DatePicker";
  String timeSlot = "timeSlot";
  String timePicker = "TimePicker";
  String nameTitleDropdown = "NAME_TITLE";
  String genderDropdown = "GENDER";
  String dobDropdown = "DOB";
  bool isAirportUser = false;
  bool isRtpcr = true;
  bool updateOnWhatsApp = false;

  bool loading = false;
  bool loadingForBarcode = false;
  bool listenUpdateDetails = false;

  LocationData? locationData;
  Location location = Location();
  late PermissionStatus permissionStatus;
  late LatLng latLng;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    testRequestBloc.addNewTestSCListener.listen((event) {
      if (listenUpdateDetails) {
        setState(() {
          listenUpdateDetails = false;
          loading = false;
        });
        if (event.response!.insertResponse) {
          // Navigator.of(context).pop();
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false,
              arguments: LatLng(
                  latitude: latLng.latitude, longitude: latLng.longitude));
          showToast("Request added");

          // Navigator.pushReplacementNamed(context, "/requestDetails",
          //     arguments: GetSingleRequestDetailsRequest(
          //         districtId: ObjectFactory()
          //             .prefs
          //             .getPhleboData()!
          //             .response!
          //             .phlebotomistDistrictId,
          //         phlebotomistId: ObjectFactory()
          //             .prefs
          //             .getPhleboData()!
          //             .response!
          //             .phlebotomistId,
          //         requestId: event.response!.lastInsertedId.toString(),
          //         latitude: latLng.latitude.toString(),
          //         longitude: latLng.longitude.toString()));
        } else {
          showToast("Error occured !!!");
          setState(() {
            listenUpdateDetails = false;
            loading = false;
          });
        }
      }
    }).onError((handleError) {
      showToast("Connection Timeout");
      setState(() {
        listenUpdateDetails = false;
        loading = false;
      });
    });

    super.didChangeDependencies();
  }

  final testRequestBloc = TestRequestBloc();

  @override
  void initState() {
    // TODO: implement initState
    fetchLocationFun();
    super.initState();
  }

  fetchLocationFun() async {
    locationData = await location.getLocation();
    setState(() {
      latLng = LatLng(
          latitude: locationData!.latitude!,
          longitude: locationData!.longitude!);
    });
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
    // print(_screenSize.height * .15);
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
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Add New",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  Container(
                    width: 60,
                  )
                ],
              ),
            ),
            getScrollableBody(),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  buildTab(
                      text: Strings.assigned,
                      icon: Assets.assigned,
                      voidCallback: () {
                        if (_nameController.text.isEmpty) {
                          showToast("Please enter your name");
                        } else if (_phoneNoController.text.isEmpty) {
                          showToast("Please enter your phone number");
                        } else if (_phoneNoController.text.isNotEmpty &&
                            _phoneNoController.text.length != 10) {
                          showToast("Please enter a valid phone number");
                        } else if (_addressController.text.isEmpty) {
                          showToast("Please enter address");
                        } else if (_pincodeController.text.isEmpty) {
                          showToast("Please enter PinCode");
                        } else if (_travelDateController.text.isEmpty &&
                            isAirportUser) {
                          showToast("Please select travel time");
                        } else if (_traveltimeController.text.isEmpty &&
                            isAirportUser) {
                          showToast("Please enter travel time");
                        } else if (_travelDestinationController.text.isEmpty &&
                            isAirportUser) {
                          showToast("Please enter travel destination");
                        } else if (_whatsAppNoController.text.isEmpty &&
                            updateOnWhatsApp) {
                          showToast("Please enter whatsApp number");
                        }
                        // else if (_remarksController.text.isEmpty ) {
                        //   showToast("Please enter remarks");
                        // }
                        else {
                          buildConfirmationPopUp();
                        }
                      }),
                ],
              ),
            ),
            loadingForBarcode
                ? Positioned(
                    child: Container(
                    height: _screenSize.height,
                    width: _screenSize.width,
                    color: Colors.black45,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ))
                : Container()
          ],
        ));
  }

  Expanded buildTab(
      {required String text,
      required String icon,
      required VoidCallback voidCallback}) {
    return Expanded(
      child: SafeArea(
        child: GestureDetector(
          onTap: voidCallback,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: AppColors.nextButtonColor,
              ),
              child: Center(
                child: !loading
                    ? Text(
                        "Book Now",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22),
                      )
                    : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
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
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        buildTextField(
                            textEditingController: _nameController,
                            labelText: "Name*",
                            isNumber: false,
                            isEnabled: true),
                        buildTextField(
                            textEditingController: _phoneNoController,
                            labelText: "Phone Number*",
                            isNumber: true,
                            isEnabled: true),
                        buildTextFieldAddress(
                            textEditingController: _addressController,
                            labelText: "Address*",
                            isEnabled: true),
                        buildTextField(
                            textEditingController: _pincodeController,
                            labelText: "PinCode*",
                            isNumber: true,
                            isEnabled: true),
                        // buildTextFieldAddress(
                        //     textEditingController: _remarksController,
                        //     labelText: "Remarks*",
                        //     isEnabled: true),
                        // buildTextFieldWithDropDown(
                        //     textEditingController: _preferredDateController,
                        //     labelText: "Preferred Date for test*",
                        //     dropDownName: datePicker),
                        // buildTextFieldWithDropDown(
                        //     textEditingController: _timeSlotController,
                        //     labelText: "Choose your time slot*",
                        //     dropDownName: timeSlot),
                        SizedBox(
                          height: 15,
                        ),

                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Are you taking an RTPCR test?",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        child: isRtpcr
                                            ? Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: AppColors
                                                          .buttonColor),
                                                ),
                                                child: Image.asset(Assets.tick),
                                              )
                                            : Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: AppColors
                                                          .buttonColor),
                                                ),
                                              ),
                                        onTap: () {
                                          setState(() {
                                            isRtpcr = true;
                                            print(isRtpcr);
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text("Yes")
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isRtpcr = false;
                                            isAirportUser =false;
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          });
                                        },
                                        child: isRtpcr
                                            ? Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: AppColors
                                                          .buttonColor),
                                                ),
                                              )
                                            : Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: AppColors
                                                          .buttonColor),
                                                ),
                                                child: Image.asset(Assets.tick),
                                              ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "No",
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ) ,
                        SizedBox(height: 20),

                        isRtpcr ?




                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Are you taking an RTPCR test for Airport needs?",
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      children: [
                                        InkWell(
                                          child: isAirportUser
                                              ? Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(20)),
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors
                                                      .buttonColor),
                                            ),
                                            child: Image.asset(Assets.tick),
                                          )
                                              : Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(20)),
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors
                                                      .buttonColor),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              isAirportUser = true;
                                              print(isAirportUser);
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text("Yes")
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isAirportUser = false;
                                              print(isAirportUser);
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            });
                                          },
                                          child: isAirportUser
                                              ? Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(20)),
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors
                                                      .buttonColor),
                                            ),
                                          )
                                              : Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(20)),
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors
                                                      .buttonColor),
                                            ),
                                            child: Image.asset(Assets.tick),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "No",
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        :   Column(
                          children: [
                            buildTextField(
                                textEditingController: _remarksController,
                                labelText: "Remarks*",
                                isNumber: false,
                                isEnabled: true),
                          ],
                        ),
                    SizedBox(height: 20),




                    isAirportUser ?



                        //
                        Column(
                                children: [
                                  buildTextField(
                                      textEditingController:
                                          _flightNoController,
                                      labelText: "Flight No*",
                                      isNumber: false,
                                      isEnabled: true),
                                  buildTextFieldWithDropDown(
                                      textEditingController:
                                          _travelDateController,
                                      labelText: "Travel Date*",
                                      dropDownName: datePicker),
                                  buildTextFieldWithDropDown(
                                      textEditingController:
                                          _traveltimeController,
                                      labelText: "Travel Time*",
                                      dropDownName: timePicker),
                                  buildTextField(
                                      textEditingController:
                                          _travelDestinationController,
                                      labelText: "Travel Destination*",
                                      isNumber: false,
                                      isEnabled: true),
                                ],
                              ) : Container(),



                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Get Updates on WhatsApp",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    child: updateOnWhatsApp
                                        ? Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: AppColors.buttonColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors.buttonColor),
                                            ),
                                            child: Image.asset(Assets.tick),
                                          )
                                        : Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors.buttonColor),
                                            ),
                                          ),
                                    onTap: () {
                                      setState(() {
                                        updateOnWhatsApp = !updateOnWhatsApp;
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        updateOnWhatsApp
                            ? buildTextField(
                                textEditingController: _whatsAppNoController,
                                labelText: "WhatsApp Number*",
                                isNumber: true,
                                isEnabled: true)
                            : Container(),

                        SizedBox(
                          height: _screenSize.height * .1,
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

  Widget buildTextField(
      {required TextEditingController textEditingController,
      required String labelText,
      required bool isNumber,
      required bool isEnabled}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.buttonColor,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            enabled: isEnabled,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            controller: textEditingController,
            decoration: InputDecoration(
                border: InputBorder.none, label: Text(labelText)),
          ),
        ),
      ),
    );
  }

//   void _showPopupMenuUidType(Offset offset) async {
//     double left = offset.dx;
//     double top = offset.dy;
//     await showMenu(
//       context: context,
//       position: RelativeRect.fromLTRB(left, top, 0, 0),
//       items: List.generate(
//          timeSlotList.length,
//               (index) => PopupMenuItem(
//             value: timeSlotList[index],
//             child: Text(timeSlotList[index]),
//           )),
//       elevation: 8.0,
//     ).then((value) {
// // NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null
//
//       if (value != null) {
//         setState(() {
//           uidType = value;
//           // _uidTypeController.text=widget.arguments.list[int.tryParse(value)!].uidName;
//           _timeSlotController.text = timeSlot[widget.arguments.list
//               .indexWhere((element) => element.uidId == value)]
//               .uidName;
//         });
//       }
//     });
//   }
  Widget buildTextFieldAddress(
      {required TextEditingController textEditingController,
      required String labelText,
      required bool isEnabled}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.buttonColor,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            enabled: isEnabled,
            controller: textEditingController,
            minLines: 6,
            maxLines: 7,
            decoration: InputDecoration(
                border: InputBorder.none, label: Text(labelText)),
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldWithDropDown(
      {required TextEditingController textEditingController,
      required String labelText,
      required String dropDownName}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          if (dropDownName == timePicker) {
            DatePicker.showTimePicker(context,
                showSecondsColumn: false,
                showTitleActions: true,
                // minTime: DateTime(1900, 1, 1),
                // maxTime: DateTime.now(),
                theme: DatePickerTheme(
                    headerColor: AppColors.buttonColor,
                    backgroundColor: Colors.white,
                    itemStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    doneStyle: TextStyle(color: Colors.black87, fontSize: 16)),
                onChanged: (date) {}, onConfirm: (date) {
              setState(() {
                _traveltimeController.text = DateFormat('HH:MM').format(date);
                // _dobController.text = date.toString();
              });
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          } else if (dropDownName == datePicker) {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime.now(),
                maxTime: DateTime(2100, 1, 1),
                theme: DatePickerTheme(
                    headerColor: AppColors.buttonColor,
                    backgroundColor: Colors.white,
                    itemStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    doneStyle: TextStyle(color: Colors.black87, fontSize: 16)),
                onChanged: (date) {}, onConfirm: (date) {
              setState(() {
                _travelDateController.text =
                    DateFormat('yyyy-MM-dd').format(date);
                // _dobController.text = date.toString();
              });
            }, currentTime: DateTime.now(), locale: LocaleType.en);

            // _showPopupMenuNameTitle(details.globalPosition);
          }
          // else if(dropDownName == timeSlot){
          //   _showPopupMenuUidType(details.globalPosition);
          // }
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.buttonColor,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: textEditingController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none, label: Text(labelText)),
                  ),
                ),
              ),
              Flexible(child: Icon(Icons.arrow_drop_down))
            ],
          ),
          // child: Row(
          //   children: [
          //     Expanded(
          //       flex: 8,
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(horizontal:12.0),
          //         child: DropdownButton(
          //           hint: _dropDownValue == null
          //               ? Text(labelText)
          //               : Text(
          //             _dropDownValue!,
          //           ),
          //           isExpanded: false,underline: Container(),
          //           iconSize: 30.0,
          //           style: TextStyle(color: Colors.blue),
          //           items: ['One', 'Two', 'Three'].map(
          //                 (val) {
          //               return DropdownMenuItem<String>(
          //                 value: val,
          //                 child: Text(val),
          //               );
          //             },
          //           ).toList(),
          //           onChanged: (val) {
          //             setState(
          //                   () {
          //                 _dropDownValue = val.toString();
          //               },
          //             );
          //           },
          //         ),
          //       ),
          //     ),
          //     // Flexible(child: Icon(Icons.arrow_drop_down))
          //   ],
          // ),
        ),
      ),
    );
  }

  Future buildConfirmationPopUp() async {
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
            testRequestBloc.addNewTest(
              request: AddNewTestRequest(
                  fullName: _nameController.text,
                  contactNo: _phoneNoController.text,
                  address: _addressController.text,
                  pincode: _pincodeController.text,
                  latitude: latLng.latitude.toString(),
                  longitude: latLng.longitude.toString(),
                  zoomLevel: "4",
                  airportPassenger: isAirportUser ? "1" : "0",
                  flightNo: _flightNoController.text,
                  travelDate: _travelDateController.text,
                  travelTime: _traveltimeController.text,
                  travelDestination: _travelDestinationController.text,
                  districtId: ObjectFactory()
                      .prefs
                      .getPhleboData()!
                      .response!
                      .phlebotomistDistrictId,
                  dataFrom: "1",
                  phoneNoInp: _phoneNoController.text,
                  phlebotomistId: ObjectFactory()
                      .prefs
                      .getPhleboData()!
                      .response!
                      .phlebotomistId,
                      isRtpcr: isRtpcr ? "1" : "0",
                      remarks:  _remarksController.text,
              ),

            );

            setState(() {
              listenUpdateDetails = true;
              loading = true;
            });
            print(_remarksController.text);
            Navigator.of(context).pop();
          },
          width: 95,
          color: Color(0xff68CE78).withOpacity(1.0),
        ),
      ],
    ).show();
  }
}
