import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/constants.dart';
import 'package:wantsbucks/custom%20widgets/point_and_earning.dart';
import 'package:wantsbucks/custom%20widgets/my_url_launcher.dart';
import 'package:wantsbucks/other_pages/level_page.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/other_pages/something_went_wrong.dart';
import 'package:wantsbucks/providers/customads_provider.dart';
import 'package:wantsbucks/providers/user_wallpaper_provider.dart';
import 'package:wantsbucks/providers/wallpaper_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _colors = [
    Color(0xffe52165),
    Color(0xff077b8a),
    Color(0xff5c3c92),
    Color(0xff12a4d9),
    Color(0xffb20238),
    Color(0xffe75874),
    Color(0xff6b7b8c),
    Color(0xff7a2048),
    Color(0xff6883bc),
    Color(0xff8a307f),
  ];

  InterstitialAd _myInterstitial;

  @override
  void initState() {
    super.initState();
    _myInterstitial = InterstitialAd(
      adUnitId: homepage_Interstitial,
      request: AdRequest(),
      listener: AdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    _myInterstitial.load();
  }

  @override
  void dispose() {
    _myInterstitial?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PointAndEarning(),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: Provider.of<WallpaperProvider>(context).getAllLevels(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Loading();
            } else if (snapshot.hasError) {
              return SomethingWentWrong();
            } else {
              final _data = snapshot.data.docs;
              return Column(children: [
                FutureBuilder<QuerySnapshot>(
                  future: Provider.of<CustomAdsProvider>(context).loadHomeAds(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: Center(
                          child: Text("Ads Loading..."),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: Center(
                          child: Text("Error Loading ads"),
                        ),
                      );
                    } else {
                      final _customHomeAds = snapshot.data.docs;

                      List _homeAds = [];
                      for (var item in _customHomeAds) {
                        if (DateTime.fromMillisecondsSinceEpoch(
                                    item.data()["endDate"])
                                .difference(DateTime.now())
                                .inDays >
                            0) {
                          _homeAds.add(item.data());
                        }
                      }

                      _homeAds.shuffle();

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
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 500),
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
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: ListView(
                    children: _data.map((e) {
                      return FutureBuilder<QuerySnapshot>(
                        future: Provider.of<UserWallpaperProvider>(context)
                            .getUnlockedLevels(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Card(
                              color: Colors.transparent,
                              child: ListTile(
                                title: Text("Loading..."),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Card(
                              color: Colors.transparent,
                              child: ListTile(
                                title:
                                    Text("There is a problem loading items."),
                              ),
                            );
                          } else {
                            final _uqds = snapshot.data.docs;
                            List _unlockedLevels = [];
                            for (var item in _uqds) {
                              _unlockedLevels.add(item.id);
                            }

                            return _levelCard(
                                context, _colors, _data, e, _unlockedLevels);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ]);
            }
          },
        ),
      ),
    );
  }

  Card _levelCard(
      BuildContext context,
      List<Color> colors,
      List<QueryDocumentSnapshot> _data,
      QueryDocumentSnapshot e,
      List _unlockedLevels) {
    return Card(
      color: colors[_data.indexOf(e)],
      child: ListTile(
        onTap: () async {
          if (_unlockedLevels.contains(e.id)) {
            if (await _myInterstitial.isLoaded()) {
              await _myInterstitial.show();
            }
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LevelPage(
                  levelID: e.id,
                  //unlockedLevelId: null,
                  unlockedLevelId: _data.indexOf(e) >= 9
                      ? null
                      : _data[_data.indexOf(e) + 1].id,
                  levelName: "Level ${_data.indexOf(e) + 1}",
                  levelInterest: e.data()["interest"],
                ),
              ),
            ).then((value) {
              setState(() {});
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 1),
                backgroundColor: Colors.red[900],
                content: Text(
                    "Please complete level ${_data.indexOf(e)} to unlock this level."),
              ),
            );
          }
        },
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Level ${_data.indexOf(e) + 1}",
            style: GoogleFonts.archivoNarrow(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Text("Interest Rate : ${e.data()["interest"]}%"),
        trailing: _unlockedLevels.contains(e.id) ? null : Icon(Icons.lock),
      ),
    );
  }
}
