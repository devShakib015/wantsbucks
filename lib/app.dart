import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:wantsbucks/Nav%20Pages/dashboard.dart';
import 'package:wantsbucks/Nav%20Pages/directs.dart';
import 'package:wantsbucks/Nav%20Pages/earn.dart';
import 'package:wantsbucks/Nav%20Pages/home.dart';
import 'package:wantsbucks/Nav%20Pages/profile.dart';
import 'package:wantsbucks/custom%20widgets/custom_banner_ad.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _page = 2;
  double _iconSize = 28.0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 50.0,
        items: <Widget>[
          Icon(
            Icons.monetization_on,
            size: _iconSize,
            color: _page == 0 ? darkGreen : white,
          ),
          Icon(
            Icons.group,
            size: _iconSize,
            color: _page == 1 ? darkGreen : white,
          ),
          Icon(
            Icons.home,
            size: _iconSize,
            color: _page == 2 ? darkGreen : white,
          ),
          Icon(
            Icons.dashboard,
            size: _iconSize,
            color: _page == 3 ? darkGreen : white,
          ),
          Icon(
            Icons.person,
            size: _iconSize,
            color: _page == 4 ? darkGreen : white,
          ),
        ],
        color: mainColor,
        buttonBackgroundColor: white,
        backgroundColor: otherDark,
        animationCurve: Curves.easeInOutCubic,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Column(
        children: [
          Expanded(child: _selectedNavPage(_page)),
          CustomBannerAd(),
        ],
      ),
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
