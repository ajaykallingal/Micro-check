import 'package:flutter/material.dart';
import 'package:micro_check/src/ui/profile/widgets/summary_widgets.dart';

class PhleboMySummaryWidget extends StatelessWidget {
  const PhleboMySummaryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xffFCFCFC).withOpacity(1.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color(0xffFCFCFC).withOpacity(1.0),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            SizedBox(height: 5),
            SummaryDetailsWidget(
              leftSideDetails: 'Total Earnings',
              rightSideDetails: 1000.0,
            ),
            Divider(
              color: Color(0xff707070),
              thickness: 0.1,
            ),
            SummaryDetailsWidget(
              leftSideDetails: 'Total Sample Collected',
              rightSideDetails: 13,
            ),
            Divider(
              color: Color(0xff707070),
              thickness: 0.1,
            ),
            SummaryDetailsWidget(
              leftSideDetails: 'Total Direct Registration',
              rightSideDetails: 3,
            ),
            Divider(
              color: Color(0xff707070),
              thickness: 0.1,
            ),
            SummaryDetailsWidget(
              leftSideDetails: 'Total Self Assigned',
              rightSideDetails: 2,
            ),
            Divider(
              color: Color(0xff707070),
              thickness: 0.1,
            ),
            SummaryDetailsWidget(
              leftSideDetails: 'Total On-Time Collection',
              rightSideDetails: 4,
            ),
            Divider(
              color: Color(0xff707070),
              thickness: 0.1,
            ),
            SummaryDetailsWidget(
              leftSideDetails: 'Total Delayed Collection',
              rightSideDetails: 2,
            ),
            Divider(
              color: Color(0xff707070),
              thickness: 0.1,
            ),
            SummaryDetailsWidget(
              leftSideDetails: 'Total Hold',
              rightSideDetails: 0,
            ),
            Divider(
              color: Color(0xff707070),
              thickness: 0.1,
            ),
            SummaryDetailsWidget(
              leftSideDetails: 'Total Canceled',
              rightSideDetails: 0,
            ),
            Divider(
              color: Color(0xff707070),
              thickness: 0.1,
            ),
            SummaryDetailsWidget(
              leftSideDetails: 'Total Rescheduled',
              rightSideDetails: 1,
            ),
            Divider(
              color: Color(0xff707070),
              thickness: 0.1,
            ),
            SummaryDetailsWidget(
              leftSideDetails: 'Total Cash Payments',
              rightSideDetails: 3,
            ),
            Divider(
              color: Color(0xff707070),
              thickness: 0.1,
            ),
            SummaryDetailsWidget(
              leftSideDetails: 'Total Online payments',
              rightSideDetails: 8,
            ),
          ],
        ),
      ),
    );
  }
}