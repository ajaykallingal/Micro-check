
import 'package:micro_check/src/data/shared_pref/object_factory.dart';

class Urls{
  Urls._();

   /// base url dev
  static const String baseUrl = "https://dev.finekube.com";

  static const String baseUrlProd = "https://booking.microhealthcare.com";

  ///login screen

  ///get otp url
  static const String getOtp = "/micro_check_api/phlebotomist/LoginController/login";


  ///otp screen

  static const String getPhleboDetails = "/micro_check_api/phlebotomist/PhlebotomistController/getPhlebotomistFullDetails";


  ///home screen
  // get all assigned request
  static const String getAssignedTestRequest = "/micro_check_api/phlebotomist/RequestController/getAssignedRequestList";
  // get all  pending request
  static const String pendingTestRequest = "/micro_check_api/phlebotomist/RequestController/getPendingRequestList";

  // assigned to phlebo
  static const String assignedToPhlebo = "/micro_check_api/phlebotomist/RequestController/assignToMe";

  // update test details
  static const String updateTestDetails = "/micro_check_api/phlebotomist/RequestController/addAdditionalDetails";

   //change phlebo online status
  static const String onlineStatusPhlebo = "/micro_check_api/phlebotomist/PhlebotomistController/statusToggle";


  /// request details screen

  static const String singleRequestDetails = "/micro_check_api/phlebotomist/RequestController/showOneRequestDetails";

  static const String updateTravelingStatus = "/micro_check_api/phlebotomist/RequestController/statusChangeToTravellingOrReached";

  static const String updateLiveLocation = "/micro_check_api/phlebotomist/PhlebotomistController/updateLiveLocation";

 ///user input screen
  static const String verifyBarcode = "/micro_check_api/phlebotomist/RequestController/validateBarcode";
  static const String localBodyList = "/micro_check_api/common/CommonController/fetchLocalBodyList";


  /// payment screen
  static const String payment = "/micro_check_api/phlebotomist/RequestController/collectSample";

/// add new test request screen
  static const String addNewTest = "/micro_check_api/phlebotomist/RequestController/addRequestFromPhlebotomistMinimal";

  static const String checkTimeSlot = "/micro_check_api/common/TimeController/showAvailableTimeSlots";

}