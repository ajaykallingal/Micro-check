import 'package:flutter/material.dart';
import 'package:micro_check/src/common/styles.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_response.dart';

class TravelDetailsWidget extends StatelessWidget {
  final Response response;
  const TravelDetailsWidget({
    Key? key,required this.response
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Travel Details',style: kTravelDetailsTitle,),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Flight Number',style: kTitiliumWebLeftSideSemiBoldText2,textAlign: TextAlign.left,),
                Text(response.flightNo,style: kTitiliumWebLeftSideSemiBoldText1,textAlign: TextAlign.left,),
                SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date',style: kTitiliumWebLeftSideSemiBoldText2,textAlign: TextAlign.left,),
                    Text(response.travelDate.split('-').reversed.join('-'),style: kTitiliumWebLeftSideSemiBoldText1,textAlign: TextAlign.left,),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Destination',style: kTitiliumWebLeftSideSemiBoldText2,textAlign: TextAlign.left,),
                Text(response.travelDestination,style: kTitiliumWebLeftSideSemiBoldText1,textAlign: TextAlign.left,),
                SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Time',style: kTitiliumWebLeftSideSemiBoldText2,textAlign: TextAlign.left,),
                    Text(response.travelTime,style: kTitiliumWebLeftSideSemiBoldText1,textAlign: TextAlign.left,),
                  ],
                ),
              ],
            ),
          ],
        ),

      ],
    );
  }
}
