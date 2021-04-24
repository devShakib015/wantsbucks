import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/custom%20widgets/point_and_earning.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/other_pages/something_went_wrong.dart';
import 'package:wantsbucks/other_pages/wallpaper_page.dart';
import 'package:wantsbucks/providers/earning_provider.dart';
import 'package:wantsbucks/providers/level_provider.dart';
import 'package:wantsbucks/providers/point_provider.dart';
import 'package:wantsbucks/providers/user_wallpaper_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class LevelPage extends StatefulWidget {
  final String levelID;
  final String unlockedLevelId;
  final String levelName;
  final int levelInterest;

  LevelPage({
    this.levelID,
    this.unlockedLevelId,
    this.levelName,
    this.levelInterest,
  });

  @override
  _LevelPageState createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  bool _isLoading = false;
  int _p = 0;

  // BannerAd _ad;
  // InterstitialAd _myInterstitial;

  // @override
  // void initState() {
  //   super.initState();
  //   //TODO: - Add Interstial Ad
  //   _myInterstitial = InterstitialAd(
  //     adUnitId: admob_test_interstial,
  //     request: AdRequest(),
  //     listener: AdListener(
  //         onAdFailedToLoad: (ad, error) {
  //           ad.dispose();
  //         },
  //         onAdLoaded: (ad) {}),
  //   );

  //   _ad = BannerAd(
  //     adUnitId: level_page_banner,
  //     size: AdSize.banner,
  //     request: AdRequest(),
  //     listener: AdListener(
  //       onAdFailedToLoad: (ad, error) {
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //   _ad.load();
  //   _myInterstitial.load();
  // }

  // @override
  // void dispose() {
  //   _ad?.dispose();
  //   _myInterstitial?.dispose();

  //   super.dispose();
  // }

  void onTapWallpaper(
      BuildContext context, List und, DocumentSnapshot e) async {
    if (und.contains(e.id)) {
      // if (await _myInterstitial.isLoaded()) {
      //   await _myInterstitial.show();
      // }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WallpaperPage(
            wallpaperUrl: e.data()["url"],
            data: e,
          ),
        ),
      );
    } else {
      int _cost = e.data()["cost"];

      if (_cost > _p) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[900],
            duration: Duration(seconds: 1),
            content: Text("Not enough point!"),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Padding(
              padding: EdgeInsets.all(16),
              child: Text("Are you sure to buy this wallpaper?"),
            ),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red[900])),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);

                    //Add the profit [Current + total]
                    Provider.of<PointProvider>(context, listen: false)
                        .reducePoint(_cost);

                    //Reduce the point
                    Provider.of<EarningProvider>(context, listen: false)
                        .addProfit(
                            (_cost * (widget.levelInterest / 100)).toInt());

                    //add the wallpaper to user list
                    Provider.of<UserWallpaperProvider>(context, listen: false)
                        .addBoughtWallpaper(widget.levelID, e.id);

                    if (und.length == 9) {
                      if (widget.unlockedLevelId != null) {
                        Provider.of<UserWallpaperProvider>(context,
                                listen: false)
                            .addNewUnlockedWallpaper(widget.unlockedLevelId);
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Container(
                                width: double.infinity,
                                height: 300,
                                child: Center(
                                  child: Text(
                                    "Congrats!!!\nThe next level is unlocked!",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Container(
                                width: double.infinity,
                                height: 300,
                                child: Center(
                                  child: Text(
                                    "Congrats!!!\nYou have unlocked all the levels. You must be soooo happy now!",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    //
                  },
                  child: Text("Sure")),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.levelName),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(15),
                child: PointAndEarning(),
              ),
            ),
            body: FutureBuilder<int>(
                future: Provider.of<PointProvider>(context).getCurrentPoints(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Loading();
                  } else if (snapshot.hasError) {
                    return SomethingWentWrong();
                  } else {
                    _p = snapshot.data;

                    return Container(
                      child: FutureBuilder<QuerySnapshot>(
                        future: Provider.of<LevelProvider>(context)
                            .getLevelWallpapers(widget.levelID),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Loading();
                          } else if (snapshot.hasError) {
                            return SomethingWentWrong();
                          } else {
                            final _data = snapshot.data.docs;
                            return Column(
                              children: [
                                _wallpaperGrid(_data, context),
                                // CustomBannerAd(
                                //   ad: _ad,
                                // ),
                              ],
                            );
                          }
                        },
                      ),
                    );
                  }
                }),
          );
  }

  Expanded _wallpaperGrid(
      List<QueryDocumentSnapshot> _data, BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: _data.map((e) {
          return FutureBuilder<DocumentSnapshot>(
            future: Provider.of<UserWallpaperProvider>(context)
                .getUnlockedWallpapers(widget.levelID),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: Text("Loading..."),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error!!!"),
                );
              } else {
                List _userUnlockedData = snapshot.data.data()["items"];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      onTapWallpaper(context, _userUnlockedData, e);
                    },
                    child: GridTile(
                      footer: _userUnlockedData.contains(e.id)
                          ? Container(
                              color: mainColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              child: Center(
                                child: Text("Owned!"),
                              ))
                          : Container(
                              color: dangerColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e.data()["cost"].toString()),
                                  Icon(
                                    Icons.lock,
                                    size: 18,
                                  ),
                                ],
                              )),
                      child: Hero(
                          tag: e.id,
                          child: Image.network(
                            e.data()["url"],
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          )),
                    ),
                  ),
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
