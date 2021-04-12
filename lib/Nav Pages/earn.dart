import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/custom%20widgets/my_url_launcher.dart';
import 'package:wantsbucks/custom%20widgets/point_and_earning.dart';
import 'package:wantsbucks/providers/customads_provider.dart';

class Earn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _rewardedAds = [
      {
        'name': "Google Admob",
        "channel": 1,
        "color": Color(0xffb20238),
      },
      {
        'name': "Adcolony",
        "channel": 2,
        "color": Color(0xff12a4d9),
      },
      {
        'name': "Facebook",
        "channel": 3,
        "color": Color(0xff5c3c92),
      },
      {
        'name': "StartApp",
        "channel": 4,
        "color": Color(0xff077b8a),
      },
      {
        'name': "Unity",
        "channel": 5,
        "color": Color(0xffe75874),
      },
      {
        'name': "Appodeal",
        "channel": 6,
        "color": Color(0xff6783bc),
      },
    ];
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
            height: 5,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: _rewardedAds.map((e) {
                return GestureDetector(
                  onTap: () {
                    //TODO: Add Ad Services to the Channels
                    print(e["name"]);
                  },
                  child: Card(
                    color: e["color"],
                    child: GridTile(
                        header: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Earn Point",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        footer: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Channel ${e["channel"]}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Container(
                              width: 40,
                              child: Image.asset(
                                "assets/images/ad.png",
                                fit: BoxFit.cover,
                              )),
                        )),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      )),
    );
  }

  FutureBuilder<QuerySnapshot> _earnPointCustomAds(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Provider.of<CustomAdsProvider>(context).loadEarnAds(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.08,
            child: Center(
              child: Text("Ads Loading..."),
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.08,
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