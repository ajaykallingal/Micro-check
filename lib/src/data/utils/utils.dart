import 'dart:io';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:micro_check/src/constants/strings.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';

///it contain common functions
class Utils {
  static final dateTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");

  // static final othersBloc = OthersBloc();

  static String getDateTimeForAPI(DateTime? dateTime) {
    if (dateTime != null) {
      dateTime = dateTime.toUtc();
      return dateTimeFormat.format(dateTime).toString();
    } else {
      return "";
    }
  }

  static String capitalize(String s) {
    if (s.isNotEmpty) {
      return s[0].toUpperCase() + s.substring(1);
    } else {
      return "";
    }
  }

  static bool checkLoggedIn() {
    if (ObjectFactory().prefs.isLoggedIn()!) {
      return true;
    } else {
      return false;
    }
  }

  static String toMonth(int val) {
    switch (val) {
      case 1:
        {
          return "Jan";
        }
      case 2:
        {
          return "Feb";
        }
      case 3:
        {
          return "Mar";
        }
      case 4:
        {
          return "Apr";
        }
      case 5:
        {
          return "May";
        }
      case 6:
        {
          return "Jun";
        }
      case 7:
        {
          return "Jul";
        }
      case 8:
        {
          return "Aug";
        }
      case 9:
        {
          return "Sep";
        }
      case 10:
        {
          return "Oct";
        }
      case 11:
        {
          return "Nov";
        }
      default:
        {
          return "Dec";
        }
    }
  }

  static String formatTime(int val) {
    if (val > 12) {
      return ("PM");
    } else
      return ("AM");
  }

  static String formatHour(int val) {
    if (val < 13) {
      return (val.toString());
    } else
      return (val - 12).toString();
  }

  static void logoutAction(context, token) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: Text(
              Strings.LOGIN_CONFIRMATION_TEXT,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 18.0, color: Theme.of(context).primaryColor),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    Strings.CANCEL,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text(
                    Strings.LOGOUT_TEXT,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).buttonColor, fontSize: 16),
                  ),
                  onPressed: () async {
                    /// clearing prefs  and   navigate to login page

                    // othersBloc.deleteFcmToken(fcmToken: token);

                    ObjectFactory().prefs.setIsLoggedIn(false);

                    // if(ObjectFactory().prefs.getStateList()!=null) {
                    //   stateResponse = ObjectFactory().prefs
                    //       .getStateList();
                    // }
                    // ObjectFactory().prefs.clearPrefs();
                    //  if(stateResponse!=null){
                    //  ObjectFactory().prefs.saveStateList(stateResponse);}
//                    ObjectFactory().prefs.saveMasterData(masterDataResponse);
//                     Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginScreen()),
//                             (Route<dynamic> route) => false);

//                    Navigator.pushAndRemoveUntil(
//                        context,
//                        MaterialPageRoute(builder: (context) => Login()),
//                            (Route<dynamic> route) => false);
                  }),
            ],
          );
        });
  }

  static void alertDialog(context,
      {required String text,
        required VoidCallback func,
        required String buttonText}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: Text(
              text,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 16.0, color: Theme.of(context).primaryColor),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    Strings.CANCEL,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text(
                    buttonText,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).buttonColor, fontSize: 16),
                  ),
                  onPressed: func),
            ],
          );
        });
  }

  static int calculateOffPercentage(String price, String listPrice) {
    if (double.tryParse(listPrice)!.round() > 0) {
      return 100 -
          ((double.tryParse(price)!.round() /
              double.tryParse(listPrice)!.round()) *
              100)
              .round();
    } else {
      return 0;
    }
  }

  static String moneyFormat(String price) {
    var value = price;
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
    return value;
  }
}

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).height / dividedBy;
}

double screenWidth(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).width / dividedBy;
}

///common toast
void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

///common toast
void showToastLong(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
  );
}

void showToastConnection(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
  );
}

// Future<File> downloadImage(
//     String dir, String filename, String networkImageUrl) async {
//   String dir = (await getApplicationDocumentsDirectory()).path;
//   File file = new File('$dir/$filename');
//   file.open(mode: FileMode.write);
//
//   print('file not found downloading from server');
//   Dio dio = new Dio(new BaseOptions(responseType: ResponseType.bytes));
// //  Response fileDownloadResponse =
// //      await dio.download(networkImageUrl, file.path);
//   var request = await dio.get(networkImageUrl);
//   var bytes = await request.data; //close();
//   await file.writeAsBytes(bytes);
//   print(file.path);
//   return file;
// }

class MoneyFormat {
  String? price;

  String? moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
  }
}
