

import 'package:micro_check/src/data/model/common/state_model.dart';
import 'package:micro_check/src/data/model/master/get_company_url/get_company_url_response.dart';
import 'package:micro_check/src/data/shared_pref/object_factory.dart';

class MasterApiProvider {
  // Future<StateModel> getCompanyBaseUrl(String companyId) async {
  //   final response = await ObjectFactory().apiClient.getCompanyBaseUrl(companyId);
  //   print("response" + response.toString());
  //   if (response.statusCode == 200) {
  //     // ObjectFactory().prefs.saveCompanyBaseUrl(baseUrl: GetBaseUrlResponse.fromJson(response.data).data[0].restaurantCrmUrl);
  //     return StateModel<GetBaseUrlResponse>.success(GetBaseUrlResponse.fromJson(response.data));
  //   } else {
  //     return StateModel<String>.error("Error Occurred");
  //   }
  // }
}