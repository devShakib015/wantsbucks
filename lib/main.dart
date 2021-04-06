import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wantsbucks/Auth%20Pages/login.dart';
import 'package:wantsbucks/app.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/other_pages/something_went_wrong.dart';
import 'package:wantsbucks/providers/auth_provider.dart';
import 'package:wantsbucks/providers/customads_provider.dart';
import 'package:wantsbucks/providers/dashboard_provider.dart';
import 'package:wantsbucks/providers/direct_provider.dart';
import 'package:wantsbucks/providers/earning_provider.dart';
import 'package:wantsbucks/providers/level_provider.dart';
import 'package:wantsbucks/providers/point_provider.dart';
import 'package:wantsbucks/providers/transfer_provider.dart';
import 'package:wantsbucks/providers/user_provider.dart';
import 'package:wantsbucks/providers/user_wallpaper_provider.dart';
import 'package:wantsbucks/providers/wallpaper_provider.dart';
import 'package:wantsbucks/theming/theme.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Phoenix(child: WantsBucksApp()));
}

class WantsBucksApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Errorrrrrrrrrrrr:${snapshot.error} ");
          return SomethingWentWrong();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MainApp();
        }

        return Loading();
      },
    );
  }
}

//! Check internet connection

Stream<bool> checkInternet() async* {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      yield true;
    }
  } on SocketException catch (_) {
    yield false;
  }
}

//! MainApp

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

Future<User> _getUser() async {
  return FirebaseAuth.instance.currentUser;
}

class _MainAppState extends State<MainApp> {
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: checkInternet(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data == false) {
          return internetConnectionWidget();
        } else
          return FutureBuilder<User>(
            future: _getUser(),
            builder: (context, AsyncSnapshot<User> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.error != null) {
                  print("error");
                  return Text(snapshot.error.toString());
                }

                return snapshot.hasData ? _appProvider() : _loginProvider();
              } else {
                return Loading();
              }
            },
          );
      },
    );
  }

  //! Providing MultiProvider

  Widget _appProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<WallpaperProvider>(
            create: (_) => WallpaperProvider()),
        ChangeNotifierProvider<PointProvider>(create: (_) => PointProvider()),
        ChangeNotifierProvider<EarningProvider>(
            create: (_) => EarningProvider()),
        ChangeNotifierProvider<UserWallpaperProvider>(
            create: (_) => UserWallpaperProvider()),
        ChangeNotifierProvider<LevelProvider>(create: (_) => LevelProvider()),
        ChangeNotifierProvider<DirectProvider>(create: (_) => DirectProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<DashboardProvider>(
            create: (_) => DashboardProvider()),
        ChangeNotifierProvider<TransferProvider>(
            create: (_) => TransferProvider()),
        ChangeNotifierProvider<CustomAdsProvider>(
            create: (_) => CustomAdsProvider()),
      ],
      child: MaterialApp(
        title: 'wantsBucks',
        debugShowCheckedModeBanner: false,
        theme: mainTheme,
        home: App(),
      ),
    );
  }

  Widget _loginProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'wantsBucks_login',
        debugShowCheckedModeBanner: false,
        theme: mainTheme,
        home: Login(),
      ),
    );
  }

  //! Showing Internet Connection is active or not

  Widget internetConnectionWidget() {
    return MaterialApp(
      theme: mainTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: (Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No internet connection."),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text("Reload"),
              )
            ],
          ),
        )),
      ),
    );
  }
}
