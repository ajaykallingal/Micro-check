import 'package:flutter/material.dart';
import 'package:micro_check/src/common/styles.dart';
import 'package:micro_check/src/constants/assets.dart';
import 'package:micro_check/src/data/model/test_request/get_single_request_details_response.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactAndDirectionWidget extends StatelessWidget {
  final Response response;
   ContactAndDirectionWidget({
    Key? key,required this.response
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone', style: kTitiliumWebLeftSideSemiBoldText2),
                    Text(
                      response.contactNo,
                      style: kTitiliumWebLeftSideSemiBoldText1,
                    ),
                  ],
                ),
                SizedBox(width: 10),
                response.requestStatus ==
                    "10"? InkWell(
                  child: Container(
                    height: 38,
                    width: 35,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff26ABE2).withOpacity(1.0),

                    ),
                    child: ImageIcon(
                      AssetImage(Assets.call),
                      color: Colors.white.withOpacity(1.0),
                      // semanticLabel: 'Call',
                      size: 10,
                    ),
                  ),
                  onTap: () {
                    final Uri _phoneLaunchUri = Uri(
                      scheme: 'tel',
                      path: response.contactNo,
                    );
                    launchURL(_phoneLaunchUri.toString());
                  },
                ):Container(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Distance', style: kTitiliumWebLeftSideSemiBoldText2),
                    Text(
                        response.distanceInKm !="0" ?  response.distanceInKm +
                          " km":  response.distanceInKm,
                      style: kTitiliumWebLeftSideSemiBoldText1,
                    ),
                  ],
                ),
                SizedBox(width: 15,),
                response.requestStatus ==
                    "10"?InkWell(
                  child: Container(
                    height: 38,
                    width: 35,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff26ABE2).withOpacity(1.0),

                    ),
                    child: ImageIcon(
                      AssetImage(Assets.start),
                      color: Colors.white.withOpacity(1.0),
                      semanticLabel: 'map',
                      size: 10,
                    ),
                  ),
                  onTap: () {
                    openMap(
                        latitude:
                        double.tryParse(response.latitude)!,
                        longitude:
                        double.tryParse(response.longitude)!);
                  },
                ):Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Future<void> launchURL(String url) async {
    print("phone clicked");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> openMap(
      {required double latitude, required double longitude}) async {
    print("map clicked");

    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}