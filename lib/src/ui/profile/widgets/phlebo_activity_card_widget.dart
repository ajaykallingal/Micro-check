import 'package:flutter/material.dart';
import 'package:micro_check/src/constants/assets.dart';
import 'package:micro_check/src/ui/profile/widgets/Phlebo_activity_details_widget.dart';

class PhleboActivityCardWidget extends StatelessWidget {
  const PhleboActivityCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xffFCFCFC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 127,
        width: 366,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffFCFCFC),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PhleboActivityDetailsWidget(
              icon: ImageIcon(
                AssetImage(Assets.totalRequestCollectedIcon),
                color: Colors.green,size: 40,
              ),
              cardText: 'Total Request\nCompleted',
              totalNumber: 13,
            ),
            VerticalDivider(
                endIndent: 20, indent: 20, color: Color(0xff707070)),
            PhleboActivityDetailsWidget(
              icon: ImageIcon(
                AssetImage(Assets.totalDirectIcon),
                color: Colors.blueAccent,size: 40,
              ),
              cardText: 'Total Direct\nRegistration',
              totalNumber: 3,
            ),
            VerticalDivider(
                endIndent: 20, indent: 20, color: Color(0xff707070)),
            PhleboActivityDetailsWidget(
              icon: ImageIcon(
                AssetImage(Assets.totalCommissionIcon,),
                color: Colors.amber,size: 40,
              ),
              cardText: 'Total Connection\nEarned',
              totalNumber: 270,
            ),
          ],
        ),
      ),
    );
  }
}