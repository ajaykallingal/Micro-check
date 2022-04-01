import 'package:flutter/material.dart';
import 'package:micro_check/src/common/styles.dart';

class PhleboActivityDetailsWidget extends StatelessWidget {
  final String? cardText;
  final double? totalNumber;
  final Widget icon;
  PhleboActivityDetailsWidget({required this.cardText,required this.totalNumber,required this.icon});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(height: 3),
        Text(cardText!,softWrap: true,style: kInCardTextStyle,textAlign: TextAlign.center,),
        SizedBox(height: 3),
        Text(totalNumber.toString(),style: kInCardNumberTextStyle,),
        SizedBox(height: 3),
      ],
    );
  }
}