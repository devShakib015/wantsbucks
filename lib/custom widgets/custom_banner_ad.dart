import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomBannerAd extends StatelessWidget {
  final BannerAd ad;
  const CustomBannerAd({
    Key key,
    this.ad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ad == null
        ? Container(
            height: 60,
            child: Center(
              child: Text("Banner Ad"),
            ),
          )
        : Container(
            child: AdWidget(ad: ad),
            width: ad.size.width.toDouble(),
            height: ad.size.height.toDouble(),
            alignment: Alignment.center,
          );
  }
}
