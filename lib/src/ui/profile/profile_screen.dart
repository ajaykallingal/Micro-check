import 'package:flutter/material.dart';
import 'package:micro_check/src/common/styles.dart';
import 'package:micro_check/src/constants/assets.dart';
import 'package:micro_check/src/ui/profile/widgets/name_and_toggle_button_wigdet.dart';
import 'package:micro_check/src/ui/profile/widgets/phlebo_activity_card_widget.dart';
import 'package:micro_check/src/ui/profile/widgets/phlebo_summary_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _controller = ValueNotifier<bool>(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff26ABE2).withOpacity(1.0),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: kMainThemeColor,
            child: Column(
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                      contentPadding: EdgeInsets.only(right: 70),
                      title: Text(
                        'Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back,color: Colors.white,),
                      )),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1.0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 20, right: 20, top: 8),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            buildNameAndToggleButton(),
                            SizedBox(height: 10),
                            buildPhleboActivityCard(),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                ImageIcon(
                                  AssetImage(Assets.totalRequestCollectedIcon),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'My Summary',
                                  style: kTitleTextStyle,
                                ),
                              ],
                            ),
                            buildPhleboSummary(),
                            buildLogOutButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNameAndToggleButton() {
    return NameAndToggleButtonWidget(controller: _controller);
  }

  Widget buildPhleboActivityCard() {
    return PhleboActivityCardWidget();
  }

  Widget buildPhleboSummary() {
    return PhleboMySummaryWidget();
  }

  Widget buildLogOutButton() {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //       builder: (context) => const RequestDetailScreen()),
            // );
          },
          icon: const ImageIcon(
            AssetImage(Assets.logoutIcon),
            color: Colors.black,
          ),
          label: Text(
            'Logout',
            style: kLogOutTextStyle,
          ),
        ),
      ],
    );
  }
}
