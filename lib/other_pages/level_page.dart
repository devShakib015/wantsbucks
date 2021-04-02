import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/custom%20widgets/point_and_earning.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/other_pages/something_went_wrong.dart';
import 'package:wantsbucks/other_pages/wallpaper_page.dart';
import 'package:wantsbucks/providers/level_provider.dart';
import 'package:wantsbucks/providers/user_wallpaper_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class LevelPage extends StatelessWidget {
  final String levelID;
  final String levelName;
  final int levelInterest;
  final int currentPoint;

  LevelPage(
      {this.levelID, this.levelName, this.levelInterest, this.currentPoint});

  void onTapWallpaper(BuildContext context, List und, DocumentSnapshot e) {
    if (und.contains(e.id)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WallpaperPage(
            wallpaperUrl: e.data()["url"],
          ),
        ),
      );
    } else {
      int _cost = e.data()["cost"];
      if (_cost > currentPoint) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[900],
            duration: Duration(seconds: 1),
            content: Text("Not enough point!"),
          ),
        );
      } else {
        print("Let's but it");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(levelName),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(15),
          child: PointAndEarning(),
        ),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future:
              Provider.of<LevelProvider>(context).getLevelWallpapers(levelID),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Loading();
            } else if (snapshot.hasError) {
              return SomethingWentWrong();
            } else {
              final _data = snapshot.data.docs;
              return Column(
                children: [
                  _wallpaperGrid(_data, context),
                  SizedBox(
                    height: 75,
                    child: Center(
                      child: Text("Banner Ad"),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
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
                .getUnlockedWallpapers(levelID),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: Text("Loading..."),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error..."),
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
                          ? null
                          : Container(
                              color: mainColor,
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
                      child: Image.network(
                        e.data()["url"],
                        fit: BoxFit.cover,
                      ),
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
