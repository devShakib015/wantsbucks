import 'package:flutter/material.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class CustomBannerAd extends StatelessWidget {
  const CustomBannerAd({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: otherDark,
      height: 60,
      child: Center(
        child: Text("Banner Ad"),
      ),
    );
  }
}
