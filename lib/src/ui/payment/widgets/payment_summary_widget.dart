import 'package:flutter/material.dart';
import 'package:micro_check/src/common/styles.dart';

class PaymentSummaryWidget extends StatelessWidget {
  final String? summaryDetail;
  final int amount;
  PaymentSummaryWidget({required this.summaryDetail, required this.amount});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          summaryDetail!,
          style: kPaymentSummaryTextStyle,
        ),
        Text(
          "\u20B9 "+amount.toString(),
          style: kTitleTextStyle,
        ),
      ],
    );
  }
}