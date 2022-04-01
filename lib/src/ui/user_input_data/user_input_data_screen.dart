import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:micro_check/src/common/styles.dart';
import 'package:micro_check/src/constants/app_theme.dart';
import 'package:micro_check/src/constants/assets.dart';
import 'package:micro_check/src/constants/colors.dart';
import 'package:micro_check/src/constants/strings.dart';
import 'package:micro_check/src/data/bloc/test_request_bloc.dart';
import 'package:micro_check/src/data/model/test_request/local_body_fetch_request.dart';
import 'package:micro_check/src/data/model/test_request/local_body_fetch_response.dart';
import 'package:micro_check/src/data/model/test_request/update_test_details.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';
import 'package:micro_check/src/data/utils/utils.dart';
import 'package:micro_check/src/ui/payment/payment_screen_arguments.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'input_screen_argument_model.dart';
import 'local_body_argument_model.dart';

class UserInputDataScreen extends StatefulWidget {
  final UserInputDataScreenArguments arguments;

  const UserInputDataScreen({Key? key, required this.arguments})
      : super(key: key);

  @override
  _UserInputDataScreenState createState() => _UserInputDataScreenState();
}

class _UserInputDataScreenState extends State<UserInputDataScreen> {
  // LocalBodyArgument? localBodyArguments;

  late Size _screenSize;
  bool assignedSelected = true;
  String? _dropDownValue;
  File? imageFile;
  String? base64Image;
  List<String> nameTitleList = ["Mr", "Mrs", "Ms", "Miss"];
  List<LocalBodyList> localBodyLists = [];
  TextEditingController _barcodeController = TextEditingController();
  TextEditingController _uidTypeController = TextEditingController();
  TextEditingController _uidNumberController = TextEditingController();
  TextEditingController _nameTitleController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _localBodyTypeController = TextEditingController();
  TextEditingController _localBodyController = TextEditingController();
  TextEditingController _patientCategoryController = TextEditingController();
  String barcodeText = "test";
  String uidType = "0";
  String uidDropdown = "UID";
  String nameTitleDropdown = "NAME_TITLE";
  String genderDropdown = "GENDER";
  String dobDropdown = "DOB";
  String localBodyType = "0";
  String localBody = "LOCAL_BODY";
  String localBodyText = "";
  String localBodyTypeDropDown = "LOCAL_BODY_TYPE";
  String patientCategory = "PATIENT_CATEGORY";
  String patientCategoryId = "0";


  bool loading = false;
  bool loadingForLocalBodyList = false;
  bool loadingForBarcode = true;
  bool listenUpdateDetails = false;
  bool listenLocalBodyList = false;
  bool listenLocalBodyType = false;
  bool showLocalBodyListField = false;
  Response? responseDetails;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    print("barcode: " + barcodeScanRes);
    if (barcodeScanRes != "-1") {
      await testRequestBloc.verifyBarcode(barcode: barcodeScanRes);
      setState(() {
        barcodeText = barcodeScanRes;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  // Future<void> localBodyListFun() async {
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //
  //     testRequestBloc.localBodyFetchSCListener.listen((event) {
  //       localBodyList = event.localBodyList;
  //
  //     });
  //
  //
  //
  //
  //   } on PlatformException {
  //     // barcodeScanRes = 'Failed to get platform version.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //
  // }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    testRequestBloc.verifyBarcodeSCListener.listen((event) {
      if (event.response) {
        setState(() {
          _barcodeController.text = barcodeText;
          loadingForBarcode = false;
          showToast("Barcode Verified");
        });
      } else {
        scanBarcodeNormal();
        showToast("Barcode not Verified !!!");

        // setState(() {
        //   loading=false;
        // });
      }
    });

    testRequestBloc.localBodyFetchSCListener.listen((event) {
      setState(() {
        loading = false;
        listenLocalBodyList = false;
        _localBodyController.text = localBodyText;
        localBodyLists = event.localBodyList!;
        print(localBodyLists);

        // skipInput = event.skipInputDetails;
        // paymentDetails = event.paymentDetails;
      });
    });

    testRequestBloc.updateTestDetailsSCListener.listen((event) {
      if (listenUpdateDetails) {
        setState(() {
          listenUpdateDetails = false;
          loading = false;
        });
        if (event.response) {
          showToast("details updated");
          Navigator.pushReplacementNamed(context, "/payment",
              arguments: PaymentScreenArguments(
                  requestId: widget.arguments.requestID,
                  totalAmount: widget.arguments.totalAmount,
                  qrUrl: event.paymentLink));
        } else {
          showToast("Error occured !!!");
        }
      }
    });
    // testRequestBloc.localBodyFetchSCListener.listen((event) {
    //   if (listenUpdateDetails) {
    //     setState(() {
    //       listenUpdateDetails = false;
    //       loading = false;
    //     });
    //     if (event.response) {
    //       showToast("details updated");
    //       Navigator.pushReplacementNamed(context, "/payment",
    //           arguments: PaymentScreenArguments(
    //               requestId: widget.arguments.requestID,
    //               totalAmount: widget.arguments.totalAmount,
    //               qrUrl: event.paymentLink));
    //     } else {
    //       showToast("Error occured !!!");
    //     }
    //   }
    // });

    super.didChangeDependencies();
  }

