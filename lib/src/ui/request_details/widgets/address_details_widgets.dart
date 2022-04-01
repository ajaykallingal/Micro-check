import 'package:flutter/material.dart';
import 'package:micro_check/src/common/styles.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_response.dart';



class AddressDetailsWidget extends StatelessWidget {
  final Response response;
  const AddressDetailsWidget({
    Key? key,required this.response
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address',
          style: kTitiliumWebLeftSideSemiBoldText2,
        ),
        SizedBox(height: 5),
        Text(
          response.address,
          style: kTitiliumWebLeftSideSemiBoldText1,
        ),
        // Divider(
        //   color: Color(0xff707070),
        //   thickness: 0.1,
        // ),
        // Text(
        //   'DEF Po',
        //   style: kTitiliumWebLeftSideSemiBoldText1,
        // ),
        // Divider(
        //   color: Color(0xff707070),
        //   thickness: 0.1,
        // ),
        // Text(
        //   'Place,District',
        //   style: kTitiliumWebLeftSideSemiBoldText1,
        // ),
        // Divider(
        //   color: Color(0xff707070),
        //   thickness: 0.1,
        // ),
        // Text(
        //   'Pincode',
        //   style: kTitiliumWebLeftSideSemiBoldText1,
        // ),
        Divider(
          color: Color(0xff707070),
          thickness: 0.1,
        ),
      ],
    );
  }
}
