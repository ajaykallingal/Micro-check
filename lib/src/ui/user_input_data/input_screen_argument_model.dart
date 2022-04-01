import 'package:micro_check/src/data/model/test_request/local_body_fetch_request.dart';
import 'package:micro_check/src/data/model/test_request/update_travel_status_response.dart';

import '../../data/model/test_request/local_body_fetch_response.dart';

class UserInputDataScreenArguments {
  final String requestID;
  final List<UidList> list;
  final String totalAmount;
  final String name;
  UserInputDataScreenArguments({required this.requestID,required this.list,required this.totalAmount,required this.name,});

}