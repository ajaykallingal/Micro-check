
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:micro_check/src/data/model/latlng.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_request.dart';
import 'package:micro_check/src/ui/add_new_request/add_new_request_screen.dart';
import 'package:micro_check/src/ui/home/home_screen.dart';
import 'package:micro_check/src/ui/login/login_screen.dart';
import 'package:micro_check/src/ui/login/otp_screen.dart';
import 'package:micro_check/src/ui/login/otp_screen_argument_model.dart';
import 'package:micro_check/src/ui/payment/payment_screen.dart';
import 'package:micro_check/src/ui/payment/payment_screen_arguments.dart';
import 'package:micro_check/src/ui/profile/profile_screen.dart';
import 'package:micro_check/src/ui/request_details/request_details_screen.dart';
import 'package:micro_check/src/ui/splash/splash_screen.dart';
import 'package:micro_check/src/ui/user_input_data/input_screen_argument_model.dart';
import 'package:micro_check/src/ui/user_input_data/user_input_data_screen.dart';

import '../ui/user_input_data/local_body_argument_model.dart';

class RouteGenerator {

  static const initialPage = '/';
  static const splashPage = '/splash';
  static const loginPage = '/login';
  static const otpPage = '/otp';
  static const homeNavigationPage = '/home';
  static const dashboardPage = '/dashboard';
  static const userInputPage = '/userInput';
  static const userChatsPage = '/userChats';
  static const settingsPage = '/settings';
  static const profilePage = '/profile';
  static const requestDetailsPage = '/requestDetails';
  static const paymentMethodPage = '/payment';
  static const addNewRequestPage = '/addNewRequest';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final localBodyArgs = settings.arguments;
    switch (settings.name) {
      case initialPage:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case loginPage:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case otpPage:
        final otpScreenArguments = args as OtpScreenArguments;
        return MaterialPageRoute(builder: (_) => OtpScreen(otpScreenArguments: otpScreenArguments));
      case homeNavigationPage:
        final latLng = args as LatLng;
        return MaterialPageRoute(builder: (_) => HomeScreen(latLng: latLng,));
      case userInputPage:
        final UserInputDataScreenArguments arguments = args as UserInputDataScreenArguments;
        // final LocalBodyArgument localBodyArguments = localBodyArgs as LocalBodyArgument;

        return MaterialPageRoute(builder: (_) => UserInputDataScreen(arguments: arguments,));
      case profilePage:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case requestDetailsPage:
        final getSingleRequestDetailsRequest = args as GetSingleRequestDetailsRequest;
        return MaterialPageRoute(builder: (_) => RequestDetailScreen(getSingleRequestDetailsRequest: getSingleRequestDetailsRequest,));
      case paymentMethodPage:
        final PaymentScreenArguments arguments = args as PaymentScreenArguments;
        return MaterialPageRoute(builder: (_) => PaymentMethodScreen(arguments: arguments,));
      case addNewRequestPage:
        return MaterialPageRoute(builder: (_) => AddNewRequestScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
          elevation: 0,backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Text("Error"),
        ),
      );
    });
  }
}
