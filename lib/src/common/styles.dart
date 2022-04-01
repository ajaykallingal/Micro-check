import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

Color background = Color(0xfff3f2ee);
Color darkShadow = Color(0xffcfceca);
Color lightShadow = Color(0xffffffff);

Color textColor = Color(0xff001f3f);

Color onlineIndicator = Color(0xff0ee50a);

var softShadows = [
  BoxShadow(
      color: darkShadow,
      offset: Offset(2.0, 2.0),
      blurRadius: 2.0,
      spreadRadius: 1.0),
  BoxShadow(
      color: lightShadow,
      offset: Offset(-2.0, -2.0),
      blurRadius: 2.0,
      spreadRadius: 1.0),
];

var softShadowsInvert = [
  BoxShadow(
      color: lightShadow,
      offset: Offset(2.0, 2.0),
      blurRadius: 2.0,
      spreadRadius: 2.0),
  BoxShadow(
      color: darkShadow,
      offset: Offset(-2.0, -2.0),
      blurRadius: 2.0,
      spreadRadius: 2.0),
];

TextStyle kAppBarTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);


TextStyle kNameTextStyle = TextStyle(
  fontSize: 21,
  fontWeight: FontWeight.w600,
  color: Colors.black.withOpacity(1.0),
);
TextStyle kTitleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: Colors.black.withOpacity(1.0),
);
TextStyle kMobNumberTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.black.withOpacity(0.56),
);
TextStyle kInCardTextStyle = TextStyle(
  fontSize: 15,
  color: Colors.black.withOpacity(1.0),
);
TextStyle kInCardNumberTextStyle =  TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.black.withOpacity(1.0),

);
TextStyle kSummaryleftSideTextStyle =  TextStyle(
  fontSize: 17,

  color: Colors.black.withOpacity(1.0),

);
TextStyle kSummaryRightSideTextStyle =  TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.black.withOpacity(1.0),

);
TextStyle kLogOutTextStyle =  TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.black.withOpacity(1.0),

);

Color kMainThemeColor = Color(0xff26ABE2).withOpacity(1.0);
///request details
TextStyle kTravelDetailsTitle = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
  color: Color(0xff434343).withOpacity(0.7),
);
TextStyle kReachedButtonStyle =TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.white.withOpacity(1.0),
);
TextStyle kSuccessAlertButtonStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.white.withOpacity(1.0),
);

TextStyle kTitiliumWebLeftSideSemiBoldText1 = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w600,
  color: Colors.black.withOpacity(1.0),
);
TextStyle kTitiliumWebLeftSideSemiBoldText2 = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: Color(0xff434343).withOpacity(0.7),
);
TextStyle kRequestDetailsPageTitleText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Color(0xff21B137).withOpacity(1.0),
);
TextStyle kRequestDetailsAirportPassenger = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w600,
  color: Colors.white.withOpacity(1.0),
);
TextStyle kTextFieldTextStyle = TextStyle(
  fontSize: 15,
  // fontWeight: FontWeight.w600,
  color: Color(0xff434343).withOpacity(0.7),
);

///payment screen

TextStyle kUPIpaymentMethodTextStyle = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.w600,
  color: Colors.black.withOpacity(1.0),
);

TextStyle kPaymentSummaryTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Color(0xff434343).withOpacity(0.7),
);


