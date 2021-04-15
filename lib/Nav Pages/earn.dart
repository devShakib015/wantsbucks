import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/custom%20widgets/my_url_launcher.dart';
import 'package:wantsbucks/custom%20widgets/point_and_earning.dart';
import 'package:wantsbucks/providers/customads_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class Earn extends StatefulWidget {
  @override
  _EarnState createState() => _EarnState();
}

class _EarnState extends State<Earn> {
  // RewardedAd _admobRewarded;
  // @override
  // void initState() {
  //   super.initState();
  //   _admobRewarded = RewardedAd(
  //     adUnitId: admob_test_rewarded,
  //     request: AdRequest(),
  //     listener: AdListener(onRewardedAdUserEarnedReward:
  //         (RewardedAd ad, RewardItem reward) async {
  //       print(reward.type);
  //       print(reward.amount ~/ 10);

  //       await Provider.of<PointProvider>(context, listen: false)
  //           .addPoint((reward.amount ~/ 10));
  //     }, onAdLoaded: (ad) {
  //       print("ad loaded");
  //     }, onAdClosed: (ad) {
  //       ad.dispose();
  //     }, onAdFailedToLoad: (ad, err) {
  //       ad.dispose();
  //     }),
  //   );

  //   _admobRewarded.load();
  // }

  // @override
  // void dispose() {
  //   _admobRewarded?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // List<Map<String, dynamic>> _rewardedAds = [
    //   {
    //     'name': "Google Admob",
    //     "channel": 1,
    //     "color": Color(0xffb20238),
    //   },
    //   {
    //     'name': "Adcolony",
    //     "channel": 2,
    //     "color": Color(0xff12a4d9),
    //   },
    //   {
    //     'name': "Facebook",
    //     "channel": 3,
    //     "color": Color(0xff5c3c92),
    //   },
    //   {
    //     'name': "StartApp",
    //     "channel": 4,
    //     "color": Color(0xff077b8a),
    //   },
    //   {
    //     'name': "Unity",
    //     "channel": 5,
    //     "color": Color(0xffe75874),
    //   },
    //   {
    //     'name': "Appodeal",
    //     "channel": 6,
    //     "color": Color(0xff6783bc),
    //   },
    // ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Earn Points"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PointAndEarning(),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            _earnPointCustomAds(context),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: dangerColor,
                      duration: Duration(seconds: 8),
                      content: Text(
                          "This feature will come at 1st July 2021.\nUntil then try to earn by reffering users. You account will be activated in this period. Don't worry about it!"),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Card(
                    elevation: 15,
                    shadowColor: Color(0xff273238),
                    color: Color(0xffb20238),
                    child: GridTile(
                        header: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Text(
                              "Earn Point",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        footer: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Text(
                              "Click Here and Wait",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 05,
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Image.asset(
                                  "assets/images/ad.png",
                                  width: 80,
                                ),
                              )),
                        )),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<QuerySnapshot> _earnPointCustomAds(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Provider.of<CustomAdsProvider>(context).loadEarnAds(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.17,
            child: Center(
              child: Text("Ads Loading..."),
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.17,
            child: Center(
              child: Text("Error Loading ads"),
            ),
          );
        } else {
          final _customHomeAds = snapshot.data.docs;

          List _homeAds = [];
          for (var item in _customHomeAds) {
            if (DateTime.fromMillisecondsSinceEpoch(item.data()["endDate"])
                    .difference(DateTime.now())
                    .inDays >
                0) {
              _homeAds.add(item.data());
            }
          }

          if (snapshot.data.docs.isEmpty) {
            return Container();
          } else
            return CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.17,
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 2),
                autoPlayAnimationDuration: Duration(milliseconds: 500),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: _homeAds.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        launchURL(i["url"]);
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            i["adurl"],
                            fit: BoxFit.fill,
                          )),
                    );
                  },
                );
              }).toList(),
            );
        }
      },
    );
  }
}



// ElevatedButton(
//               onPressed: () async {
//                 Map<String, dynamic> data = {
//                   "url": "https://google.com",
//                   "adurl":
//                       "https://firebasestorage.googleapis.com/v0/b/wantsbucks-1858e.appspot.com/o/Ads%2FHome%2F1.jpg?alt=media&token=001dacd4-deb7-4273-a26f-7aa8eba143bf",
//                   "startDate": DateTime.now().millisecondsSinceEpoch,
//                   "endDate": DateTime.now()
//                       .add(Duration(days: 30))
//                       .millisecondsSinceEpoch
//                 };
//                 for (var i = 0; i < 10; i++) {
//                   await Provider.of<CustomAdsProvider>(context, listen: false)
//                       .addAds("homeads", data);
//                   await Provider.of<CustomAdsProvider>(context, listen: false)
//                       .addAds("directads", data);
//                   await Provider.of<CustomAdsProvider>(context, listen: false)
//                       .addAds("earnads", data);
//                 }
//               },
//               child: Text("Add Ads")),