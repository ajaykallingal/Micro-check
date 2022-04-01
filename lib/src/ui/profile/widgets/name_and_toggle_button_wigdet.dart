import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:micro_check/src/common/styles.dart';

class NameAndToggleButtonWidget extends StatelessWidget {
  NameAndToggleButtonWidget({
    Key? key,
    required ValueNotifier<bool> controller,
  })  : _controller = controller,
        super(key: key);

  final ValueNotifier<bool> _controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              'Jonathan James',
              textAlign: TextAlign.left,
              style: kNameTextStyle,
            ),
            SizedBox(height: 4),
            Text(
              '+91 9072 723 723',
              textAlign: TextAlign.left,
              style: kMobNumberTextStyle,
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(1.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0xff00000014),
                  offset: Offset(0, 1),
                  spreadRadius: 20,
                  blurRadius: 5)
            ],
          ),
          // child: AdvancedSwitch(
          //   controller: _controller,
          //   height: 30,
          //   width: 65,
          //   activeColor: Colors.white.withOpacity(1),
          //   activeChild: Padding(
          //     padding: const EdgeInsets.all(1.0),
          //     child: Text(
          //       'Online',
          //       softWrap: true,
          //       style: TextStyle(
          //           fontSize: 10,
          //           fontWeight: FontWeight.w700,
          //           color: Colors.green),
          //     ),
          //   ),
          //   inactiveChild: Padding(
          //     padding: const EdgeInsets.all(1.0),
          //     child: Text(
          //       'Offline',
          //       softWrap: true,
          //       style: TextStyle(
          //         fontSize: 10,
          //         fontWeight: FontWeight.w700,
          //         // color: Colors.grey,
          //       ),
          //     ),
          //   ),
          //   // inactiveColor: Color(0xFFEBEBEB).withOpacity(1.0),
          //   borderRadius: BorderRadius.circular(8),
          // ),
        ),
      ],
    );
  }
}