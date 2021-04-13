import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wantsbucks/Nav%20Pages/dashboard.dart';
import 'package:wantsbucks/Nav%20Pages/directs.dart';
import 'package:wantsbucks/Nav%20Pages/earn.dart';
import 'package:wantsbucks/Nav%20Pages/home.dart';
import 'package:wantsbucks/Nav%20Pages/profile.dart';
import 'package:wantsbucks/constants.dart';
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

  BannerAd _ad;
  InterstitialAd _myInterstitial;

  @override
  void initState() {
    super.initState();
    //TODO: - Add Interstial Ad
    _myInterstitial = InterstitialAd(
      adUnitId: admob_test_interstial,
      request: AdRequest(),
      listener: AdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    //TODO: - Add Banner Ad
    _ad = BannerAd(
      adUnitId: admob_test_banner,
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _ad.load();
    _myInterstitial.load();
  }

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
        onTap: (index) async {
          if (await _myInterstitial.isLoaded()) {
            await _myInterstitial.show();
          }
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Column(
        children: [
          Expanded(child: _selectedNavPage(_page)),
          CustomBannerAd(
            ad: _ad,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ad?.dispose();
    _myInterstitial?.dispose();

    super.dispose();
  }

  Widget _selectedNavPage(int index) {
    if (index == 0) {
      return Earn();
    } else if (index == 1) {
      //_myInterstitial.show();

      return Direct();
    } else if (index == 2) {
      //_myInterstitial.show();

      return Home();
    } else if (index == 3) {
      // _myInterstitial.show();

      return Dashboard();
    } else {
      //_myInterstitial.show();

      return Profile();
    }
  }
}