  final testRequestBloc = TestRequestBloc();

  @override
  void initState() {
    // TODO: implement initState
    scanBarcodeNormal();
    _fullNameController.text = widget.arguments.name;
    // _remarksController.text = widget.arguments.remarks!;





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
                    "Update Details",
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
                        if (uidType == "0") {
                          showToast("Please select User ID");
                        } else if (imageFile == null) {
                          showToast("Please select an image");
                        }
                        // else if (_uidNumberController.text.isEmpty) {
                        //   showToast("Please enter UID number");
                        // }


                        else if (_nameTitleController.text.isEmpty) {
                          showToast("Please select name title");
                        } else if (_fullNameController.text.isEmpty) {
                          showToast("Please enter full name");
                        } else if (_genderController.text.isEmpty) {
                          showToast("Please select gender");
                        } else if (_dobController.text.isEmpty) {
                          showToast("Please select date of birth");
                        } else if (_emailController.text.isEmpty) {
                          showToast("Please enter email");
                        } else if (_localBodyTypeController.text.isEmpty) {
                          showToast("Please Select Local body type");
                        } else if (_localBodyController.text.isEmpty) {
                          showToast("Please Select Local body");
                        } else if (_patientCategoryController.text.isEmpty) {
                          showToast("Please Select a Patient category");
                        }
                        else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(_emailController.text)) {
                          showToast("Please enter a valid email");
                        }
                        else if (uidType == "2" && _uidNumberController.text.length != 12) {
                          showToast("Your Aadhar number must be of 12 digits,Please check the entered UID number!");
                        }else if (uidType == "4" && _uidNumberController.text.length < 5) {
                          showToast("Your Passport number must be atleast 5 digits,Please check the entered UID number!");
                        }

