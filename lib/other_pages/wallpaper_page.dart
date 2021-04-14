import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:wantsbucks/constants.dart';
import 'package:wantsbucks/custom%20widgets/custom_banner_ad.dart';
import 'package:wantsbucks/other_pages/loading.dart';

class WallpaperPage extends StatefulWidget {
  final String wallpaperUrl;
  final DocumentSnapshot data;
  WallpaperPage({this.wallpaperUrl, this.data});

  @override
  _WallpaperPageState createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  bool _settingWallpaper = false;

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
          onAdLoaded: (ad) {}),
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
  void dispose() {
    _ad?.dispose();
    _myInterstitial?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set wallpaper"),
      ),
      body: _settingWallpaper
          ? Loading()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(8),
                      child: Hero(
                        tag: widget.data.id,
                        child: Image.network(
                          widget.wallpaperUrl,
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _settingWallpaper = true;
                            });
                            if (await _myInterstitial.isLoaded()) {
                              await _myInterstitial.show();
                            }
                            int _home = WallpaperManager.HOME_SCREEN;
                            var _file = await DefaultCacheManager()
                                .getSingleFile(widget.wallpaperUrl);

                            try {
                              await WallpaperManager.setWallpaperFromFile(
                                  _file.path, _home);
                              setState(() {
                                _settingWallpaper = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Wallpaper is set successfully!")));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Error setting the wallpaper!")));
                            }
                          },
                          child: Text("Home Screen"),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _settingWallpaper = true;
                            });
                            if (await _myInterstitial.isLoaded()) {
                              await _myInterstitial.show();
                            }
                            int _lock = WallpaperManager.LOCK_SCREEN;
                            var _file = await DefaultCacheManager()
                                .getSingleFile(widget.wallpaperUrl);

                            try {
                              await WallpaperManager.setWallpaperFromFile(
                                  _file.path, _lock);
                              setState(() {
                                _settingWallpaper = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Wallpaper is set successfully!")));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Error setting the wallpaper!")));
                            }
                          },
                          child: Text("Lock Screen"),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _settingWallpaper = true;
                      });
                      if (await _myInterstitial.isLoaded()) {
                        await _myInterstitial.show();
                      }
                      int _both = WallpaperManager.BOTH_SCREENS;
                      var _file = await DefaultCacheManager()
                          .getSingleFile(widget.wallpaperUrl);

                      try {
                        await WallpaperManager.setWallpaperFromFile(
                            _file.path, _both);
                        setState(() {
                          _settingWallpaper = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Wallpaper is set successfully!")));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Error setting the wallpaper!")));
                      }
                    },
                    child: Text("Both Lock and Home Screens"),
                  ),
                ),
                CustomBannerAd(
                  ad: _ad,
                ),
              ],
            ),
    );
  }
}
