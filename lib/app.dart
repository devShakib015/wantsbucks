import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:wantsbucks/Nav%20Pages/dashboard.dart';
import 'package:wantsbucks/Nav%20Pages/directs.dart';
import 'package:wantsbucks/Nav%20Pages/earn.dart';
import 'package:wantsbucks/Nav%20Pages/home.dart';
import 'package:wantsbucks/Nav%20Pages/profile.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _page = 2;
  double _iconSize = 25.0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.monetization_on, size: _iconSize),
          Icon(Icons.group, size: _iconSize),
          Icon(Icons.home, size: _iconSize),
          Icon(Icons.dashboard, size: _iconSize),
          Icon(Icons.person, size: _iconSize),
        ],
        color: otherDark,
        buttonBackgroundColor: mainColor,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOutCubic,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: _selectedNavPage(_page),
    );
  }

  Widget _selectedNavPage(int index) {
    if (index == 0)
      return Earn();
    else if (index == 1)
      return Direct();
    else if (index == 2)
      return Home();
    else if (index == 3)
      return Dashboard();
    else
      return Profile();
  }
}
