import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wantsbucks/theming/color_constants.dart';
import 'package:wantsbucks/theming/theme.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            child: SpinKitWave(
              color: mainColor,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}
