import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:micro_check/src/common/styles.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_response.dart';
class NameDateTimeDetails extends StatelessWidget {
  final Response response;
  const NameDateTimeDetails({
    Key? key,required this.response
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: kTitiliumWebLeftSideSemiBoldText2,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 3),
              Text(
               response.fullName,overflow: TextOverflow.ellipsis,maxLines: 1,softWrap: true,
                style: kTitiliumWebLeftSideSemiBoldText1,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' Preferred Date & Time',
                style: kTitiliumWebLeftSideSemiBoldText2,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 3),
              Text(
                ' ${response.preferredDate.split('-').reversed.join('-')} | ${response.preferredTimeStart} ',
               // ' ${response.preferredDate.split('-').reversed.join('-')} | ${DateFormat("h:mma").format(DateTime.tryParse(response.preferredTimeStart)!)} ',
                // ' ${String.fromCharCodes(response.preferredDate.runes.toList().reversed)} | ${response.preferredTimeStart} ',
                style:TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(1.0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}