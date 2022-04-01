import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:micro_check/src/common/styles.dart';
import 'package:micro_check/src/constants/assets.dart';
import 'package:micro_check/src/data/bloc/test_request_bloc.dart';
import 'package:micro_check/src/data/model/latlng.dart';
import 'package:micro_check/src/data/model/payment/payment_request.dart';
import 'package:micro_check/src/data/utils/utils.dart';
import 'package:micro_check/src/ui/payment/payment_screen_arguments.dart';
import 'package:micro_check/src/ui/payment/widgets/payment_summary_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PaymentMethodScreen extends StatefulWidget {
  final PaymentScreenArguments arguments;

  const PaymentMethodScreen({Key? key, required this.arguments})
      : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  bool codSelected = false;

  // bool viewSummary = false;
  // bool viewQRcode = false;
  // bool upiSelected = false;

  String upiPayment = "2";
  String payAtHome = "1";

  String paymentId = "2";

  final testRequestBloc = TestRequestBloc();

  bool viewPaymentSummary = false;
  bool showQr = false;
  bool loading = false;
  bool fetchOneTime = false;
  String? cashOnDelivery;
  String? onlinePayment;
  String balanceAmount = "0";
  TextEditingController referenceIdController = TextEditingController();
  TextEditingController cashPaidController = TextEditingController();

  LocationData? locationData;
  Location location = Location();
  late PermissionStatus permissionStatus;
  late LatLng latLng;


  void cashPaymentToggle() {
    codSelected = !codSelected;
    // viewSummary = !viewSummary;
  }

  void calculateBalanceAmount(String cashPaid) {
    setState(() {
      balanceAmount = (int.tryParse(cashPaid)! -
              int.tryParse(widget.arguments.totalAmount)!)
          .toString();
    });
    // viewSummary = !viewSummary;
  }

  // void upiPaymentToggle() {
  //   upiSelected = !upiSelected;
  //   viewQRcode = !viewQRcode;
  // }

  @override
  void initState() {
    // TODO: implement initState
    fetchLocationFun();
    super.initState();
  }

  fetchLocationFun() async {
      locationData = await location.getLocation();
    setState(() {
      latLng = LatLng(latitude: locationData!.latitude!, longitude: locationData!.longitude!);

    });

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    testRequestBloc.paymentSCListener.listen((event) {
      if(fetchOneTime) {
        if (event.response!.updateResponse) {
          setState(() {
            loading = false;
            fetchOneTime =false;
          });
          buildSuccessPopUp();
        }
        else {
          setState(() {
            loading = false;
            fetchOneTime =false;
          });
          showToast("Already Paid.");
        }
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: kMainThemeColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(right: 100),
                          child: Text(
                            'Payment Method',
                            style: kAppBarTextStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white.withOpacity(1.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          buildUpiPayment(),
                          SizedBox(height: 20),
                          Divider(
                            color: Color(0xff707070),
                            thickness: 0.1,
                            indent: 8,
                            endIndent: 8,
                          ),
                          SizedBox(height: 15),
                          buildCashPayment(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: buildRoundedButton()),
          showQr
              ? Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Center(
                        child: Image.network(
                          widget.arguments.qrUrl,
                          scale: 2,
                        ),
                      ),
                      Positioned(
                          top: 40,
                          right: 10,
                          child: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              setState(() {
                                showQr = false;
                              });
                            },
                          ))
                    ],
                  ),
                )
              : Container(),
          loading?Container(
            color: Colors.black54,
            child:Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),),):Container()
        ],
      ),
    );
  }

  /// Cash Payment ListTile widget...
  ///
  ///
  Widget buildCashPayment() {
    return Column(
      children: [
        ListTile(
          leading: ImageIcon(
            AssetImage(Assets.cashPayment),
            color: kMainThemeColor,
            size: 40,
          ),
          title: Text('Cash Payments',
              style: kUPIpaymentMethodTextStyle, textAlign: TextAlign.left),
          trailing: InkWell(
            onTap: () {
              setState(() {
                cashPaymentToggle();
                paymentId = payAtHome;
              });
            },
            child: codSelected
                ? Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: new AssetImage(Assets.radioButtonIcon),
                        fit: BoxFit.contain,
                      ),
                      // color: kMainThemeColor,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1.5,
                            color: Colors.black38,
                            offset: Offset(0, 1))
                      ],
                    ),
                  )
                : Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1.5,
                            color: Colors.black38,
                            offset: Offset(0, 1))
                      ],
                    ),
                  ),
          ),
        ),
        codSelected
            ? Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Summary',
                          style: kTitleTextStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    PaymentSummaryWidget(
                        amount: int.tryParse(widget.arguments.totalAmount)!,
                        summaryDetail: 'Total Amount'),
                    SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cash Paid',
                          style: kPaymentSummaryTextStyle,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: Container(
                              width: MediaQuery.of(context).size.width * .3,
                              height: 40,
                              // padding: EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: kMainThemeColor),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: TextFormField(
                                controller: cashPaidController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),],
                                onChanged: (value) {
                                  if(value.isNotEmpty) {
                                    calculateBalanceAmount(value);
                                  }

                                },
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    PaymentSummaryWidget(
                        summaryDetail: 'Balance to Customer',
                        amount: cashPaidController.text.isEmpty
                            ? 0
                            : int.tryParse(widget.arguments.totalAmount)! <
                                    int.tryParse(cashPaidController.text)!
                                ? int.tryParse(balanceAmount)!
                                : 0),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  /// TextField with QR code Scanner button widget...
  ///
  ///

  Widget buildTextFieldWithQRcodeScanner() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: kMainThemeColor),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 44,
      width: MediaQuery.of(context).size.width,
      child: TextField(controller: referenceIdController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(6),
          labelText: 'Ref ID',
          labelStyle: kTextFieldTextStyle,
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(maxWidth: 35, maxHeight: 35),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
                onTap: () {
                  setState(() {
                    showQr = true;
                  });
                },
                child: Image.asset(Assets.qrIcon)),
          ),
          // enabled: false,
        ),
      ),
    );
  }

  /// UPI Payment ListTile Widget...
  ///
  ///

  Widget buildUpiPayment() {
    return Column(
      children: [
        ListTile(
          leading: ImageIcon(
            AssetImage(Assets.upiPayment),
            color: kMainThemeColor,
            size: 40,
          ),
          title: Text('UPI Payments',
              style: kUPIpaymentMethodTextStyle, textAlign: TextAlign.left),
          trailing: InkWell(
            onTap: () {
              setState(() {
                cashPaymentToggle();
                paymentId = upiPayment;
              });
            },
            child: !codSelected
                ? Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: new AssetImage(Assets.radioButtonIcon),
                        fit: BoxFit.contain,
                      ),
                      color: kMainThemeColor,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1.5,
                            color: Colors.black38,
                            offset: Offset(0, 1))
                      ],
                    ),
                  )
                : Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1.5,
                            color: Colors.black38,
                            offset: Offset(0, 1))
                      ],
                    ),
                  ),
          ),
        ),
        !codSelected ? buildTextFieldWithQRcodeScanner() : Container(),
      ],
    );
  }

  /// Success Alert Pop-Up Widget...
  ///
  ///
  Future buildSuccessPopUp() async {
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
      desc: "Sample Collected Successfully.",
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
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, "/home", (route) => false,arguments: LatLng(latitude: latLng.latitude, longitude: latLng.longitude)),
          width: 95,
          color: Color(0xff68CE78).withOpacity(1.0),
        )
      ],
    ).show();
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
            setState(() {
              loading= true;
            });
            testRequestBloc.payment(
                request: PaymentRequest(
                    reqMasterId: widget.arguments.requestId,
                    totalAmount: widget.arguments.totalAmount,
                    payMethod: paymentId,
                    refNo: referenceIdController.text,
                    cashPaid: paymentId == upiPayment
                        ? widget.arguments.totalAmount
                        : cashPaidController.text,
                    balanceToCustomer: balanceAmount));
            Navigator.of(context).pop();
          },
          width: 95,
          color: Color(0xff68CE78).withOpacity(1.0),
        ),
      ],
    ).show();
  }

  /// BottomSheet RoundEdgedButton widget..
  ///
  ///
  Widget buildRoundedButton() {
    return ElevatedButton(
      child: Text(
        'Collect Sample',
        style: kReachedButtonStyle,
      ),
      onPressed: () {
        // buildSuccessPopUp();
        if(paymentId == upiPayment){
          if (referenceIdController.text.isEmpty) {
            showToast("Please enter transaction id");
          }else{
            setState(() {
              // loading
              fetchOneTime = true;
            });
            buildConfirmationPopUp();
          }
        }
        else{
          if (cashPaidController.text.isEmpty) {
            showToast("Please enter cash paid");
          } else if (int.tryParse(cashPaidController.text)!<int.tryParse(widget.arguments.totalAmount)!){
            showToast("Please check amount is correct !!!");
          }
          else{
            setState(() {
              // loading
              fetchOneTime = true;
            });

            buildConfirmationPopUp();
          }
        }
        // buildSuccessPopUp();
        // buildAssignedAlertPopUp();
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width, 58),
        primary: Color(0xff5AC96B).withOpacity(1.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      ),
    );
  }
}
