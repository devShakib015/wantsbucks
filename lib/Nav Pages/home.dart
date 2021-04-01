import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/custom%20widgets/point_and_earning.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/other_pages/something_went_wrong.dart';
import 'package:wantsbucks/providers/user_wallpaper_provider.dart';
import 'package:wantsbucks/providers/wallpaper_provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = [
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
                                colors, _data, e, _unlockedLevels);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Center(
                    child: Text("Banner Ad"),
                  ),
                )
              ]);
            }
          },
        ),
      ),
    );
  }

  Card _levelCard(List<Color> colors, List<QueryDocumentSnapshot> _data,
      QueryDocumentSnapshot e, List _unlockedLevels) {
    return Card(
      color: colors[_data.indexOf(e)],
      child: ListTile(
        onTap: () {
          if (_unlockedLevels.contains(e.id)) {
            print("Unlocked");
          } else {
            print("Locked");
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