                        else {
                          buildConfirmationPopUp();
                        }
                      }),
                ],
              ),
            ),
            //       Positioned(bottom: 0,left: 0,right: 0,
            //         child: Container(color: Colors.black87,
            //           child: ListBody(
            //   children: [
            //     Divider(height: 1,color: Colors.blue,),
            //     ListTile(
            //       onTap: (){
            //           _getFromGallery();
            //       },
            //     title: Text("Gallery",style: TextStyle(color: Colors.white),),
            //       leading: Icon(Icons.image,color: Colors.blue,),
            // ),
            //
            //     Divider(height: 1,color: Colors.blue,),
            //     ListTile(
            //       onTap: (){
            //           _getFromCamera();
            //       },
            //       title: Text("Camera",style: TextStyle(color: Colors.white)),
            //       leading: Icon(Icons.camera,color: Colors.blue,),
            //     ),
            //   ],
            // ),
            //         ),)
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

  _showBottomSheet() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      _getFromGallery();
                    },
                    title: Text("Gallery"),
                    leading: Icon(Icons.image),
                  ),
                ),
                Container(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      _getFromCamera();
                    },
                    title: Text("Camera"),
                    leading: Icon(Icons.camera),
                  ),
                )
              ],
            ),
          );
        });
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
                        "Next",
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
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Pre Printed barcodes",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            )),
                        buildTextField(
                            textEditingController: _barcodeController,
                            labelText: "Barcode",
                            isEnabled: false),
                        buildTextFieldWithDropDown(
                            textEditingController: _uidTypeController,
                            labelText: "UID Type*",
                            // isReadOnly: false,
                            dropDownName: uidDropdown),
                        buildImageFetch(),
                        buildTextField(
                            textEditingController: _uidNumberController,
                            labelText: "UID Number*",

                            isEnabled: true),
                        buildTextFieldWithDropDown(
                            // isReadOnly: false,
                            textEditingController: _nameTitleController,
                            labelText: "Name Title*",
                            dropDownName: nameTitleDropdown),
                        buildTextField(
                            textEditingController: _fullNameController,
                            labelText: "Full Name*",
                            isEnabled: true),
                        buildTextFieldWithDropDown(
                            // isReadOnly: false,
                            textEditingController: _genderController,
                            labelText: "Gender*",
                            dropDownName: genderDropdown),
                        buildTextFieldWithDropDown(
                            // isReadOnly: false,
                            textEditingController: _dobController,
                            labelText: "DOB*",
                            dropDownName: dobDropdown),
                        buildTextField(
                            textEditingController: _emailController,
                            labelText: "Email*",
                            isEnabled: true),
                        buildTextFieldWithDropDown(
                            // isReadOnly: false,
                            textEditingController: _localBodyTypeController,
                            labelText: "Local Body Type*",
                            dropDownName: localBodyType),
                    buildTextFieldWithDropDown(
                          // isReadOnly: false,
                            textEditingController: _localBodyController,
                            labelText: "Local Body*",
                            dropDownName: localBody) ,
                        buildTextFieldWithDropDown(
                          // isReadOnly: true,
                            textEditingController: _patientCategoryController,
                            labelText: "Patient Category*",
                            dropDownName: patientCategory),

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
            controller: textEditingController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
                border: InputBorder.none, label: Text(labelText)),
          ),
        ),
      ),
    );
  }

  Widget buildImageFetch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          _showBottomSheet();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            height: 150,
            width: _screenSize.width,
            decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.buttonColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: imageFile != null
                ? Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Stack(
                      children: [
                        Center(
                            child: Image.file(
                          imageFile!,
                          fit: BoxFit.contain,
                        )),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  imageFile = null;
                                });
                              },
                            ))
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Image.asset(
                      Assets.uploadIcon,
                      scale: 3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _showPopupMenuNameTitle(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: List.generate(
          nameTitleList.length,
          (index) => PopupMenuItem(
                value: nameTitleList[index],
                child: Text(nameTitleList[index]),
              )),
      elevation: 8.0,
    ).then((value) {
// NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null

      if (value != null) {
        setState(() {
          _nameTitleController.text = value;
        });
      }
    });
  }

  void _showPopupMenuUidType(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: List.generate(
          widget.arguments.list.length,
          (index) => PopupMenuItem(
                value: widget.arguments.list[index].uidId,
                child: Text(widget.arguments.list[index].uidName),
              )),
      elevation: 8.0,
    ).then((value) {
// NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null

      if (value != null) {
        setState(() {
          uidType = value;
          // _uidTypeController.text=widget.arguments.list[int.tryParse(value)!].uidName;
          _uidTypeController.text = widget
              .arguments
              .list[widget.arguments.list
                  .indexWhere((element) => element.uidId == value)]
              .uidName;
        });
      }
    });
  }

  void _showPopupMenuLocalBodyList(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: List.generate(
        localBodyLists.length,
        (index) => PopupMenuItem(
          value: localBodyLists[index].localBodyNo,
          child: Text(localBodyLists[index].localBodyName),
        ),
      ),
      elevation: 8.0,
    ).then((value) {
// NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null

      if (value != null) {
        setState(() {
          localBodyText = value;
          print(value);
          // _uidTypeController.text=widget.arguments.list[int.tryParse(value)!].uidName;
          _localBodyController.text = localBodyLists[localBodyLists
                  .indexWhere((element) => element.localBodyNo == value)]
              .localBodyName;
        });
      }
    });
  }

  void _showPopupMenuLocalBodyType(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem(
          value: "1",
          child: Text("Grama Panchayath"),
        ),
        PopupMenuItem(
          value: "2",
          child: Text("Muncipality"),
        ),
        PopupMenuItem(
          value: "3",
          child: Text("Corporation"),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
// NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null

      if (value != null) {
        setState(() {
          localBodyType = value;
          print(localBodyType);
          testRequestBloc.localBodyFetch(
            request: LocalBodyFetchRequest(
              localBodyType: value,
              localBodyDistrictId: ObjectFactory()
                  .prefs
                  .getPhleboData()!
                  .response!
                  .phlebotomistDistrictId,
            ),
          );
          if (value == "1") {
            _localBodyTypeController.text = "Grama Panchayath";

            // print(value);
          } else if (value == "2") {
            _localBodyTypeController.text = "Muncipality";
            // print(value);
          } else if (value == "3") {
            _localBodyTypeController.text = "Corporation";
            // print(value);
          }

          listenLocalBodyList = true;
          loading = true;
        });
      }
    });
  }

  void _showPopupMenuPatientCategory(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem(
          value: "16",
          child: Text(
            "All individuals undertaking travel to countries/indian states mandating a negative COVID-19.",
            softWrap: true,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
        PopupMenuItem(
          value: "17",
          child: Text("All individuals who wish to get themselves tested.",
              softWrap: true,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),

      ],
      elevation: 8.0,
    ).then((value) {
// NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null

      if (value != null) {
        setState(() {
         patientCategoryId = value;
          if (patientCategoryId == "16") {
            _patientCategoryController.text = "All individuals undertaking travel to countries/indian states mandating a negative COVID-19.";
            print(patientCategoryId);


          } else if (value == "17") {
            _patientCategoryController.text = "All individuals who wish to get themselves tested.";
            print(patientCategoryId);
          }

          // listenUpdateDetails = true;
          // loading = false;
        });
      }
    });
  }

  void _showPopupMenuGender(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem(
          value: "M",
          child: Text("Male"),
        ),
        PopupMenuItem(
          value: "F",
          child: Text("Female"),
        ),
        PopupMenuItem(
          value: "O",
          child: Text("Others"),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
// NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null

      if (value != null) {
        setState(() {
          if (value == "M") {
            _genderController.text = "Male";
          } else if (value == "F") {
            _genderController.text = "Female";
          } else if (value == "O") {
            _genderController.text = "Others";
          }
        });
      }
    });
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      List<int> imageBytes = File(pickedFile.path).readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      print(base64Image);
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      List<int> imageBytes = File(pickedFile.path).readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      print(base64Image);
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Widget buildTextFieldWithDropDown(
      {required TextEditingController textEditingController,
      required String labelText,
        // required bool isReadOnly,
      required String dropDownName}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (dropDownName == uidDropdown) {
            _showPopupMenuUidType(details.globalPosition);
          } else if (dropDownName == nameTitleDropdown) {
            _showPopupMenuNameTitle(details.globalPosition);
          } else if (dropDownName == genderDropdown) {
            _showPopupMenuGender(details.globalPosition);
          } else if (dropDownName == dobDropdown) {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime(1900, 1, 1),
                maxTime: DateTime.now(),
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
                _dobController.text = DateFormat('yyyy-MM-dd').format(date);
                // _dobController.text = date.toString();
              });
            }, currentTime: DateTime.now(), locale: LocaleType.en);

            // _showPopupMenuNameTitle(details.globalPosition);
          } else if (dropDownName == localBodyType) {
            _showPopupMenuLocalBodyType(details.globalPosition);
          } else if (dropDownName == localBody) {
            _showPopupMenuLocalBodyList(details.globalPosition);
          }else if (dropDownName == patientCategory) {
            _showPopupMenuPatientCategory(details.globalPosition);
          }
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
                    // readOnly:  isReadOnly,
                    controller: textEditingController,
                    enabled: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
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
            print(patientCategoryId);
            testRequestBloc.updateTestDetails(
                request: UpdateTestDetailsRequest(
              prePrintedBarcode: _barcodeController.text,
              // prePrintedBarcode: "123456",
              uidImage: base64Image!,
              // uidImage: "1234567",
              uidNo: _uidNumberController.text,
              uidType: uidType,
              email: _emailController.text,
              dob: _dobController.text,
              gender: _genderController.text,
              nameTitle: _nameTitleController.text,
              requestDetailId: widget.arguments.requestID,
              localBody: localBodyText,
              localBodyType: localBodyType,
              patientCategory: patientCategoryId,

              districtId: ObjectFactory()
                  .prefs
                  .getPhleboData()!
                  .response!
                  .phlebotomistDistrictId,
            ));
            setState(() {
              listenUpdateDetails = true;
              loading = true;
            });
            Navigator.of(context).pop();
            print(widget.arguments.requestID);
            print(localBodyText);
            print(localBodyType);
          },
          width: 95,
          color: Color(0xff68CE78).withOpacity(1.0),
        ),
      ],
    ).show();
  }
}
