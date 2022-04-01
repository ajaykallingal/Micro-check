import 'package:micro_check/src/data/model/common/state_model.dart';
import 'package:micro_check/src/data/model/get_otp/get_otp_response.dart';
import 'package:micro_check/src/data/model/phlebo_details/get_phlebo_details.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';

class AuthApiProvider {
  ///login screen
  Future<StateModel> getOtp(String phoneNo) async {
    final response = await ObjectFactory().apiClient.getOtp(phoneNo);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<GetOtpResponse>.success(GetOtpResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }

  ///otp screen
  Future<StateModel> getPhleboDetails(String phoneNo) async {
    final response = await ObjectFactory().apiClient.getPhleboDetails(phoneNo);
    print("response" + response.toString());
    if (response.statusCode == 200) {
      // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
      return StateModel<GetPhleboDetailsResponse>.success(GetPhleboDetailsResponse.fromJson(response.data));
    } else {
      return StateModel<String>.error("Error Occurred");
    }
  }
}