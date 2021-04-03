import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/Auth%20Pages/login.dart';
import 'package:wantsbucks/app.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/providers/auth_provider.dart';
import 'package:wantsbucks/providers/earning_provider.dart';
import 'package:wantsbucks/providers/level_provider.dart';
import 'package:wantsbucks/providers/point_provider.dart';
import 'package:wantsbucks/providers/user_wallpaper_provider.dart';
import 'package:wantsbucks/providers/wallpaper_provider.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Provider.of<AuthProvider>(context).getUser(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.error != null) {
            print("error");
            return Text(snapshot.error.toString());
          }

          return snapshot.hasData
              ? MultiProvider(providers: [
                  ChangeNotifierProvider<WallpaperProvider>(
                      create: (_) => WallpaperProvider()),
                  ChangeNotifierProvider<UserWallpaperProvider>(
                      create: (_) => UserWallpaperProvider()),
                  ChangeNotifierProvider<PointProvider>(
                      create: (_) => PointProvider()),
                  ChangeNotifierProvider<EarningProvider>(
                      create: (_) => EarningProvider()),
                  ChangeNotifierProvider<LevelProvider>(
                      create: (_) => LevelProvider()),
                ], child: App())
              : Login();
        } else {
          // show loading indicator                                         ⇐ NEW
          return Loading();
        }
      },
    );
  }
}
