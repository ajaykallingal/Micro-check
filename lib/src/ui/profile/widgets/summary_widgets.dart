import 'package:flutter/material.dart';
import 'package:micro_check/src/common/styles.dart';

class SummaryDetailsWidget extends StatelessWidget {
  final String? leftSideDetails;
  final double? rightSideDetails;

  SummaryDetailsWidget({required this.leftSideDetails,required this.rightSideDetails});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(leftSideDetails!,style: kSummaryleftSideTextStyle,),
        Text(rightSideDetails.toString(),style: kSummaryRightSideTextStyle,),
      ],
    );
  }
}

